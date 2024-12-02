import { prisma } from "../../../../database/database";
import { PetCategory } from "../../domain/entities/PetCategory.entity";
import { PetCategoryRepository } from "../../domain/repositories/category.repository";

export class PetCategoryRepositoryImpl implements PetCategoryRepository {
	async findAll(): Promise<PetCategory[]> {
		const query = await prisma.petCategory.findMany({
			select: { petCategoryId: true, name: true },
		});
		return query;
	}
}
