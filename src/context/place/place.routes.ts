import { Router } from "express";
import { PLACE_TYPES } from "./infrastructure/ioc/place.types";
import { placeContainer } from "./infrastructure/ioc/place.container";
import { PlaceController } from "./place.controller";
import { asyncHandler } from "../../utils/asyc-handler";

const controller = placeContainer.get<PlaceController>(PLACE_TYPES.PlaceController);

export const placeRouter = Router();

placeRouter.get("/departments", asyncHandler(controller.findAll.bind(controller)));
