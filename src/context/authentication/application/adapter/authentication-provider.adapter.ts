import e from "express";
import { ChannelType } from "../../domain/enum/ChannelType.enum";
import { OAuthProvider } from "../../domain/enum/OAuthProvider.enum";

export interface SignUpParams {
	email: string;
	password: string;
	metadata: Record<string, any>;
}

export interface SignInParams {
	email: string;
	password: string;
}

export interface SignInResponse {
	access_token: string;
	token_type: string;
	expires_in: number;
	refresh_token: string;
	expires_at: number;
	user: unknown;
}

export interface SignInWithOAuthParams {
	provider: OAuthProvider;
	channel: ChannelType;
}

export interface SignInWithOAuthResponse {
	provider: OAuthProvider;
	url: string;
}

export interface Identity {
	provider: string;
	user_id: string;
	identity_data: {
		avatar_url: string;
		full_name: string;
		name: string;
	};
}

export interface GetUserResponse {
	id: string;
	email: string;
	app_metadata: {
		provider: string;
	};
	user_metadata: {
		avatar_url: string;
		full_name: string;
		name: string;
	};
	identities: Identity[];
}

export interface AuthenticationProvider {
	signUp(params: SignUpParams): Promise<GetUserResponse>;
	signIn(params: SignInParams): Promise<SignInResponse>;
	signInWithOAuth(params: SignInWithOAuthParams): Promise<SignInWithOAuthResponse>;
	getUser(token: string): Promise<GetUserResponse>;
}
