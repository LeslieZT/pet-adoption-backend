import { IsDefined, IsNumber, IsOptional, IsUUID } from "class-validator";

export class FindOneRequestDto {
	@IsNumber()
	@IsDefined()
	petId: number;

	@IsOptional()
	@IsUUID()
	userId?: string;
}
