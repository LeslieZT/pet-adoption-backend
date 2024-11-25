import { PlanEntity } from "../../domain/entities/Plan.entity";
import { PlanResponseDto } from "../dto";

export class PlanMapper {
	static mapAll(queryset: PlanEntity[]): PlanResponseDto[] {
		return queryset.map(PlanMapper.map);
	}
	static map(data: PlanEntity): PlanResponseDto {
		return {
			productId: data.productId,
			name: data.name,
			title: data.title,
			description: data.description,
			price: data.price as unknown as number,
			isPolular: data.isPolular,
		};
	}
}
