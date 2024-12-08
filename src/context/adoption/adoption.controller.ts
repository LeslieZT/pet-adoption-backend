import { inject, injectable } from "inversify";
import { Request, Response } from "express";
import { plainToClass } from "class-transformer";
import { CreateAdoptionRequestDto } from "./application/dto";
import RequestValidator from "../../utils/request-validator";
import { ADOPTION_TYPES } from "./infrastructure/ioc/adoption.types";
import { AdoptionService } from "./application/services/adoption.service";
import { PayloadRequest } from "../../shared/classes/Payload";

@injectable()
export class AdoptionController {
	constructor(
		@inject(ADOPTION_TYPES.AdoptionService)
		private adoptionService: AdoptionService
	) {}

	async findAll(req: Request, res: Response): Promise<void> {
		const payload = req["payload"];
		const response = await this.adoptionService.findAll({ userId: payload.idUser });
		res.status(response.status).json(response);
	}

	async create(req: Request, res: Response): Promise<void> {
		const payload = req["payload"] as PayloadRequest;
		const createAdoptionDto = plainToClass(CreateAdoptionRequestDto, {
			...req.body,
			userId: payload.idUser,
		});
		const error = await RequestValidator.validate(createAdoptionDto);
		if (error) {
			res.status(error.status).json(error);
			return;
		}
		const response = await this.adoptionService.create(createAdoptionDto);
		res.status(response.status).json(response);
	}
}
