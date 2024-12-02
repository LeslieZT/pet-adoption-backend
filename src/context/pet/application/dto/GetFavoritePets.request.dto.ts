import { IsDefined, IsOptional, IsUUID } from "class-validator";

export class GetAllFavoritePetsRequestDto {
	@IsUUID()
	@IsDefined()
	userId: string;

	@IsOptional()
	page?: number = 1;

	@IsOptional()
	limit?: number = 20;
}
