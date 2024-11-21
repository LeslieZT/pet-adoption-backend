import { v2 as cloudinary } from "cloudinary";
import { injectable } from "inversify";
import { config } from "../../../../config/config";
import { StorageAdapter, UploadResponse } from "../../application/adapter/storage.adapter";
import { CustomError, ErrorType } from "../../../../shared/error";
import { logger } from "../../../../utils/logger";

const { CLOUDINARY_API_KEY, CLOUDINARY_API_SECRET, CLOUDINARY_CLOUD_NAME } = config();

cloudinary.config({
	cloud_name: CLOUDINARY_CLOUD_NAME,
	api_key: CLOUDINARY_API_KEY,
	api_secret: CLOUDINARY_API_SECRET,
});

@injectable()
export class StorageS3AdapterImpl implements StorageAdapter {
	constructor() {}

	async uploadFile(file: Buffer, folder: string): Promise<UploadResponse> {
		try {
			return new Promise((resolve, reject) => {
				const uploadStream = cloudinary.uploader.upload_stream(
					{ folder, resource_type: "auto" },
					(error, result) => {
						if (error) {
							return reject(error);
						}
						resolve(result);
					}
				);
				uploadStream.end(file);
			});
		} catch (error) {
			console.log(error);
			throw new CustomError({
				errorType: ErrorType.UPLOAD_FILE_ERROR,
				message: error.message,
			});
		}
	}

	async deleteFile(key: string) {
		try {
			return new Promise((resolve, reject) => {
				cloudinary.uploader.destroy(key, function (error, result) {
					if (error) {
						return reject(error);
					}
					logger.info(`The file ${key} was deleted successfully`);
					resolve(result);
				});
			});
		} catch (error) {
			throw new CustomError({
				errorType: ErrorType.DELETE_FILE_ERROR,
				message: error.message,
			});
		}
	}
}
