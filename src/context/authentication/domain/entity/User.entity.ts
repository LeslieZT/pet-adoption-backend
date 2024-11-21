import { JsonValue } from "@prisma/client/runtime/library";

export interface UserEntity {
	userId: string;
	channel: string;
	firstName: string;
	lastName: string;
	email: string;
	password: string;
	avatar?: JsonValue | null;
	phone?: string | null;
	birthdate?: Date | null;
	address?: string | null;
	districtId?: number | null;
	createdAt?: Date;
	updatedAt?: Date | null;
}
