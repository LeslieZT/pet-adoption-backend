export enum ErrorType {
	UNAUTHORIZED_ERROR = "UNAUTHORIZED_ERROR",
	FORBIDDEN_ERROR = "FORBIDDEN_ERROR",
	NOT_FOUND_ERROR = "NOT_FOUND_ERROR",
	BAD_REQUEST_ERROR = "BAD_REQUEST_ERROR",
	INTERNAL_SERVER_ERROR = "INTERNAL_SERVER_ERROR",
	DATABASE_ERROR = "DATABASE_ERROR",
	AUTHENTICATION_ERROR = "AUTHENTICATION_ERROR",
	EMAIL_SEND_ERROR = "EMAIL_SEND_ERROR",
	PARAMETER_ERROR = "PARAMETER_ERROR",
	VALIDATION_ERROR = "VALIDATION_ERROR",
	UPLOAD_FILE_ERROR = "UPLOAD_FILE_ERROR",
	DELETE_FILE_ERROR = "DELETE_FILE_ERROR",
	SEND_EMAIL_ERROR = "SEND_EMAIL_ERROR",
}

export interface CustomErrorResponse {
	object: string;
	type: ErrorType;
	message: string;
	param?: string;
}
