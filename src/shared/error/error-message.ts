import { CustomErrorResponse, ErrorType } from "./error.type";

export const UPLOAD_FILE_ERROR = (message: string): CustomErrorResponse => ({
	object: "error",
	type: ErrorType.UPLOAD_FILE_ERROR,
	message,
});

export const DELETE_FILE_ERROR = (message: string): CustomErrorResponse => ({
	object: "error",
	type: ErrorType.DELETE_FILE_ERROR,
	message,
});
