import { inject, injectable } from "inversify";
import { DepartmentRepository } from "../../domain/repositories/department.repository";
import { PLACE_TYPES } from "../../infrastructure/ioc/place.types";
import { ApiResponse } from "../../../../shared/classes/ApiResponse";
import { HTTP_OK } from "../../../../shared/constants/http-status.constant";

@injectable()
export class PlaceService {
	constructor(
		@inject(PLACE_TYPES.DepartmentRepository)
		private deparmentRepository: DepartmentRepository
	) {}
	async findAll(): Promise<any> {
		const queryset = await this.deparmentRepository.findAll();
		return new ApiResponse({ status: HTTP_OK, data: queryset });
	}
}
