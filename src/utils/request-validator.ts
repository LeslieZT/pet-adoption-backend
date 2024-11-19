import { ValidationError, ValidatorOptions, validate } from "class-validator";
import { ApiResponse } from "../shared/classes/ApiResponse";
import { HTTP_BAD_REQUEST } from "../shared/constants/http-status.constant";
import { CustomErrorResponse, ErrorType } from "../shared/error";

export default class RequestValidator {
	static async validate(data: any, options: ValidatorOptions = {}): Promise<null | ApiResponse> {
		const requestErrors = await validate(data, {
			whitelist: true,
			skipMissingProperties: true,
			...options,
		});
		if (requestErrors.length > 0) {
			const errors = this.processRequestErrors(requestErrors);
			return new ApiResponse({
				status: HTTP_BAD_REQUEST,
				error: errors[0],
			});
		}
		return null;
	}

	static processRequestErrors(requestErrors: ValidationError[]): CustomErrorResponse[] {
		return requestErrors.map((error): CustomErrorResponse => {
			if (error.constraints) {
				const firstConstraint = Object.values(error.constraints)[0];
				try {
					return JSON.parse(firstConstraint);
				} catch (_) {
					return {
						object: "error",
						type: ErrorType.PARAMETER_ERROR,
						message: `Field ${error.property} with value '${error.value}' is invalid, ${firstConstraint}`,
						param: error.property,
					};
				}
			}
			return this.processRequestErrors(error.children)[0];
		});
	}
}
