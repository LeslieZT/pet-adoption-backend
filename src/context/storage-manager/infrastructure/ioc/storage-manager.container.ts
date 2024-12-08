import "reflect-metadata";
import { Container } from "inversify";
import { STORAGE_MANAGER_TYPES } from "./types";
import { StorageManagerController } from "../../storage-manager.controller";
import { StorageManagerService } from "../../application/services/storage-manager.service";
import { StorageAdapter } from "../../application/adapter/storage.adapter";
import { StorageS3AdapterImpl } from "../adapter/storage.cloudinary.adapter.impl";

const container = new Container();
container
	.bind<StorageManagerController>(STORAGE_MANAGER_TYPES.StorageManagerController)
	.to(StorageManagerController);
container
	.bind<StorageManagerService>(STORAGE_MANAGER_TYPES.StorageManagerService)
	.to(StorageManagerService);
container.bind<StorageAdapter>(STORAGE_MANAGER_TYPES.StorageAdapter).to(StorageS3AdapterImpl);

export default container;
