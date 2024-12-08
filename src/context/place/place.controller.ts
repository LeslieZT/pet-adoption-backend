import { Request, Response } from "express";
import { inject, injectable } from "inversify";
import { PLACE_TYPES } from "./infrastructure/ioc/place.types";
import { PlaceService } from "./application/services/place.service";

@injectable()
export class PlaceController {
	constructor(
		@inject(PLACE_TYPES.PlaceService)
		private placeService: PlaceService
	) {}

	async findAll(req: Request, res: Response): Promise<void> {
		const response = await this.placeService.findAll();
		res.status(response.status).json(response);
	}
}
