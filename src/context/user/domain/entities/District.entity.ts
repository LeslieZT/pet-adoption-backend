export interface DistrictEntity {
	name: string;
	districtId: number;
	createdAt: Date;
	updatedAt: Date | null;
	code: string;
	provinceId: number;
	departmentId: number;
}
