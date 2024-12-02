import { prisma } from "../../../../database/database";
import { PetBreed } from "../../domain/entities/PetBreed.entity";
import { BreedRepository } from "../../domain/repositories/breed.repository";

export class BreedRepositoryImpl implements BreedRepository {
	async findAll(): Promise<PetBreed[]> {
		const query = await prisma.petBreed.findMany({
			select: { petBreedId: true, name: true, categoryId: true },
		});
		return query;
	}
}
