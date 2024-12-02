import {
	IsDefined,
	IsEnum,
	IsNumber,
	IsOptional,
	IsString,
	IsUUID,
	ValidateNested,
} from "class-validator";
import { PlaceLevel } from "../../domain/enum/PlaceLevel.enum";
import { GenderPet } from "../../domain/enum/Gender.enum";
import { Type } from "class-transformer";

class OptionsFieldDto {
	@IsString()
	@IsDefined()
	placeId: string;

	@IsEnum(PlaceLevel)
	@IsDefined()
	placeLevel: PlaceLevel;
}

class AgeFieldDto {
	@IsNumber()
	@IsDefined()
	minAge: number;

	@IsNumber()
	@IsOptional()
	maxAge?: number;
}

export class GetAllPetsRequestDto {
	@IsUUID()
	@IsOptional()
	idUser?: string;

	@IsOptional()
	location?: string;

	@IsNumber()
	@IsOptional()
	petType?: number;

	@IsEnum(GenderPet)
	@IsOptional()
	gender?: GenderPet;

	@ValidateNested()
	@Type(() => OptionsFieldDto)
	@IsOptional()
	option?: OptionsFieldDto;

	@ValidateNested()
	@Type(() => AgeFieldDto)
	@IsOptional()
	age?: AgeFieldDto;

	@IsOptional()
	page?: number = 1;

	@IsOptional()
	limit?: number = 20;
}
