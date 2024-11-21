import { inject, injectable } from "inversify";
import { Request, Response } from "express";
import { plainToClass } from "class-transformer";
import { STORAGE_MANAGER_TYPES } from "./infrastructure/ioc/types";
import { StorageManagerService } from "./application/services/storage-manager.service";
import { DeleteFileRequestDto, FileDto } from "./application/dto";
import { PayloadRequest } from "../../shared/classes/Payload";
import RequestValidator from "../../utils/request-validator";

@injectable()
export class StorageManagerController {
	constructor(
		@inject(STORAGE_MANAGER_TYPES.StorageManagerService)
		private storageManagerService: StorageManagerService
	) {}

	async uploadFiles(req: Request & { files: FileDto[] }, res: Response) {
		const files = req?.files;
		const payload = req["payload"] as PayloadRequest;
		const response = await this.storageManagerService.uploadFiles(files, payload);
		res.status(response.status).json(response);
	}

	async deleteFiles(req: Request, res: Response) {
		const payload = req["payload"] as PayloadRequest;
		const deleteFileDto = plainToClass(DeleteFileRequestDto, req.body);
		const error = await RequestValidator.validate(deleteFileDto);
		if (error) {
			return res.status(error.status).json(error);
		}
		const response = await this.storageManagerService.deleteFiles(deleteFileDto, payload);
		res.status(response.status).json(response);
	}
}
