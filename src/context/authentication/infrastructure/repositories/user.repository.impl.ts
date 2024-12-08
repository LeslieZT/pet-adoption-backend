import { UserEntity } from "../../domain/entity/User.entity";
import { prisma } from "../../../../database/database";
import { ChannelType } from "../../domain/enum/ChannelType.enum";
import { UserRepository } from "../../domain/repositories/user.repository";
import { User } from "@prisma/client";

export class UserRepositoryImpl implements UserRepository {
	async findUserByEmail(email: string, channel: ChannelType): Promise<UserEntity> {
		const user = (await prisma.user.findFirst({
			where: {
				email: email,
				channel: channel,
			},
		})) as unknown as UserEntity;
		return user;
	}
	async create(user: UserEntity): Promise<void> {
		const data = user as User;
		await prisma.user.create({
			data,
		});
	}
}
