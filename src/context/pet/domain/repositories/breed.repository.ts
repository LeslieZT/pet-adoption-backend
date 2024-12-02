import { PetBreed } from "../entities/PetBreed.entity";

export interface BreedRepository {
	findAll(): Promise<PetBreed[]>;
}
