import { injectable } from "inversify";
import { prisma } from "../../../../database/database";
import { DepartmentRepository } from "../../domain/repositories/department.repository";
import { DepartmentResult } from "../../domain/entities/Department.entity";

@injectable()
export class DepartmentRepositoryImpl implements DepartmentRepository {
	async findAll(): Promise<DepartmentResult[]> {
		const queryset = await prisma.department.findMany({
			select: {
				departmentId: true,
				name: true,
				provinces: {
					select: {
						provinceId: true,
						name: true,
						districts: {
							select: {
								districtId: true,
								name: true,
							},
						},
					},
				},
			},
		});
		return queryset;
	}
}
