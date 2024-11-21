import { inject, injectable } from "inversify";
import { UserRepository } from "../../domain/repositories/user.repository";
import { USER_TYPES } from "../../infrastructure/ioc/user.types";
import { PayloadRequest } from "../../../../shared/classes/Payload";
import { ApiResponse } from "../../../../shared/classes/ApiResponse";
import { HTTP_NOT_FOUND, HTTP_OK } from "../../../../shared/constants/http-status.constant";
import { UpdateUserRequestDto } from "../dtos";
import { UserMapper } from "../mapper/user.mapper";

@injectable()
export class UserService {
	constructor(
		@inject(USER_TYPES.UserRepository)
		private userRepository: UserRepository
	) {}
	async findOne(channel: string, payload: PayloadRequest): Promise<any> {
		const user = await this.userRepository.findOne(payload.idUser, channel);
		if (!user) {
			return new ApiResponse({ status: HTTP_NOT_FOUND, data: { message: "User not found" } });
		}
		return new ApiResponse({ status: HTTP_OK, data: UserMapper.map(user) });
	}

	async update(channel: string, payload: PayloadRequest, data: UpdateUserRequestDto): Promise<any> {
		const user = await this.userRepository.findOne(payload.idUser, channel);
		if (!user) {
			return new ApiResponse({ status: HTTP_NOT_FOUND, data: { message: "User not found" } });
		}
		if (data.birthdate) {
			data.birthdate = new Date(data.birthdate);
		}
		await this.userRepository.update(payload.idUser, channel, data);
		return new ApiResponse({ status: HTTP_OK, data: { message: "User updated successfully" } });
	}
}
