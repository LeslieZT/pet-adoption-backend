import { Router } from "express";
import { SHELTER_TYPES } from "./infrastructure/ioc/shelter.types";
import { shelterContainer } from "./infrastructure/ioc/shelter.container";
import { ShelterController } from "./shelter.controller";
import { AUTHENTICATION_TYPES } from "../authentication/infrastructure/ioc/authentication.types";
import { authenticationContainer } from "../authentication/infrastructure/ioc/authentication.container";
import { AuthenticationMiddleware } from "../authentication/application/middleware/authentication.middleware";
import { asyncHandler } from "../../utils/asyc-handler";

const middleware = authenticationContainer.get<AuthenticationMiddleware>(
	AUTHENTICATION_TYPES.AuthenticationMiddleware
);

const controller = shelterContainer.get<ShelterController>(SHELTER_TYPES.ShelterController);

export const shelterRouter = Router();

shelterRouter.post("/search", asyncHandler(controller.searchPlacesAndShelters.bind(controller)));
