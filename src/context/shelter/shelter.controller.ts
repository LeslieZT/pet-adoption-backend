import { Request, Response } from "express";
import { inject, injectable } from "inversify";
import { SHELTER_TYPES } from "./infrastructure/ioc/shelter.types";
import { ShelterService } from "./application/service/shelter.service";
import { plainToClass } from "class-transformer";
import RequestValidator from "../../utils/request-validator";
import { SearchRequestDto } from "./application/dto";

@injectable()
export class ShelterController {
	constructor(
		@inject(SHELTER_TYPES.ShelterService)
		private shelterService: ShelterService
	) {}

	async searchPlacesAndShelters(req: Request, res: Response) {
		const searchDto = plainToClass(SearchRequestDto, req.body);
		const error = await RequestValidator.validate(searchDto);
		if (error) {
			res.status(error.status).json(error);
			return;
		}
		const response = await this.shelterService.searchPlacesAndShelters(searchDto);
		res.status(response.status).json(response);
	}
}
