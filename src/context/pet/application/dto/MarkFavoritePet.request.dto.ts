import { IsBoolean, IsDefined, IsNumber, IsOptional, IsUUID } from "class-validator";

export class MarkFavoritePetRequestDto {
	@IsNumber()
	@IsDefined()
	petId: number;

	@IsDefined()
	@IsUUID()
	userId: string;

	@IsBoolean()
	@IsDefined()
	value: boolean;
}
