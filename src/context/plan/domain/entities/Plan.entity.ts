import { Decimal } from "@prisma/client/runtime/library";

export interface PlanEntity {
	planId: number;
	productId: string;
	codeOneTime: string;
	codeSubscription: string;
	name: string;
	title: string;
	description: string;
	price: Decimal;
	isPolular: boolean;
	createdAt: Date;
	updatedAt: Date | null;
}
