export class UserResponseDto {
	id: string;
	firstName: string;
	lastName: string;
	email: string;
	phone: string;
	address: string;
	avatar: Record<string, unknown>;
	district: {
		districtId: number;
		provinceId: number;
		departmentId: number;
	};
}
