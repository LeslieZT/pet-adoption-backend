import { IsDefined, IsEnum } from "class-validator";
import { OAuthProvider } from "../../domain/enum/OAuthProvider.enum";

export class SignInWithOAuthCallbackRequest {
	@IsEnum(OAuthProvider)
	@IsDefined()
	provider: OAuthProvider;

	@IsDefined()
	accessToken: string; 
}
