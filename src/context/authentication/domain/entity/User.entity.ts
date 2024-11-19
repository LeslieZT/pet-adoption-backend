export interface User {
	userId: string;
	channel: string;
	firstName: string;
	lastName: string;
	email: string;
	password: string;
	avatar?: string | null;
	phone?: string | null;
	birthdate?: Date | null;
	address?: string | null;
	districtId?: number | null;
	createdAt?: Date;
	updatedAt?: Date | null;
}


