import { Pet } from "./../../../../../node_modules/.prisma/client/index.d";
import { inject, injectable } from "inversify";
import {
	FindOneRequestDto,
	GetAllFavoritePetsRequestDto,
	GetAllPetsRequestDto,
	MarkFavoritePetRequestDto,
} from "../dto";
import { PET_TYPES } from "../../infrastructure/ioc/pet.types";
import { FindAllParams, PetRepository } from "../../domain/repositories/pet.repository";
import { ApiResponse } from "../../../../shared/classes/ApiResponse";
import { HTTP_NOT_FOUND, HTTP_OK } from "../../../../shared/constants/http-status.constant";
import { FIELD_FILTER } from "../../domain/constants/fieldFilter";
import { PetMapper } from "../mapper/Pet.mapper";
import { BreedRepository } from "../../domain/repositories/breed.repository";
import { PetCategoryRepository } from "../../domain/repositories/category.repository";
import { CustomError, ErrorType } from "../../../../shared/error";
import { PetFavoriteRepository } from "../../domain/repositories/pet-favorite.repository";

@injectable()
export class PetService {
	constructor(
		@inject(PET_TYPES.PetRepository)
		private petRepository: PetRepository,

		@inject(PET_TYPES.PetBreedRepository)
		private petBreedRepository: BreedRepository,

		@inject(PET_TYPES.PetCategoryRepository)
		private petCategoryRepository: PetCategoryRepository,

		@inject(PET_TYPES.PetFavoriteRepository)
		private petFavoriteRepository: PetFavoriteRepository
	) {}

	async findAll(params: GetAllPetsRequestDto): Promise<ApiResponse> {
		const offset = (params.page - 1) * params.limit;
		const filters: FindAllParams = {
			idUser: params.idUser,
			location: params.location,
			petType: params.petType,
			gender: params.gender,
			age: params.age,
			limit: params.limit,
			offset,
		};

		if ((params.location && params.option) || (params.option && !params.location)) {
			filters.option = {
				id: params.option.placeId,
				field: FIELD_FILTER[params.option.placeLevel],
			};
		} else if (params.location) {
			filters.location = params.location;
		}
		const { rows, total } = await this.petRepository.findAll(filters);
		const idsPet = rows.map((pet) => pet.pet_id);
		let countApplication = {};
		if (idsPet.length > 0) {
			const querysetCount = await this.petRepository.countApplications(idsPet);
			countApplication = PetMapper.mapApplications(querysetCount);
		}
		const pets = PetMapper.mapPets(rows, countApplication);
		const response = new ApiResponse({ status: HTTP_OK, data: { total, data: pets } });
		return response;
	}

	async findOne(findOneDto: FindOneRequestDto): Promise<ApiResponse> {
		const { petId, userId } = findOneDto;
		const pet = await this.petRepository.findOne(petId);
		let isFavorite = false;
		if (userId) {
			const result = await this.petFavoriteRepository.findOne(petId, userId);
			isFavorite = result ? result.value : false;
		}
		const applications = await this.petRepository.getPetApplications(petId);
		const months = await this.petRepository.getPetMonths(petId);
		const response = new ApiResponse({
			status: HTTP_OK,
			data: PetMapper.mapPet(pet, isFavorite, applications, months),
		});
		return response;
	}

	async findBreeds(): Promise<ApiResponse> {
		const breeds = await this.petBreedRepository.findAll();
		const response = new ApiResponse({ status: HTTP_OK, data: PetMapper.mapBreeds(breeds) });
		return response;
	}

	async findCategories(): Promise<ApiResponse> {
		const categories = await this.petCategoryRepository.findAll();

		const response = new ApiResponse({
			status: HTTP_OK,
			data: PetMapper.mapCategories(categories),
		});
		return response;
	}

	async getFavoritePets(params: GetAllFavoritePetsRequestDto): Promise<ApiResponse> {
		const offset = (params.page - 1) * params.limit;
		const { rows, total } = await this.petRepository.findAllFavorite({
			userId: params.userId,
			offset,
			limit: params.limit,
		});
		const idsPet = rows.map((pet) => pet.pet_id);
		let countApplication = {};
		if (idsPet.length > 0) {
			const querysetCount = await this.petRepository.countApplications(idsPet);
			countApplication = PetMapper.mapApplications(querysetCount);
		}
		const pets = PetMapper.mapPets(rows, countApplication);
		const response = new ApiResponse({ status: HTTP_OK, data: { total, data: pets } });
		return response;
	}

	async markFavoritePet(params: MarkFavoritePetRequestDto): Promise<ApiResponse> {
		const pet = await this.petRepository.findOne(params.petId);
		if (!pet) {
			throw new CustomError({
				status: HTTP_NOT_FOUND,
				errorType: ErrorType.VALIDATION_ERROR,
				message: "Pet not found",
			});
		}

		const petFavorite = await this.petFavoriteRepository.findOne(params.petId, params.userId);

		if (petFavorite) {
			await this.petFavoriteRepository.update(petFavorite.favoritePetId, params.value);
		} else {
			await this.petFavoriteRepository.create(params.petId, params.userId, params.value);
		}

		return new ApiResponse({ status: HTTP_OK, data: { message: "Pet marked as favorite" } });
	}
}
