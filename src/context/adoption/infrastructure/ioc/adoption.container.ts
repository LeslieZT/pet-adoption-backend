import { Container } from "inversify";
import { AdoptionController } from "../../../adoption/adoption.controller";
import { AdoptionService } from "../../application/services/adoption.service";
import { AdoptionRepositoryImpl } from "../repositories/adoption.repository.impl";
import { AdoptionRepository } from "../../domain/repositories/adoption.repository";

import { ADOPTION_TYPES } from "./adoption.types";

export const adoptionContainer = new Container();
adoptionContainer
	.bind<AdoptionRepository>(ADOPTION_TYPES.AdoptionRepository)
	.to(AdoptionRepositoryImpl);
adoptionContainer.bind<AdoptionService>(ADOPTION_TYPES.AdoptionService).to(AdoptionService);
adoptionContainer
	.bind<AdoptionController>(ADOPTION_TYPES.AdoptionController)
	.to(AdoptionController);
