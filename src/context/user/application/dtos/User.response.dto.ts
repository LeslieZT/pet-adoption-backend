export class UserResponseDto {
	id: string;
	firstName: string;
	lastName: string;
	email: string;
	phone: string;
	address: string;
	birthdate: Date;
	channel: string;
	avatar: Record<string, string>;
	districtId: number;
	provinceId: number;
	departmentId: number;
}
