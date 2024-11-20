import { Router } from "express";
import { AUTHENTICATION_TYPES } from "./infrastructure/ioc/authentication.types";
import { authenticationContainer } from "./infrastructure/ioc/authentication.container";
import AuthenticationController from "./authentication.controller";
import { AuthenticationMiddleware } from "./application/middleware/authentication.middleware";
import { asyncHandler } from "./../../utils/asyc-handler";

const controller = authenticationContainer.get<AuthenticationController>(
	AUTHENTICATION_TYPES.AuthenticationController
);
const middleware = authenticationContainer.get<AuthenticationMiddleware>(
	AUTHENTICATION_TYPES.AuthenticationMiddleware
);

export const authenticationRoutes = Router();

authenticationRoutes.post("/sign-up", asyncHandler(controller.signUp.bind(controller)));
authenticationRoutes.post("/sign-in", asyncHandler(controller.signIn.bind(controller)));
authenticationRoutes.post(
	"/sign-in/providers",
	asyncHandler(controller.signInWithOAuth.bind(controller))
);
authenticationRoutes.post(
	"/sign-in/providers/callback",
	asyncHandler(controller.signInWithOAuthCallback.bind(controller))
);
