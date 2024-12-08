import { inject, injectable } from "inversify";
import { AdoptionRepository } from "../../domain/repositories/adoption.repository";
import { ADOPTION_TYPES } from "../../infrastructure/ioc/adoption.types";
import { CreateAdoptionRequestDto } from "../dto";
import { ApiResponse } from "../../../../shared/classes/ApiResponse";
import { HTTP_BAD_REQUEST, HTTP_CREATED } from "../../../../shared/constants/http-status.constant";
import { AdoptionMapper } from "../mapper/adoption.mapper";
import { AdoptionEntity } from "../../domain/entities/adoption.entity";

@injectable()
export class AdoptionService {
	constructor(
		@inject(ADOPTION_TYPES.AdoptionRepository)
		private adoptionRepository: AdoptionRepository
	) {}

	async findAll({ userId }: { userId: string }): Promise<ApiResponse> {
		const response = await this.adoptionRepository.findAllByUserId(userId);
		return new ApiResponse({ status: HTTP_CREATED, data: AdoptionMapper.mapAll(response) });
	}

	async create(data: CreateAdoptionRequestDto): Promise<ApiResponse> {
		const application = await this.adoptionRepository.findByUser(data.userId, data.petId);
		if (application) {
			return new ApiResponse({
				status: HTTP_BAD_REQUEST,
				error: {
					message: "You already have an application for this pet",
				},
			});
		}

		this.adoptionRepository.create({ ...data, status: "pending" } as AdoptionEntity);
		return new ApiResponse({
			status: HTTP_CREATED,
			data: {
				message: "Adoption created successfully",
			},
		});
	}
}
