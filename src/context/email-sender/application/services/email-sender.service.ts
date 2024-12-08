import { inject, injectable } from "inversify";
import { ContactRequestDto } from "../dto";
import { EMAIL_SENDER_TYPES } from "../../infrastructure/ioc/email-sender.types";
import { ApiResponse } from "../../../../shared/classes/ApiResponse";
import { HTTP_OK } from "../../../../shared/constants/http-status.constant";
import { EmailSenderAdapter } from "../adapter/email-sender.adapter";
import { config } from "../../../../config/config";

const { BREVO_EMAIL_FROM } = config();
@injectable()
export class EmailSenderService {
	constructor(
		@inject(EMAIL_SENDER_TYPES.EmailSenderAdapter)
		private emailSenderAdapter: EmailSenderAdapter
	) {}

	async sendContactMail(contactDto: ContactRequestDto) {
		await this.emailSenderAdapter.send({
			to: BREVO_EMAIL_FROM,
			from: `"HappyPaws - Contact" <${BREVO_EMAIL_FROM}>`,
			subject: "Contact form",
			html: `		
			<p>Email: ${contactDto.email}</p>	
			<p>Message: ${contactDto.message}</p>
			`,
		});
		const data = { message: "Contact sent successfully" };
		return new ApiResponse({ status: HTTP_OK, data });
	}
}
