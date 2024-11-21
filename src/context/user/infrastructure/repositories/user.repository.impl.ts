import { injectable } from "inversify";
import { prisma } from "../../../../database/database";
import { UserEntity } from "../../domain/entities/User.entity";
import { UserRepository } from "../../domain/repositories/user.repository";
import { DistrictEntity } from "../../domain/entities/District.entity";

@injectable()
export class UserRepositoryImpl implements UserRepository {
	async findOne(
		userId: string,
		channel: string
	): Promise<UserEntity & { district: DistrictEntity }> {
		const user = await prisma.user.findFirst({
			where: {
				userId: userId,
				channel: channel,
			},
			include: {
				district: true,
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
