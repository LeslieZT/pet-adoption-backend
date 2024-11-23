import { inject, injectable } from "inversify";
import { DONATION_TYPES } from "../../infrastruture/ioc/donation.types";
import { PaymentAdapter } from "../adapter/payment.adapter";
import { CheckoutCallbackRequestDto, CheckoutRequestDto } from "../dto";
import { PayloadRequest } from "../../../../shared/classes/Payload";
import { ApiResponse } from "../../../../shared/classes/ApiResponse";
import { PaymentMode } from "../../domain/enum/PaymentMode.enum";
import { UserRepository } from "../../domain/repositories/user.respository";
import { PlanRepository } from "../../domain/repositories/plan.repository";
import { DonationRepository } from "../../domain/repositories/donation.repository";
import {
	HTTP_BAD_REQUEST,
	HTTP_NOT_FOUND,
	HTTP_OK,
} from "./../../../../shared/constants/http-status.constant";

@injectable()
export class DonationService {
	constructor(
		@inject(DONATION_TYPES.PaymentAdapter)
		private paymentAdapter: PaymentAdapter,

		@inject(DONATION_TYPES.UserRepository)
		private userRepository: UserRepository,

		@inject(DONATION_TYPES.PlanRepository)
		private planRepository: PlanRepository,

		@inject(DONATION_TYPES.DonationRepository)
		private donationRepository: DonationRepository
	) {}

	async checkeout(payload: PayloadRequest, params: CheckoutRequestDto) {
		const user = await this.userRepository.findOne(payload.idUser, payload.channel);
		if (!user) {
			return new ApiResponse({ status: HTTP_NOT_FOUND, data: { message: "User not found" } });
		}

		const plan = await this.planRepository.findOne(params.code);
		if (!plan) {
			return new ApiResponse({ status: HTTP_BAD_REQUEST, data: { message: "Plan not found" } });
		}

		let customerId = user?.customerId;
		if (!customerId) {
			const customer = await this.paymentAdapter.createCustomer(
				user.email,
				`${user.firstName} ${user.lastName}`
			);
			customerId = customer.id;
			await this.userRepository.update(user.userId, payload.channel, { customerId });
		}

		let priceId;
		if (params.mode === PaymentMode.SUBSCRIPTION) {
			priceId = plan.codeSubscription;
		} else {
			priceId = plan.codeOneTime;
		}

		const donation = await this.donationRepository.create({
			userId: payload.idUser,
			planId: plan.planId,
			amount: params.amount || plan.price,
			type: params.mode,
			status: "pending",
		});

		const result = await this.paymentAdapter.checkout({
			customerId,
			priceId,
			mode: params.mode,
			donationId: donation.donationId,
		});
		return new ApiResponse({ status: HTTP_OK, data: { url: result.url } });
	}

	async success(params: CheckoutCallbackRequestDto) {
		const session = await this.paymentAdapter.getSession(params.sessionId);
		if (session?.metadata?.donationId) {
			await this.donationRepository.update(session?.metadata?.donationId, { status: "success" });
			return;
		}
		throw new Error("Donation not found");
	}

	async cancel(params: CheckoutCallbackRequestDto) {
		const session = await this.paymentAdapter.getSession(params.sessionId);
		if (session?.metadata?.donationId) {
			await this.donationRepository.update(session?.metadata?.donationId, { status: "failed" });
			return;
		}
		throw new Error("Donation not found");
	}

	async getCustomerPortal(payload: PayloadRequest) {
		const user = await this.userRepository.findOne(payload.idUser, payload.channel);
		if (!user) {
			return new ApiResponse({ status: HTTP_NOT_FOUND, data: { message: "User not found" } });
		}

		let customerId = user?.customerId;
		if (!customerId) {
			return new ApiResponse({ status: HTTP_NOT_FOUND, data: { message: "Customer not found" } });
		}

		const session = await this.paymentAdapter.getCustomerPortal(customerId);
		if (!session) {
			return new ApiResponse({ status: HTTP_NOT_FOUND, data: { message: "Session not found" } });
		}
		return new ApiResponse({ status: HTTP_OK, data: { url: session.url } });
	}
}
