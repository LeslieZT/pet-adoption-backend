import { UserEntity } from "../entities/User.entity";
import { DistrictEntity } from "../entities/District.entity";

export interface UserRepository {
	findOne(userId: string, channel: string): Promise<UserEntity & { district: DistrictEntity }>;
	update(userId: string, channel: string, data: Partial<UserEntity>): Promise<void>;
}
