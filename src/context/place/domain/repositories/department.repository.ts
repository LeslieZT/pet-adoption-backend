import { DepartmentResult } from "../entities/Department.entity";

export interface DepartmentRepository {
	findAll(): Promise<DepartmentResult[]>;
}
