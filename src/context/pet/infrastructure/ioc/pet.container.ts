import { Container } from "inversify";
import { PET_TYPES } from "./pet.types";
import { PetController } from "../../pet.controller";
import { PetService } from "../../application/service/pet.service";
import { PetRepository } from "../../domain/repositories/pet.repository";
import { PetRepositoryImpl } from "../../infrastructure/repositories/pet.repository.impl";
import { PetCategoryRepository } from "../../domain/repositories/category.repository";
import { PetCategoryRepositoryImpl } from "../repositories/category.repository.impl";
import { BreedRepository } from "../../domain/repositories/breed.repository";
import { BreedRepositoryImpl } from "../repositories/breed.repository.impl";
import { PetFavoriteRepositoryImpl } from "../repositories/pet-favorite.repository.impl";
import { PetFavoriteRepository } from "../../domain/repositories/pet-favorite.repository";

export const petContainer = new Container();

petContainer
	.bind<PetFavoriteRepository>(PET_TYPES.PetFavoriteRepository)
	.to(PetFavoriteRepositoryImpl);
petContainer.bind<BreedRepository>(PET_TYPES.PetBreedRepository).to(BreedRepositoryImpl);
petContainer
	.bind<PetCategoryRepository>(PET_TYPES.PetCategoryRepository)
	.to(PetCategoryRepositoryImpl);
petContainer.bind<PetRepository>(PET_TYPES.PetRepository).to(PetRepositoryImpl);
petContainer.bind<PetService>(PET_TYPES.PetService).to(PetService);
petContainer.bind<PetController>(PET_TYPES.PetController).to(PetController);
