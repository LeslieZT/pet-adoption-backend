import { IsDefined, IsString } from "class-validator";

export class ContactRequestDto {
	@IsString()
	@IsDefined()
	email: string;

	@IsString()
	@IsDefined()
	message: string;
}
