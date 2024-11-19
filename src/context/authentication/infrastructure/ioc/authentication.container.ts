import "reflect-metadata";
import { Container } from "inversify";
import { AUTHENTICATION_TYPES } from "./authentication.types";
import AuthenticationController from "../../authentication.controller";
import AuthenticationService from "../../application/services/authentication.service";
import { UserRepository } from "../../domain/repository/user.repository";
import { UserRepositoryImpl } from "../repositories/user.repository.impl";
import { AuthenticationProvider } from "../../application/adapter/authentication-provider.adapter";
import { SupabaseAuthenticationProviderImpl } from "../adapter/supabase.authentication-provider.adapter.impl";
import { BcryptManager } from "../../application/adapter/bcrypt-manager.adapter";
import { BcryptManagerImpl } from "../adapter/bcrypt-manager.adapter.impl";
import { AuthenticationMiddleware } from "../../application/middleware/authentication.middleware";

export const authenticationContainer = new Container();

authenticationContainer.bind<AuthenticationController>(AUTHENTICATION_TYPES.AuthenticationController).to(AuthenticationController);
authenticationContainer.bind<AuthenticationService>(AUTHENTICATION_TYPES.AuthenticationService).to(AuthenticationService);
authenticationContainer.bind<UserRepository>(AUTHENTICATION_TYPES.UserRepository).to(UserRepositoryImpl);
authenticationContainer.bind<AuthenticationProvider>(AUTHENTICATION_TYPES.AuthenticationProvider).to(SupabaseAuthenticationProviderImpl);
authenticationContainer.bind<BcryptManager>(AUTHENTICATION_TYPES.BcryptManager).to(BcryptManagerImpl);
authenticationContainer.bind<AuthenticationMiddleware>(AUTHENTICATION_TYPES.AuthenticationMiddleware).to(AuthenticationMiddleware);

