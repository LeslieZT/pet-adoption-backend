import express from "express";
import { uploadMulterStorage } from "./infrastructure/storage/storage.multer";
import { STORAGE_MANAGER_TYPES } from "./infrastructure/ioc/types";
import StorageManagerContainer from "./infrastructure/ioc/storage-manager.container";
import { StorageManagerController } from "./storage-manager.controller";
import { AUTHENTICATION_TYPES } from "../authentication/infrastructure/ioc/authentication.types";
import { authenticationContainer } from "../authentication/infrastructure/ioc/authentication.container";
import { AuthenticationMiddleware } from "../authentication/application/middleware/authentication.middleware";

const middleware = authenticationContainer.get<AuthenticationMiddleware>(
	AUTHENTICATION_TYPES.AuthenticationMiddleware
);

const controller = StorageManagerContainer.get<StorageManagerController>(
	STORAGE_MANAGER_TYPES.StorageManagerController
);

export const storageRouter = express.Router();

storageRouter.post(
	"/upload",
	middleware.authorize.bind(middleware),
	uploadMulterStorage.array("files", 5),
	controller.uploadFiles.bind(controller)
);
storageRouter.post(
	"/delete",
	middleware.authorize.bind(middleware),
	controller.deleteFiles.bind(controller)
);
