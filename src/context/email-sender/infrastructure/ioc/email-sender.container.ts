import { BrevoEmailSenderAdapterImpl } from "./../adapter/email-sender.nodemailer.adapter.impl";
import "reflect-metadata";
import { Container } from "inversify";
import { EmailSenderController } from "../../email-sender.controller";
import { EmailSenderService } from "../../application/services/email-sender.service";
import { EMAIL_SENDER_TYPES } from "./email-sender.types";
import { EmailSenderAdapter } from "../../application/adapter/email-sender.adapter";

const emailSenderContainer = new Container();
emailSenderContainer
	.bind<EmailSenderController>(EMAIL_SENDER_TYPES.EmailSenderController)
	.to(EmailSenderController);
emailSenderContainer
	.bind<EmailSenderService>(EMAIL_SENDER_TYPES.EmailSenderService)
	.to(EmailSenderService);
emailSenderContainer
	.bind<EmailSenderAdapter>(EMAIL_SENDER_TYPES.EmailSenderAdapter)
	.to(BrevoEmailSenderAdapterImpl);

export default emailSenderContainer;
