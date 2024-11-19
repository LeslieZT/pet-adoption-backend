import { Request, Response } from "express";
import { inject, injectable } from "inversify";
import { plainToClass } from "class-transformer";
import {
	SignInRequestDto,
	SignInWithOAuthCallbackRequest,
	SignInWithOAuthRequest,
	SignUpRequestDto,
} from "./application/dtos";
import RequestValidator from "../../utils/request-validator";
import { ChannelType } from "./domain/enum/ChannelType.enum";
import { AUTHENTICATION_TYPES } from "./infrastructure/ioc/authentication.types";
import AuthenticationService from "./application/services/authentication.service";
import { PayloadRequest } from "../../shared/classes/Payload";

@injectable()
export default class AuthenticationController {
	constructor(
		@inject(AUTHENTICATION_TYPES.AuthenticationService)
		private authenticationService: AuthenticationService
	) {}

	async signUp(req: Request, res: Response): Promise<void> {
		const channel = req.headers["x-channel"] as ChannelType;
		const signUpDto = plainToClass(SignUpRequestDto, req.body);
		const error = await RequestValidator.validate(signUpDto);
		if (error) {
			res.status(error.status).json(error);
			return;
		}
		const response = await this.authenticationService.signUp(channel, signUpDto);
		res.status(response.status).json(response);
	}

	async signIn(req: Request, res: Response): Promise<void> {
		const channel = req.headers["x-channel"] as ChannelType;
		const signInDto = plainToClass(SignInRequestDto, req.body);
		const error = await RequestValidator.validate(signInDto);
		if (error) {
			res.status(error.status).json(error);
			return;
		}
		const response = await this.authenticationService.signIn(channel, signInDto);
		res.status(response.status).json(response);
	}

	async signInWithOAuth(req: Request, res: Response): Promise<void> {
		const channel = req.headers["x-channel"] as ChannelType;
		const signInDto = plainToClass(SignInWithOAuthRequest, req.body);
		const error = await RequestValidator.validate(signInDto);
		if (error) {
			res.status(error.status).json(error);
			return;
		}
		const response = await this.authenticationService.signInWithOAuth(channel, signInDto);
		res.status(response.status).json(response);
	}

	async signInWithOAuthCallback(req: Request, res: Response): Promise<void> {
		const payload = req["payload"] as PayloadRequest;
		const signInCallbackDto = plainToClass(SignInWithOAuthCallbackRequest, {
			...req.params,
			accessToken: payload.token,
		});
		const error = await RequestValidator.validate(signInCallbackDto);
		if (error) {
			res.status(error.status).json(error);
			return;
		}
		const response = await this.authenticationService.signInWithOAuthCallback(
			payload,
			signInCallbackDto
		);
		res.status(response.status).json(response);
	}
}
