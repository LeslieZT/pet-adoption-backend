import { UserEntity } from "../entity/User.entity";
import { ChannelType } from "../enum/ChannelType.enum";

export interface UserRepository {
	findUserByEmail(email: string, channel: ChannelType): Promise<UserEntity>;
	create(user: UserEntity): Promise<void>;
}
