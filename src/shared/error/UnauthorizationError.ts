import { HTTP_UNAUTHORIZED } from "../constants/http-status.constant";
import { CustomError } from "./CustomError";
import { ErrorType } from "./error.type";

export class UnauthorizationError extends CustomError {
	constructor(message: string) {
		super({
			errorType: ErrorType.UNAUTHORIZED_ERROR,
			status: HTTP_UNAUTHORIZED,
			message,
		});
	}
}
