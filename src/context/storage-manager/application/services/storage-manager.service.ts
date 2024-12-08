import { inject, injectable } from "inversify";
import { FileDto, DeleteFileRequestDto } from "../dto";
import { STORAGE_MANAGER_TYPES } from "../../infrastructure/ioc/types";
import { StorageAdapter } from "../adapter/storage.adapter";
import { PayloadRequest } from "../../../../shared/classes/Payload";
import { ApiResponse } from "../../../../shared/classes/ApiResponse";
import { HTTP_OK } from "../../../../shared/constants/http-status.constant";
import { logger } from "../../../../utils/logger";
import { DELETE_FILE_ERROR, UPLOAD_FILE_ERROR } from "../../../../shared/error/error-message";

@injectable()
export class StorageManagerService {
	constructor(
		@inject(STORAGE_MANAGER_TYPES.StorageAdapter)
		private storageAdapter: StorageAdapter
	) {}

	async uploadFiles(files: FileDto[], folder: string) {
		const errors = [];
		const data = [];

		for (const file of files) {
			try {
				const response = await this.storageAdapter.uploadFile(file.buffer, folder);
				data.push({
					fileName: file.originalname,
					url: response.secure_url,
					publicId: response.public_id,
				});
			} catch (error) {
				logger.error(error, `The file ${error.originalname} could not be uploaded`);
				errors.push(UPLOAD_FILE_ERROR(`The file ${error.originalname} could not be uploaded`));
			}
		}
		return new ApiResponse({ status: HTTP_OK, data, error: errors });
	}

	async deleteFiles(params: DeleteFileRequestDto, payload: PayloadRequest) {
		const errors = [];
		const data = [];
		for (const key of params.keys) {
			try {
				await this.storageAdapter.deleteFile(key);
				data.push({ key, message: `The file ${key} was deleted successfully` });
			} catch (error) {
				logger.error(error, `The file ${key} could not be deleted`);
				errors.push(DELETE_FILE_ERROR(`The file ${key} could not be deleted`));
			}
		}
		return new ApiResponse({ status: HTTP_OK, data, error: errors });
	}
}
