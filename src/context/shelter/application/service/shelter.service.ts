import { inject, injectable } from "inversify";
import { SHELTER_TYPES } from "../../infrastructure/ioc/shelter.types";
import { ShelterRepository } from "../../domain/repositories/shelter.repository";
import { SearchRequestDto } from "../dto";
import { ApiResponse } from "../../../../shared/classes/ApiResponse";
import { HTTP_OK } from "../../../../shared/constants/http-status.constant";
import { ShelterMapper } from "../mapper/Shelter.mapper";

@injectable()
export class ShelterService {
	constructor(
		@inject(SHELTER_TYPES.ShelterRepository)
		private shelterRepository: ShelterRepository
	) {}

	async searchPlacesAndShelters(params: SearchRequestDto): Promise<any> {
		const quersyet = await this.shelterRepository.searchPlacesAndShelters(params.search);
		const result = ShelterMapper.mapAll(quersyet);
		return new ApiResponse({ status: HTTP_OK, data: result });
	}
}
