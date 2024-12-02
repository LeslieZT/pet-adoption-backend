import { PetCategory } from "../entities/PetCategory.entity";

export interface PetCategoryRepository {
	findAll(): Promise<PetCategory[]>;
}
