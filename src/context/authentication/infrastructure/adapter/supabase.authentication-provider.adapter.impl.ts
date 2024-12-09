import { createClient } from "@supabase/supabase-js";
import { config } from "../../../../config/config";
import {
	AuthenticationProvider,
	GetUserResponse,
	SignInParams,
	SignInResponse,
	SignInWithOAuthParams,
	SignUpParams,
} from "../../application/adapter/authentication-provider.adapter";
import { CustomError } from "../../../../shared/error/CustomError";
import { ErrorType } from "../../../../shared/error/error.type";
import { logger } from "../../../../utils/logger";

const { URL_SUPABASE, ANON_KEY_SUPABASE, FRONTEND_URL } = config();

export class SupabaseAuthenticationProviderImpl implements AuthenticationProvider {
	private client: any;
	constructor() {
		this.client = createClient(URL_SUPABASE, ANON_KEY_SUPABASE);
	}

	async signUp(params: SignUpParams): Promise<GetUserResponse> {
		console.log({emailRedirectTo: `${FRONTEND_URL}/auth/verify-email`})
		const { data, error } = await this.client.auth.signUp({
			email: params.email,
			password: params.password,
			options: {
				data: params.metadata,
				emailRedirectTo: `${FRONTEND_URL}/auth/verify-email`,
			},
		});
		if (error) {
			logger.error(error, "Sign Up Error Supabase Provider");
			throw new CustomError({ errorType: ErrorType.AUTHENTICATION_ERROR, message: error.message });
		}
		logger.info(data, "Sign Up Successfully");
		return data.user;
	}

	async signIn(params: SignInParams): Promise<any> {
		const { data, error } = await this.client.auth.signInWithPassword({
			email: params.email,
			password: params.password,
		});
		if (error) {
			logger.error(error, "Sign In Error Supabase Provider");
			throw new CustomError({
				status: error.status,
				errorType: ErrorType.AUTHENTICATION_ERROR,
				message: error.message,
			});
		}
		logger.info(data, "Sign In Successfully");
		return data.session;
	}

	async signInWithOAuth(params: SignInWithOAuthParams): Promise<any> {
		const { data, error } = await this.client.auth.signInWithOAuth({
			provider: params.provider,
			options: {
				redirectTo: `${FRONTEND_URL}/auth/providers/${params.provider}/callback?channel=${params.channel}`,
				data: { channel: params.channel },
			},
		});
		if (error) {
			logger.error(error, `Sign In ${params.provider} Error Supabase Provider`);
			throw new CustomError({
				status: error.status,
				errorType: ErrorType.AUTHENTICATION_ERROR,
				message: error.message,
			});
		}
		logger.info(data, `Sign In ${params.provider} Successfully`);
		return data;
	}

	async getUser(token: string): Promise<GetUserResponse> {
		const { data, error } = await this.client.auth.getUser(token);
		if (error) {
			logger.error(error, "Get User Error Supabase Provider");
			throw new CustomError({ errorType: ErrorType.AUTHENTICATION_ERROR, message: error.message });
		}
		logger.info(data, "Get User Successfully");
		return data.user;
	}
}
