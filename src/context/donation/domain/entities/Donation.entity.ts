import { Decimal } from "@prisma/client/runtime/library";

export interface DonationEntity {
	donationId: string;
	planId?: number | null;
	userId?: string | null;
	amount: number | Decimal;
	type: string;
	email?: string | null;
	name?: string | null;
	createdAt: Date;
	updatedAt: Date | null;
	status: string;
}

export type DonationCreation = Omit<
	DonationEntity,
	"donationId" | "createdAt" | "updatedAt" | "email" | "name"
>;

export interface DonationList {
	donationId: string;
	createdAt: Date;
	type: string;
	status: string;
	plan: {
		name: true;
		price: number;
	};
}
