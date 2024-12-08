import { injectable } from "inversify";
import { AdoptionRepository } from "../../domain/repositories/adoption.repository";
import { prisma } from "../../../../database/database";
import {
	AdoptionApplication,
	AdoptionEntity,
	UserPetApplication,
} from "../../domain/entities/adoption.entity";

@injectable()
export class AdoptionRepositoryImpl implements AdoptionRepository {
	async create(data: AdoptionEntity): Promise<any> {
		const queryset = await prisma.adoption.create({
			data,
		});
		return queryset;
	}

	async findById(id: string): Promise<AdoptionEntity> {
		const queryset = (await prisma.adoption.findUnique({
			where: {
				adoptionId: id,
			},
		})) as unknown as AdoptionEntity;
		return queryset;
	}

	async findAllByUserId(userId: string): Promise<AdoptionApplication[]> {
		const queryset = (await prisma.adoption.findMany({
			where: {
				userId,
			},
			select: {
				adoptionId: true,
				petId: true,
				pet: {
					select: {
						name: true,
						category: {
							select: {
								name: true,
							},
						},
					},
				},
				status: true,
				createdAt: true,
			},
		})) as unknown as AdoptionApplication[];
		return queryset;
	}

	async findByUser(userId: string, petId: number): Promise<UserPetApplication> {
		const queryset = (await prisma.adoption.findFirst({
			where: {
				userId,
				petId,
			},
			select: {
				adoptionId: true,
				petId: true,
				status: true,
				createdAt: true,
			},
		})) as unknown as UserPetApplication;
		return queryset;
	}
}
