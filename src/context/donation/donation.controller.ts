import { Request, Response } from "express";
import { plainToClass } from "class-transformer";
import { inject, injectable } from "inversify";
import { config } from "../../config/config";
import { DONATION_TYPES } from "./infrastruture/ioc/donation.types";
import { DonationService } from "./application/services/donation.service";
import { CheckoutCallbackRequestDto, CheckoutRequestDto } from "./application/dto";
import RequestValidator from "../../utils/request-validator";

const { FRONTEND_URL } = config();

@injectable()
export class DonationController {
	constructor(
		@inject(DONATION_TYPES.DonationService)
		private donationService: DonationService
	) {}

	async checkout(req: Request, res: Response) {
		const payload = req["payload"];
		const checkoutDto = plainToClass(CheckoutRequestDto, req.body);
		const error = await RequestValidator.validate(checkoutDto);
		if (error) {
			res.status(error.status).json(error);
			return;
		}
		const response = await this.donationService.checkeout(payload, checkoutDto);
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
		res.redirect(`${FRONTEND_URL}/donations/success`);
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
		res.redirect(`${FRONTEND_URL}/donations/success`);
	}

	async getCustomerPortal(req: Request, res: Response) {
		const payload = req["payload"];
		const response = await this.donationService.getCustomerPortal(payload);
		res.status(response.status).json(response);
	}
}
