import { UserEntity } from "../entities/User.entity";

export interface UserRepository {
	findOne(id: string, channel: string): Promise<UserEntity | null>;
	update(id: string, channel: string, data: Partial<UserEntity>): Promise<void>;
}
