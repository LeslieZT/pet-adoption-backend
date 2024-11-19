export interface ApiResponseAttributes {
	status: number;
	data?: unknown;
	error?: unknown;
}

export class ApiResponse {
	status: number;
	data?: unknown;
	error?: unknown;

	constructor({ status, data, error }: ApiResponseAttributes) {
		this.status = status;
		this.data = data;
		this.error = error;
	}
}
