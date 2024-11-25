import { PaymentMode } from "../../domain/enum/PaymentMode.enum";

export interface CheckoutParams {
	customerId?: string;
	priceId: string;
	mode: PaymentMode;
	donationId: string;
}

export interface CustomCheckoutParams {
	customerId?: string;
	amount: number;
	mode: PaymentMode;
	donationId: string;
}

export interface PaymentAdapter {
	checkout(params: CheckoutParams): Promise<any>;
	customCheckout(params: CustomCheckoutParams): Promise<any>;
	createCustomer(email: string, name: string): Promise<any>;
	getSession(sessionId: string): Promise<any>;
	getCustomerPortal(customerId: string): Promise<any>;
}
