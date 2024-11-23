import { IsDefined, IsString } from "class-validator";

export class CheckoutCallbackRequestDto {
	@IsString()
	@IsDefined()
	sessionId: string;
}
