import { injectable } from "inversify";
import { UserRepository } from "../../domain/repositories/user.respository";
import { UserEntity } from "../../domain/entities/User.entity";
import { prisma } from "../../../../database/database";

@injectable()
export class UserRepositoryImpl implements UserRepository {
	async findOne(userId: string, channel: string): Promise<UserEntity> {
		const user = await prisma.user.findFirst({
			where: {
				userId: userId,
				channel: channel,
			},
		});
		return user;
	}

	async update(userId: string, channel: string, data: Partial<UserEntity>): Promise<void> {
		await prisma.user.update({
			where: {
				userId: userId,
				channel: channel,
			},
			data: data,
		});
	}
}
