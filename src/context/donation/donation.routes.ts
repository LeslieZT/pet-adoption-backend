import { Router } from "express";
import { DONATION_TYPES } from "./infrastruture/ioc/donation.types";
import { donationContainer } from "./infrastruture/ioc/donation.container";
import { DonationController } from "./donation.controller";
import { AUTHENTICATION_TYPES } from "../authentication/infrastructure/ioc/authentication.types";
import { authenticationContainer } from "../authentication/infrastructure/ioc/authentication.container";
import { AuthenticationMiddleware } from "../authentication/application/middleware/authentication.middleware";
import { asyncHandler } from "../../utils/asyc-handler";

const middleware = authenticationContainer.get<AuthenticationMiddleware>(
	AUTHENTICATION_TYPES.AuthenticationMiddleware
);

const controller = donationContainer.get<DonationController>(DONATION_TYPES.DonationController);

export const donationRouter = Router();

donationRouter.post(
	"/checkout",
	middleware.authorize.bind(middleware),
	asyncHandler(controller.checkout.bind(controller))
);
donationRouter.get("/success", asyncHandler(controller.success.bind(controller)));
donationRouter.get("/cancel", asyncHandler(controller.cancel.bind(controller)));
donationRouter.get(
	"/billing/portal",
	middleware.authorize.bind(middleware),
	asyncHandler(controller.getCustomerPortal.bind(controller))
);
