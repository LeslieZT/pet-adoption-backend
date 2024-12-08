import { inject, injectable } from "inversify";
import { Request, Response } from "express";
import { plainToClass } from "class-transformer";
import { EMAIL_SENDER_TYPES } from "./infrastructure/ioc/email-sender.types";
import { EmailSenderService } from "./application/services/email-sender.service";
import RequestValidator from "../../utils/request-validator";
import { ContactRequestDto } from "./application/dto";

@injectable()
export class EmailSenderController {
	constructor(
		@inject(EMAIL_SENDER_TYPES.EmailSenderService)
		private emailSenderService: EmailSenderService
	) {}

	async sendContactMail(req: Request, res: Response) {
		const contactDto = plainToClass(ContactRequestDto, req.body);
		const error = await RequestValidator.validate(contactDto);
		if (error) {
			res.status(error.status).json(error);
			return;
		}
		const response = await this.emailSenderService.sendContactMail(contactDto);
		res.status(response.status).json(response);
	}
}
