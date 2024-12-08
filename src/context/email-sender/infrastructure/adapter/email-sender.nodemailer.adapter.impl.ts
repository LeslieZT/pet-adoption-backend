import { injectable } from "inversify";
import nodemailer from "nodemailer";
import { config } from "../../../../config/config";
import {
	EmailSenderAdapter,
	SendEmailParams,
} from "../../application/adapter/email-sender.adapter";
import { CustomError, ErrorType } from "../../../../shared/error";

const { BREVO_SMTP_HOST, BREVO_SMTP_PORT, BREVO_SMTP_USER, BREVO_SMTP_PASS, BREVO_EMAIL_FROM } =
	config();

@injectable()
export class BrevoEmailSenderAdapterImpl implements EmailSenderAdapter {
	private transporter: any;
	constructor() {
		this.transporter = nodemailer.createTransport({
			host: BREVO_SMTP_HOST,
			port: Number(BREVO_SMTP_PORT),
			secure: false,
			auth: {
				user: BREVO_SMTP_USER,
				pass: BREVO_SMTP_PASS,
			},
		});
	}

	async send(params: SendEmailParams): Promise<void> {
		try {
			await this.transporter.sendMail({
				from: params.from,
				to: params.to,
				subject: params.subject,
				html: params.html,
			});
		} catch (error: unknown) {
			throw new CustomError({
				status: 500,
				errorType: ErrorType.SEND_EMAIL_ERROR,
				message: `Could not send email ${String(error)}`,
			});
		}
	}
}
