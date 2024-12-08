export interface DepartmentResult {
	departmentId: number;
	name: string;
	provinces: {
		provinceId: number;
		name: string;
		districts: {
			districtId: number;
			name: string;
		}[];
	}[];
}
