import { injectable } from "inversify";
import { prisma } from "../../../../database/database";
import { PlanEntity } from "../../domain/entities/Plan.entitiy";
import { PlanRepository } from "../../domain/repositories/plan.repository";

@injectable()
export class PlanRepositoryImpl implements PlanRepository {
	async findOne(productId: string): Promise<PlanEntity | null> {
		const plan = await prisma.plan.findFirst({
			where: {
				productId,
			},
		});
		return plan;
	}
}
