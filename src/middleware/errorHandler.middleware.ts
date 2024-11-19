import { NextFunction, Request, Response } from "express";
import { CustomError } from "../shared/error/CustomError";
import { HTTP_INTERNAL_SERVER_ERROR } from "../shared/constants/http-status.constant";
import { ErrorType } from "../shared/error/error.type";
import { logger } from "../utils/logger";

export const errorHandler = (err: Error, _req: Request, res: Response, _next: NextFunction) => {
	logger.error(err, 'Error handler');
	if (err instanceof CustomError) {
		res
			.status(err.status || HTTP_INTERNAL_SERVER_ERROR)
			.json({ status: err.status || HTTP_INTERNAL_SERVER_ERROR, error: err.format() });
		return;
	}
	if (
		err.name === "PrismaClientInitializationError" ||
		err.name === "PrismaClientKnownRequestError"
	) {
		res.status(HTTP_INTERNAL_SERVER_ERROR).json({
			error: {
				object: "error",
				type: ErrorType.DATABASE_ERROR,
				message: "Something went wrong",
			},
		});
		return;
	}
	res.status(HTTP_INTERNAL_SERVER_ERROR).json({
		error: {
			object: "error",
			type: ErrorType.INTERNAL_SERVER_ERROR,
			message: err.message,
		},
	});
};
