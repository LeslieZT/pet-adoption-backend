import { Transform } from "class-transformer";
import { IsOptional, IsString, IsISO8601, IsNumber, IsJSON, IsObject } from "class-validator";

export class UpdateUserRequestDto {
	@IsOptional()
	@IsString()
	firstName: string;

	@IsOptional()
	@IsString()
	lastName?: string;

	@IsOptional()
	@IsObject()
	avatar?: Record<string, string>;

	@IsOptional()
	@IsString()
	phone?: string;

	@IsOptional()
	@IsISO8601()
	birthdate?: Date;

	@IsOptional()
	address?: string;

	@IsOptional()
	@IsNumber()
	districtId?: number;
}
