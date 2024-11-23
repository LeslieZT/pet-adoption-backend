import { PlanEntity } from "../entities/Plan.entitiy";

export interface PlanRepository {
	findOne(productId: string): Promise<PlanEntity | null>;
}
