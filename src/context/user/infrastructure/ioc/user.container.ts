import { Container } from "inversify";
import { USER_TYPES } from "./user.types";
import { UserController } from "../../user.controller";
import { UserService } from "../../application/services/user.service";
import { UserRepositoryImpl } from "../repositories/user.repository.impl";
import { UserRepository } from "../../domain/repositories/user.repository";

export const userContainer = new Container();
userContainer.bind<UserRepository>(USER_TYPES.UserRepository).to(UserRepositoryImpl);
userContainer.bind<UserService>(USER_TYPES.UserService).to(UserService);
userContainer.bind<UserController>(USER_TYPES.UserController).to(UserController);
