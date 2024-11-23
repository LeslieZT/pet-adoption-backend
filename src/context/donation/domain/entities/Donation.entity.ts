import { Decimal } from "@prisma/client/runtime/library";

export interface DonationEntity {
	donationId: string;
	planId: number | null;
	userId: string;
	amount: number | Decimal;
	type: string;
	createdAt: Date;
	updatedAt: Date | null;
	status: string;
}

export type DonationCreation = Omit<DonationEntity, "donationId" | "createdAt" | "updatedAt">;
