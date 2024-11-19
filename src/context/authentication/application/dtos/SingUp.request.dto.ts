import { IsEmail, IsNotEmpty, IsDefined, IsString, MinLength } from "class-validator";

export class SignUpRequestDto {
	@IsString()
	@IsNotEmpty()
	@IsDefined()
	firstName: string;

	@IsString()
	@IsNotEmpty()
	@IsDefined()
	lastName: string;

	@IsEmail()
	@IsNotEmpty()
	@IsDefined()
	email: string;

	
	@MinLength(8)
	@IsDefined()
	@IsString()
	password: string;

}
