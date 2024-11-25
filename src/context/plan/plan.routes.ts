import { Router } from "express";
import { AUTHENTICATION_TYPES } from "../authentication/infrastructure/ioc/authentication.types";
import { AuthenticationMiddleware } from "../authentication/application/middleware/authentication.middleware";
import { authenticationContainer } from "../authentication/infrastructure/ioc/authentication.container";
import { PLAN_TYPES } from "./infrastructure/ioc/plan.types";
import { planContainer } from "./infrastructure/ioc/plan.container";
import { PlanController } from "./plan.controller";
import { asyncHandler } from "../../utils/asyc-handler";

const middleware = authenticationContainer.get<AuthenticationMiddleware>(
	AUTHENTICATION_TYPES.AuthenticationMiddleware
);

const controller = planContainer.get<PlanController>(PLAN_TYPES.PlanController);

export const planRouter = Router();

planRouter.get("/", asyncHandler(controller.findAll.bind(controller)));
