import { IsDefined, IsEnum, IsNumber, IsOptional, IsString } from "class-validator";
import { PaymentMode } from "../../domain/enum/PaymentMode.enum";

export class CheckoutRequestDto {
	@IsString()
	@IsDefined()
	code: string;

	@IsEnum(PaymentMode)
	@IsDefined()
	mode: PaymentMode;

	@IsNumber()
	@IsOptional()
	amount: number;
}
