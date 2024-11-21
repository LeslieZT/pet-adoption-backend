export class UserResponseDto {
	id: string;
	firstName: string;
	lastName: string;
	email: string;
	phone: string;
	address: string;
	avatar: string;
	district: {
		districtId: number;
		provinceId: number;
		departmentId: number;
	};
}
