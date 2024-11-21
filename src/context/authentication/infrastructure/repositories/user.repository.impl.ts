import { UserEntity } from "../../domain/entity/User.entity";
import { prisma } from "../../../../database/database";
import { ChannelType } from "../../domain/enum/ChannelType.enum";
import { UserRepository } from "../../domain/repositories/user.repository";

export class UserRepositoryImpl implements UserRepository {
	async findUserByEmail(email: string, channel: ChannelType): Promise<UserEntity> {
		const user = await prisma.user.findFirst({
			where: {
				email: email,
				channel: channel,
			},
		});
		return user;
	}
	async create(user: UserEntity): Promise<void> {
		await prisma.user.create({
			data: user,
		});
	}
}
