import { injectable } from "inversify";
import { DonationRepository } from "../../domain/repositories/donation.repository";
import {
	DonationCreation,
	DonationEntity,
	DonationList,
} from "../../domain/entities/Donation.entity";
import { prisma } from "../../../../database/database";

@injectable()
export class DonationRepositoryImpl implements DonationRepository {
	async create(params: DonationCreation): Promise<DonationEntity> {
		const donation = await prisma.donation.create({
			data: params,
		});
		return donation;
	}
	async update(donationId: string, data: Partial<DonationEntity>): Promise<void> {
		await prisma.donation.update({
			where: {
				donationId: donationId,
			},
			data: data,
		});
	}

	async findAllByUser(userId: string): Promise<DonationList[]> {
		const donations = (await prisma.donation.findMany({
			where: {
				userId: userId,
				status: {
					not: "pending",
				},
			},
			select: {
				donationId: true,
				plan: {
					select: {
						name: true,
						price: true,
					},
				},
				type: true,
				status: true,
				createdAt: true,
			},
		})) as unknown as DonationList[];
		return donations;
	}
}
