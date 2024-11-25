import { Equals, IsDefined, IsNumber, IsOptional, IsString } from "class-validator";
import { PaymentMode } from "../../domain/enum/PaymentMode.enum";

export class CustomCheckoutRequestDto {
	@Equals(PaymentMode.ONE_TIME)
	@IsDefined()
	mode: PaymentMode;

	@IsNumber()
	@IsDefined()
	amount: number;

	@IsOptional()
	@IsString()
	idUser: string;

	@IsOptional()
	@IsString()
	channel: string;
}
