import { inject, injectable } from "inversify";
import { PlanRepository } from "../../domain/repositories/plan.repository";
import { PLAN_TYPES } from "../../infrastructure/ioc/plan.types";
import { ApiResponse } from "../../../../shared/classes/ApiResponse";
import { HTTP_OK } from "../../../../shared/constants/http-status.constant";
import { PlanMapper } from "../mapper/plan.mapper";

@injectable()
export class PlanService {
	constructor(
		@inject(PLAN_TYPES.PlanRepository)
		private planRepository: PlanRepository
	) {}
	async findAll(): Promise<any> {
		const queryset = await this.planRepository.findAll();
		return new ApiResponse({ status: HTTP_OK, data: PlanMapper.mapAll(queryset) });
	}
}
