import { PlanEntity } from "../entities/Plan.entity";

export interface PlanRepository {
	findAll(): Promise<PlanEntity[]>;
}
