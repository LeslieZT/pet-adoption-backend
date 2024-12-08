import { Request, Response } from "express";
import { plainToClass } from "class-transformer";
import { inject, injectable } from "inversify";
import { config } from "../../config/config";
import { DONATION_TYPES } from "./infrastruture/ioc/donation.types";
import { DonationService } from "./application/services/donation.service";
import {
	CheckoutCallbackRequestDto,
	CheckoutRequestDto,
	CustomCheckoutRequestDto,
} from "./application/dto";
import RequestValidator from "../../utils/request-validator";

const { FRONTEND_URL } = config();

@injectable()
export class DonationController {
	constructor(
		@inject(DONATION_TYPES.DonationService)
		private donationService: DonationService
	) {}

	async checkout(req: Request, res: Response) {
		const checkoutDto = plainToClass(CheckoutRequestDto, req.body);
		const error = await RequestValidator.validate(checkoutDto);
		if (error) {
			res.status(error.status).json(error);
			return;
		}
		const response = await this.donationService.checkout(checkoutDto);
		res.status(response.status).json(response);
	}

	async customCheckout(req: Request, res: Response) {
		const checkoutDto = plainToClass(CustomCheckoutRequestDto, req.body);
		const error = await RequestValidator.validate(checkoutDto);
		if (error) {
			res.status(error.status).json(error);
			return;
		}
		const response = await this.donationService.customCheckout(checkoutDto);
		res.status(response.status).json(response);
	}

	async success(req: Request, res: Response) {
		const checkoutCbDto = plainToClass(CheckoutCallbackRequestDto, {
			sessionId: req.query.session_id,
		});
		const error = await RequestValidator.validate(checkoutCbDto);
		if (error) {
			res.status(error.status).json(error);
			return;
		}
		await this.donationService.success(checkoutCbDto);
		res.redirect(`${FRONTEND_URL}/donate/success`);
	}

	async cancel(req: Request, res: Response) {
		const checkoutCbDto = plainToClass(CheckoutCallbackRequestDto, {
			sessionId: req.query.session_id,
		});
		const error = await RequestValidator.validate(checkoutCbDto);
		if (error) {
			res.status(error.status).json(error);
			return;
		}
		await this.donationService.cancel(checkoutCbDto);
		res.redirect(`${FRONTEND_URL}/donate/cancel`);
	}

	async getCustomerPortal(req: Request, res: Response) {
		const payload = req["payload"];
		const response = await this.donationService.getCustomerPortal(payload);
		res.status(response.status).json(response);
	}

	async getDonationByUser(req: Request, res: Response) {
		const payload = req["payload"];
		const response = await this.donationService.getDonationByUser(payload);
		res.status(response.status).json(response);
	}
}
