import { Container } from "inversify";
import { DONATION_TYPES } from "./donation.types";
import { PlanRepository } from "../../domain/repositories/plan.repository";
import { UserRepository } from "../../domain/repositories/user.respository";
import { DonationRepository } from "../../domain/repositories/donation.repository";
import { PlanRepositoryImpl } from "../repositories/plan.repository.impl";
import { UserRepositoryImpl } from "../repositories/user.repository.impl";
import { DonationRepositoryImpl } from "../repositories/donation.repository.impl";
import { PaymentAdapter } from "../../application/adapter/payment.adapter";
import { StripePaymentAdapter } from "../adapter/payment.stripe.adpater";
import { DonationService } from "../../application/services/donation.service";
import { DonationController } from "../../donation.controller";

export const donationContainer = new Container();

donationContainer.bind<PlanRepository>(DONATION_TYPES.PlanRepository).to(PlanRepositoryImpl);
donationContainer.bind<UserRepository>(DONATION_TYPES.UserRepository).to(UserRepositoryImpl);
donationContainer
	.bind<DonationRepository>(DONATION_TYPES.DonationRepository)
	.to(DonationRepositoryImpl);
donationContainer.bind<PaymentAdapter>(DONATION_TYPES.PaymentAdapter).to(StripePaymentAdapter);
donationContainer.bind<DonationService>(DONATION_TYPES.DonationService).to(DonationService);
donationContainer
	.bind<DonationController>(DONATION_TYPES.DonationController)
	.to(DonationController);
