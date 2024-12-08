export interface SendEmailParams {
	from: string;
	to: string;
	subject: string;
	html: string;
}

export interface EmailSenderAdapter {
	send(params: SendEmailParams): Promise<void>;
}
