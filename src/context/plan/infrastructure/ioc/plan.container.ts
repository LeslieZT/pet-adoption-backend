import { Container } from "inversify";
import { PLAN_TYPES } from "./plan.types";
import { PlanController } from "../../plan.controller";
import { PlanService } from "../../application/services/plan.service";
import { PlanRepository } from "../../domain/repositories/plan.repository";
import { PlanRepositoryImpl } from "../repositories/plan.repository.impl";

export const planContainer = new Container();
planContainer.bind<PlanRepository>(PLAN_TYPES.PlanRepository).to(PlanRepositoryImpl);
planContainer.bind<PlanService>(PLAN_TYPES.PlanService).to(PlanService);
planContainer.bind<PlanController>(PLAN_TYPES.PlanController).to(PlanController);
