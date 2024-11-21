import { Router } from "express";
import { AUTHENTICATION_TYPES } from "../authentication/infrastructure/ioc/authentication.types";
import { AuthenticationMiddleware } from "../authentication/application/middleware/authentication.middleware";
import { authenticationContainer } from "../authentication/infrastructure/ioc/authentication.container";
import { USER_TYPES } from "./infrastructure/ioc/user.types";
import { userContainer } from "./infrastructure/ioc/user.container";
import { UserController } from "./user.controller";
import { asyncHandler } from "../../utils/asyc-handler";

const middleware = authenticationContainer.get<AuthenticationMiddleware>(
	AUTHENTICATION_TYPES.AuthenticationMiddleware
);

const controller = userContainer.get<UserController>(USER_TYPES.UserController);

export const userRoutes = Router();

userRoutes.get(
	"/profile",
	middleware.authorize.bind(middleware),
	asyncHandler(controller.findOne.bind(controller))
);
userRoutes.put(
	"/profile",
	middleware.authorize.bind(middleware),
	asyncHandler(controller.update.bind(controller))
);
