import { plainToClass } from "class-transformer";
import e, { Request, Response } from "express";
import { inject, injectable } from "inversify";
import {
	FindOneRequestDto,
	GetAllFavoritePetsRequestDto,
	GetAllPetsRequestDto,
	MarkFavoritePetRequestDto,
} from "./application/dto";
import RequestValidator from "../../utils/request-validator";
import { PET_TYPES } from "./infrastructure/ioc/pet.types";
import { PetService } from "./application/service/pet.service";
import { PayloadRequest } from "../../shared/classes/Payload";

@injectable()
export class PetController {
	constructor(
		@inject(PET_TYPES.PetService)
		private petService: PetService
	) {}

	async findAll(req: Request, res: Response) {
		const getAllDto = plainToClass(GetAllPetsRequestDto, req.body);
		const error = await RequestValidator.validate(getAllDto);
		if (error) {
			res.status(error.status).json(error);
			return;
		}
		const response = await this.petService.findAll(getAllDto);
		res.status(response.status).json(response);
	}

	async findOne(req: Request, res: Response) {
		const findOneDto = plainToClass(FindOneRequestDto, req.body);
		const error = await RequestValidator.validate(findOneDto);
		if (error) {
			res.status(error.status).json(error);
			return;
		}
		const response = await this.petService.findOne(findOneDto);
		res.status(response.status).json(response);
	}

	async findBreeds(req: Request, res: Response) {
		const response = await this.petService.findBreeds();
		res.status(response.status).json(response);
	}

	async findCategories(req: Request, res: Response) {
		const response = await this.petService.findCategories();
		res.status(response.status).json(response);
	}

	async getFavoritePets(req: Request, res: Response) {
		const payload: PayloadRequest = req["payload"];
		const getFavoritePetDto = plainToClass(GetAllFavoritePetsRequestDto, {
			...req.body,
			userId: payload.idUser,
		});
		const error = await RequestValidator.validate(getFavoritePetDto);
		if (error) {
			res.status(error.status).json(error);
			return;
		}
		const response = await this.petService.getFavoritePets(getFavoritePetDto);
		res.status(response.status).json(response);
	}

	async markFavoritePet(req: Request, res: Response) {
		const payload: PayloadRequest = req["payload"];
		const markFavoritePetDto = plainToClass(MarkFavoritePetRequestDto, {
			...req.body,
			userId: payload.idUser,
		});
		const error = await RequestValidator.validate(markFavoritePetDto);
		if (error) {
			res.status(error.status).json(error);
			return;
		}
		const response = await this.petService.markFavoritePet(markFavoritePetDto);
		res.status(response.status).json(response);
	}
}
