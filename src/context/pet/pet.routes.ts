import { Router } from "express";
import { petContainer } from "./infrastructure/ioc/pet.container";
import { PetController } from "./pet.controller";
import { PET_TYPES } from "./infrastructure/ioc/pet.types";
import { asyncHandler } from "../../utils/asyc-handler";
import { AUTHENTICATION_TYPES } from "../authentication/infrastructure/ioc/authentication.types";
import { authenticationContainer } from "../authentication/infrastructure/ioc/authentication.container";
import { AuthenticationMiddleware } from "../authentication/application/middleware/authentication.middleware";

export const petRoutes = Router();

const middleware = authenticationContainer.get<AuthenticationMiddleware>(
	AUTHENTICATION_TYPES.AuthenticationMiddleware
);

const controller = petContainer.get<PetController>(PET_TYPES.PetController);

petRoutes.post("/", asyncHandler(controller.findAll.bind(controller)));
petRoutes.post("/find-one", asyncHandler(controller.findOne.bind(controller)));
petRoutes.get("/breeds", asyncHandler(controller.findBreeds.bind(controller)));
petRoutes.get("/categories", asyncHandler(controller.findCategories.bind(controller)));
petRoutes.post(
	"/favorite",
	middleware.authorize.bind(middleware),
	asyncHandler(controller.getFavoritePets.bind(controller))
);
petRoutes.post(
	"/mark-favorite",
	middleware.authorize.bind(middleware),
	asyncHandler(controller.markFavoritePet.bind(controller))
);
