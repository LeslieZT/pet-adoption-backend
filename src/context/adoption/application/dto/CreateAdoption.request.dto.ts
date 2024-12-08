import { Type } from "class-transformer";
import { IsBoolean, IsDefined, IsInt, IsString, IsUUID, ValidateNested } from "class-validator";

class ApplicationDto {
	@IsString()
	@IsDefined()
	housingType: string;

	@IsBoolean()
	@IsDefined()
	isPlaceOwned: boolean;

	@IsBoolean()
	@IsDefined()
	hasPermission: boolean;

	@IsBoolean()
	@IsDefined()
	hasOutdoorSpace: boolean;

	@IsBoolean()
	@IsDefined()
	hasPastExperience: boolean;

	@IsBoolean()
	@IsDefined()
	canCoverCosts: boolean;

	@IsBoolean()
	@IsDefined()
	canTakePetWalk: boolean;

	@IsBoolean()
	@IsDefined()
	canTakeTimeOff: boolean;

	@IsBoolean()
	@IsDefined()
	agreesToVisit: boolean;

	@IsBoolean()
	@IsDefined()
	agreesToFollowUp: boolean;

	@IsString()
	@IsDefined()
	adoptionReason: string;

	@IsString()
	@IsDefined()
	situationChange: string;
}
export class CreateAdoptionRequestDto {
	@IsInt()
	@IsDefined()
	petId: number;

	@IsUUID()
	@IsDefined()
	userId: string;

	@Type(() => ApplicationDto)
	@ValidateNested()
	@IsDefined()
	application: ApplicationDto;
}
