import {  User } from "../entity/User.entity";
import { ChannelType } from "../enum/ChannelType.enum";

export interface UserRepository {
    findUserByEmail(email: string, channel: ChannelType): Promise<User>;
    create(user: User): Promise<void>;
}