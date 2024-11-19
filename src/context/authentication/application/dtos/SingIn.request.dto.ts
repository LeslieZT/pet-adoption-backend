import { IsEmail, IsNotEmpty, IsDefined, IsString } from "class-validator";

export class SignInRequestDto {
	@IsEmail()
	@IsNotEmpty()
	@IsDefined()
	email: string;

	@IsNotEmpty()
	@IsDefined()
	@IsString()
	password: string;
}
