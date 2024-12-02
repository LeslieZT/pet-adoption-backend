import { prisma } from "../../../../database/database";
import { PetFavoriteRepository } from "../../domain/repositories/pet-favorite.repository";

export class PetFavoriteRepositoryImpl implements PetFavoriteRepository {
	async findOne(petId: number, userId: string): Promise<any> {
		const pet = await prisma.favoritePet.findFirst({
			where: { petId, userId },
		});
		return pet;
	}

	async update(favoritePetId: number, value: boolean): Promise<void> {
		await prisma.favoritePet.update({
			where: { favoritePetId },
			data: { value },
		});
	}

	async create(petId: number, userId: string, value: boolean): Promise<void> {
		await prisma.favoritePet.create({
			data: { petId, userId, value },
		});
	}
}
