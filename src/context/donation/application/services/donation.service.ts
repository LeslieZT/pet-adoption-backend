import { inject, injectable } from "inversify";
import { DONATION_TYPES } from "../../infrastruture/ioc/donation.types";
import { PaymentAdapter } from "../adapter/payment.adapter";
import { CheckoutCallbackRequestDto, CheckoutRequestDto, CustomCheckoutRequestDto } from "../dto";
import { PayloadRequest } from "../../../../shared/classes/Payload";
import { ApiResponse } from "../../../../shared/classes/ApiResponse";
import { PaymentMode } from "../../domain/enum/PaymentMode.enum";
import { UserRepository } from "../../domain/repositories/user.respository";
import { PlanRepository } from "../../domain/repositories/plan.repository";
import { DonationRepository } from "../../domain/repositories/donation.repository";
import { HTTP_NOT_FOUND, HTTP_OK } from "./../../../../shared/constants/http-status.constant";
import { CustomError, ErrorType } from "../../../../shared/error";

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

	private async getCustomer(params: CheckoutRequestDto | CustomCheckoutRequestDto) {
		const user = await this.userRepository.findOne(params.idUser, params.channel);
		if (!user) {
			throw new CustomError({
				errorType: ErrorType.VALIDATION_ERROR,
				status: HTTP_NOT_FOUND,
				message: "User not found",
			});
		}
		let customerId = user?.customerId;
		if (!customerId) {
			const customer = await this.paymentAdapter.createCustomer(
				user.email,
				`${user.firstName} ${user.lastName}`
			);
			await this.userRepository.update(user.userId, params.channel, { customerId: customer.id });
			customerId = customer.id;
		}
		return customerId;
	}

	async checkout(params: CheckoutRequestDto) {
		let customerId;

		if (params.idUser && params.channel) {
			customerId = await this.getCustomer(params);
		}
		const plan = await this.planRepository.findOne(params.code);
		if (!plan) {
			throw new CustomError({
				errorType: ErrorType.VALIDATION_ERROR,
				status: HTTP_NOT_FOUND,
				message: "Plan not found",
			});
		}
		let priceId;
		if (params.mode === PaymentMode.SUBSCRIPTION) {
			priceId = plan.codeSubscription;
		} else {
			priceId = plan.codeOneTime;
		}

		const donation = await this.donationRepository.create({
			userId: params.idUser,
			planId: plan.planId,
			amount: plan.price,
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

	async customCheckout(params: CustomCheckoutRequestDto) {
		let customerId;

		if (params.idUser && params.channel) {
			customerId = await this.getCustomer(params);
		}
		const donation = await this.donationRepository.create({
			userId: params.idUser,
			amount: params.amount,
			type: params.mode,
			status: "pending",
		});

		const result = await this.paymentAdapter.customCheckout({
			customerId,
			amount: params.amount,
			mode: params.mode,
			donationId: donation.donationId,
		});

		return new ApiResponse({ status: HTTP_OK, data: { url: result.url } });
	}

	async success(params: CheckoutCallbackRequestDto) {
		const session = await this.paymentAdapter.getSession(params.sessionId);
		const email = session?.customer_details?.email;
		const name = session?.customer_details?.name;
		if (session?.metadata?.donationId) {
			await this.donationRepository.update(session?.metadata?.donationId, {
				status: "success",
				email,
				name,
			});
			return;
		}
		throw new CustomError({
			errorType: ErrorType.VALIDATION_ERROR,
			status: HTTP_NOT_FOUND,
			message: "Donation not found",
		});
	}

	async cancel(params: CheckoutCallbackRequestDto) {
		const session = await this.paymentAdapter.getSession(params.sessionId);
		const email = session?.customer_details?.email;
		const name = session?.customer_details?.name;
		if (session?.metadata?.donationId) {
			await this.donationRepository.update(session?.metadata?.donationId, {
				status: "failed",
				email,
				name,
			});
			return;
		}
		throw new CustomError({
			errorType: ErrorType.VALIDATION_ERROR,
			status: HTTP_NOT_FOUND,
			message: "Donation not found",
		});
	}

	async getCustomerPortal(payload: PayloadRequest) {
		const user = await this.userRepository.findOne(payload.idUser, payload.channel);
		if (!user) {
			throw new CustomError({
				errorType: ErrorType.VALIDATION_ERROR,
				status: HTTP_NOT_FOUND,
				message: "User not found",
			});
		}

		let customerId = user?.customerId;
		if (!customerId) {
			throw new CustomError({
				errorType: ErrorType.VALIDATION_ERROR,
				status: HTTP_NOT_FOUND,
				message: "Customer not found",
			});
		}

		const session = await this.paymentAdapter.getCustomerPortal(customerId);
		if (!session) {
			throw new CustomError({
				errorType: ErrorType.VALIDATION_ERROR,
				status: HTTP_NOT_FOUND,
				message: "Session not found",
			});
		}
		return new ApiResponse({ status: HTTP_OK, data: { url: session.url } });
	}
}
