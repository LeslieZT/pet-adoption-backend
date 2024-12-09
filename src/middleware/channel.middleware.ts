import { HTTP_UNAUTHORIZED } from "../shared/constants/http-status.constant";
import { ErrorType } from "../shared/error/error.type";

export const channelValidationMiddleware = (req: any, res: any, next: any) => {
	if (!req.headers["x-channel"] || req.headers["x-channel"] === "") {
		res.status(HTTP_UNAUTHORIZED).json({
			error: { object: "error", type: ErrorType.UNAUTHORIZED_ERROR, message: "Unauthorized Channel" },
		});
		return;
	}
	next();
};
