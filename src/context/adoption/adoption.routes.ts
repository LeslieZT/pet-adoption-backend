import { Router } from "express";
import { AdoptionController } from "./adoption.controller";
import { ADOPTION_TYPES } from "./infrastructure/ioc/adoption.types";
import { adoptionContainer } from "./infrastructure/ioc/adoption.container";
import { AUTHENTICATION_TYPES } from "../authentication/infrastructure/ioc/authentication.types";
import { authenticationContainer } from "../authentication/infrastructure/ioc/authentication.container";
import { AuthenticationMiddleware } from "../authentication/application/middleware/authentication.middleware";

const middleware = authenticationContainer.get<AuthenticationMiddleware>(
	AUTHENTICATION_TYPES.AuthenticationMiddleware
);

const controller = adoptionContainer.get<AdoptionController>(ADOPTION_TYPES.AdoptionController);

export const adoptionRoutes = Router();

adoptionRoutes.get(
	"/applications",
	middleware.authorize.bind(middleware),
	controller.findAll.bind(controller)
);

adoptionRoutes.post(
	"/applications",
	middleware.authorize.bind(middleware),
	controller.create.bind(controller)
);
