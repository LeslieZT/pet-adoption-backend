import { Container } from "inversify";
import { PLACE_TYPES } from "./place.types";
import { DepartmentRepository } from "../../domain/repositories/department.repository";
import { PlaceService } from "../../application/services/place.service";
import { PlaceController } from "../../place.controller";
import { DepartmentRepositoryImpl } from "../repositories/departament.repository.impl";

export const placeContainer = new Container();
placeContainer
	.bind<DepartmentRepository>(PLACE_TYPES.DepartmentRepository)
	.to(DepartmentRepositoryImpl);
placeContainer.bind<PlaceService>(PLACE_TYPES.PlaceService).to(PlaceService);
placeContainer.bind<PlaceController>(PLACE_TYPES.PlaceController).to(PlaceController);
