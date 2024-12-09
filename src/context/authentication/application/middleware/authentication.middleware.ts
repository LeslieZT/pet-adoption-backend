import { Request, Response, NextFunction } from "express";
import { inject, injectable } from "inversify";
import { AUTHENTICATION_TYPES } from "../../infrastructure/ioc/authentication.types";
import { AuthenticationProvider } from "../adapter/authentication-provider.adapter";
import { UnauthorizationError } from "../../../../shared/error";
import { ChannelType } from "../../domain/enum/ChannelType.enum";
import { PayloadRequest } from "../../../../shared/classes/Payload";
import { logger } from "../../../../utils/logger";

@injectable()
export class AuthenticationMiddleware {
	constructor(
		@inject(AUTHENTICATION_TYPES.AuthenticationProvider)
		private authenticationProvider: AuthenticationProvider
	) {}

	async verifyChannel(req: Request, res: Response, next: NextFunction) {
		const channelHeader = req.get("X-Channel") as ChannelType;
		if (!channelHeader) {
			logger.error("Channel not send");
			const error = new UnauthorizationError("Not Authorized");
			return next(error);
		}

		if (![ChannelType.ADOPTION, ChannelType.SHELTER].includes(channelHeader)) {
			logger.error("Channel not valid");
			const error = new UnauthorizationError("Not Authorized");
			return next(error);
		}
		next();
	}

	async authorize(req: Request, res: Response, next: NextFunction) {
		try {
			const authHeader = req.get("Authorization");
			if (!authHeader) {
				const error = new UnauthorizationError("Not Authorized");
				return next(error);
			}
			const token = authHeader.replace("Basic ", "").replace("Bearer ", "");
			if (!token || token.length < 1) {
				const error = new UnauthorizationError("Not Authorized");
				return next(error);
			}
			const channelHeader = req.get("X-Channel") as ChannelType;
			if (!channelHeader) {
				logger.error("Channel not send");
				const error = new UnauthorizationError("Not Authorized");
				return next(error);
			}

			if (![ChannelType.ADOPTION, ChannelType.SHELTER].includes(channelHeader)) {
				logger.error("Channel not valid");
				const error = new UnauthorizationError("Not Authorized");
				return next(error);
			}

			const user = await this.authenticationProvider.getUser(token);
			req["payload"] = new PayloadRequest({
				idUser: user.id,
				email: user.email,
				token,
				channel: channelHeader,
			});
			next();
		} catch (error) {
			logger.error(error, "Error Authorize");
			const customError = new UnauthorizationError(error.message);
			return next(customError);
		}
	}
}
