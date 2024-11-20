import { inject, injectable } from "inversify";
import {
	HTTP_BAD_REQUEST,
	HTTP_CREATED,
	HTTP_OK,
	HTTP_UNAUTHORIZED,
} from "../../../../shared/constants/http-status.constant";
import { ApiResponse } from "../../../../shared/classes/ApiResponse";
import {
	SignInRequestDto,
	SignInWithOAuthCallbackRequest,
	SignInWithOAuthRequest,
	SignUpRequestDto,
} from "../dtos";
import { AUTHENTICATION_TYPES } from "../../infrastructure/ioc/authentication.types";
import { ChannelType } from "./../../domain/enum/ChannelType.enum";
import { UserRepository } from "../../domain/repository/user.repository";
import { AuthenticationProvider } from "../adapter/authentication-provider.adapter";
import { BcryptManager } from "../adapter/bcrypt-manager.adapter";
import { CustomError } from "../../../../shared/error/CustomError";
import { ErrorType } from "../../../../shared/error/error.type";
import { PayloadRequest } from "../../../../shared/classes/Payload";

@injectable()
export default class AuthenticationService {
	constructor(
		@inject(AUTHENTICATION_TYPES.UserRepository)
		private userRepository: UserRepository,
		@inject(AUTHENTICATION_TYPES.AuthenticationProvider)
		private authenticationProvider: AuthenticationProvider,
		@inject(AUTHENTICATION_TYPES.BcryptManager)
		private bcryptManager: BcryptManager
	) {}

	async signIn(channel: ChannelType, params: SignInRequestDto): Promise<ApiResponse> {
		const existUser = await this.userRepository.findUserByEmail(params.email, channel);
		if (!existUser) {
			throw new CustomError({
				status: HTTP_UNAUTHORIZED,
				errorType: ErrorType.AUTHENTICATION_ERROR,
				message: "Invalid email or password",
			});
		}
		const data = await this.authenticationProvider.signIn({
			email: params.email,
			password: params.password,
		});
		const { user, ...session } = data;
		const result = {
			accessToken: session.access_token,
			refreshToken: session.refresh_token,
			expiresIn: session.expires_in,
			expiresAt: session.expires_at,
		};
		const response = new ApiResponse({ status: HTTP_OK, data: result });
		return response;
	}

	async signUp(channel: ChannelType, params: SignUpRequestDto): Promise<ApiResponse> {
		const existUser = await this.userRepository.findUserByEmail(params.email, channel);
		if (existUser) {
			throw new CustomError({
				status: HTTP_BAD_REQUEST,
				errorType: ErrorType.AUTHENTICATION_ERROR,
				message: "Email already exists",
			});
		}
		const authData = await this.authenticationProvider.signUp({
			email: params.email,
			password: params.password,
			metadata: { channel },
		});
		const password = await this.bcryptManager.hash(params.password);
		await this.userRepository.create({
			userId: authData.id,
			...params,
			password,
			channel: channel,
		});
		const response = new ApiResponse({
			status: HTTP_CREATED,
			data: { message: "User created successfully" },
		});
		return response;
	}

	async signInWithOAuth(
		channel: ChannelType,
		params: SignInWithOAuthRequest
	): Promise<ApiResponse> {
		const data = await this.authenticationProvider.signInWithOAuth({
			channel,
			provider: params.provider,
		});
		return new ApiResponse({
			status: HTTP_OK,
			data,
		});
	}

	async signInWithOAuthCallback(
		channel: ChannelType,
		params: SignInWithOAuthCallbackRequest
	): Promise<ApiResponse> {
		const data = await this.authenticationProvider.getUser(params.accessToken);
		if (params.provider === data.app_metadata.provider) {
			const user = await this.userRepository.findUserByEmail(data.email, channel);
			if (!user) {
				await this.userRepository.create({
					userId: data.id,
					firstName: data.user_metadata.full_name,
					lastName: "",
					avatar: data.user_metadata.avatar_url,
					email: data.email,
					password: "",
					channel: channel,
				});
				return new ApiResponse({
					status: HTTP_CREATED,
					data: {
						message: "User created successfully",
					},
				});
			}
		}
		return new ApiResponse({
			status: HTTP_OK,
			data: {
				message: "Ok",
			},
		});
	}
}
