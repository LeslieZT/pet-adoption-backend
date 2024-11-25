import { injectable } from "inversify";
import { prisma } from "../../../../database/database";
import { PlanRepository } from "../../domain/repositories/plan.repository";
import { PlanEntity } from "../../domain/entities/Plan.entity";

@injectable()
export class PlanRepositoryImpl implements PlanRepository {
	async findAll(): Promise<PlanEntity[]> {
		const queryset = await prisma.plan.findMany({
			orderBy: {
				price: "asc",
			},
		});
		return queryset;
	}
}
