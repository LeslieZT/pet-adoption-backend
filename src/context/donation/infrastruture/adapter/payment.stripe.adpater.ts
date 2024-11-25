import Stripe from "stripe";
import { injectable } from "inversify";
import { config } from "./../../../../config/config";
import {
	CheckoutParams,
	CustomCheckoutParams,
	PaymentAdapter,
} from "../../application/adapter/payment.adapter";

const { STRIPE_SECRET_KEY, FRONTEND_URL, BACKEND_URL } = config();

@injectable()
export class StripePaymentAdapter implements PaymentAdapter {
	private client: Stripe;

	constructor() {
		this.client = new Stripe(STRIPE_SECRET_KEY);
	}

	async checkout(params: CheckoutParams) {
		const session = await this.client.checkout.sessions.create({
			customer: params.customerId,
			payment_method_types: ["card"],
			line_items: [
				{
					price: params.priceId,
					quantity: 1,
				},
			],
			mode: params.mode,
			success_url: `${BACKEND_URL}/api/v1/donations/success?session_id={CHECKOUT_SESSION_ID}`,
			cancel_url: `${BACKEND_URL}/api/v1/donations/cancel`,
			metadata: {
				donationId: params.donationId,
			},
		});
		return session;
	}

	async customCheckout(params: CustomCheckoutParams) {
		const session = await this.client.checkout.sessions.create({
			customer: params.customerId,
			payment_method_types: ["card"],
			line_items: [
				{
					price_data: {
						currency: "USD",
						product_data: {
							name: `Pet Adoption - ${params.donationId}`,
						},
						unit_amount: params.amount * 100,
					},
					quantity: 1,
				},
			],
			mode: params.mode,
			success_url: `${BACKEND_URL}/api/v1/donations/success?session_id={CHECKOUT_SESSION_ID}`,
			cancel_url: `${BACKEND_URL}/api/v1/donations/cancel`,
			metadata: {
				donationId: params.donationId,
			},
		});
		return session;
	}

	async createCustomer(email: string, name: string) {
		const customer = await this.client.customers.create({
			email,
			name,
		});
		return customer;
	}

	async getSession(sessionId: string): Promise<Stripe.Response<Stripe.Checkout.Session>> {
		const session = await this.client.checkout.sessions.retrieve(sessionId);
		return session;
	}

	async getCustomerPortal(customerId: string) {
		const session = await this.client.billingPortal.sessions.create({
			customer: customerId,
			return_url: `${FRONTEND_URL}/account`,
		});
		return session;
	}
}
