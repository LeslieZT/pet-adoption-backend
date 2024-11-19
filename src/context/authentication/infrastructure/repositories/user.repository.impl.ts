import { prisma } from "../../../../database/database";
import { User, CreateUser } from "../../domain/entity/User.entity";
import { ChannelType } from "../../domain/enum/ChannelType.enum";
import { UserRepository } from "../../domain/repository/user.repository";

export class UserRepositoryImpl implements UserRepository {
	async findUserByEmail(email: string, channel: ChannelType): Promise<User> {
		const user = await prisma.user.findFirst({
			where: {
				email: email,
				channel: channel,
			},
		});
		return user;
	}
	async create(user: CreateUser): Promise<void> {
		await prisma.user.create({
			data: user,
		});
	
	}
}
