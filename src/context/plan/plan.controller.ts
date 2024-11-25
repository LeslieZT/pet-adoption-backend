import { Request, Response } from "express";
import { inject, injectable } from "inversify";
import { PLAN_TYPES } from "./infrastructure/ioc/plan.types";
import { PlanService } from "./application/services/plan.service";

@injectable()
export class PlanController {
	constructor(
		@inject(PLAN_TYPES.PlanService)
		private planService: PlanService
	) {}

	async findAll(req: Request, res: Response): Promise<void> {
		const response = await this.planService.findAll();
		res.status(response.status).json(response);
	}
}
