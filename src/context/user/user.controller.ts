import { Request, Response } from "express";
import { inject, injectable } from "inversify";
import { plainToClass } from "class-transformer";
import { USER_TYPES } from "./infrastructure/ioc/user.types";
import { ChannelType } from "../authentication/domain/enum/ChannelType.enum";
import RequestValidator from "../../utils/request-validator";
import { UpdateUserRequestDto } from "./application/dtos";
import { UserService } from "./application/services/user.service";

@injectable()
export class UserController {
	constructor(
		@inject(USER_TYPES.UserService)
		private userService: UserService
	) {}

	async findOne(req: Request, res: Response): Promise<void> {
		const channel = req.headers["x-channel"] as ChannelType;
		const payload = req["payload"];
		const response = await this.userService.findOne(channel, payload);
		res.status(response.status).json(response);
	}

	async update(req: Request, res: Response): Promise<void> {
		const channel = req.headers["x-channel"] as ChannelType;
		const payload = req["payload"];
		const updateUserDto = plainToClass(UpdateUserRequestDto, req.body);
		const error = await RequestValidator.validate(updateUserDto);
		if (error) {
			res.status(error.status).json(error);
			return;
		}
		const response = await this.userService.update(channel, payload, updateUserDto);
		res.status(response.status).json(response);
	}
}
