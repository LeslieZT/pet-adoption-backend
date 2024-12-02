import { IsDefined, IsString, MinLength } from "class-validator";

export class SearchRequestDto {
	@MinLength(3)
	@IsString()
	@IsDefined()
	search: string;
}
