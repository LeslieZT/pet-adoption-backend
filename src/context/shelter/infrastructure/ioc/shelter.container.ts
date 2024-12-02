import { Container } from "inversify";
import { SHELTER_TYPES } from "./shelter.types";
import { ShelterService } from "../../application/service/shelter.service";
import { ShelterRepositoryImpl } from "../repositories/shelter.repository.impl";
import { ShelterController } from "../../shelter.controller";

export const shelterContainer = new Container();

shelterContainer.bind<ShelterController>(SHELTER_TYPES.ShelterController).to(ShelterController);
shelterContainer.bind<ShelterService>(SHELTER_TYPES.ShelterService).to(ShelterService);
shelterContainer
	.bind<ShelterRepositoryImpl>(SHELTER_TYPES.ShelterRepository)
	.to(ShelterRepositoryImpl);
