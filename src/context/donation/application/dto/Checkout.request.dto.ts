import { IsDefined, IsEnum, IsOptional, IsString } from "class-validator";
import { PaymentMode } from "../../domain/enum/PaymentMode.enum";

export class CheckoutRequestDto {
	@IsEnum(PaymentMode)
	@IsDefined()
	mode: PaymentMode;

	@IsString()
	@IsDefined()
	code: string;

	@IsOptional()
	@IsString()
	idUser: string;

	@IsOptional()
	@IsString()
	channel: string;
}
