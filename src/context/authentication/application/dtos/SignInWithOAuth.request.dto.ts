import { IsDefined, IsEnum } from "class-validator";
import { OAuthProvider } from "../../domain/enum/OAuthProvider.enum";

export class SignInWithOAuthRequest {
	@IsEnum(OAuthProvider)
	@IsDefined()
	provider: OAuthProvider;
}
