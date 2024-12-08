import express from "express";
import { EmailSenderController } from "./email-sender.controller";
import { EMAIL_SENDER_TYPES } from "./infrastructure/ioc/email-sender.types";
import emailSenderContainer from "./infrastructure/ioc/email-sender.container";

const controller = emailSenderContainer.get<EmailSenderController>(
	EMAIL_SENDER_TYPES.EmailSenderController
);

export const emailSenderRouter = express.Router();

emailSenderRouter.post("/contact", controller.sendContactMail.bind(controller));
