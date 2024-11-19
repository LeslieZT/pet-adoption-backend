import bcrypt from "bcrypt";
import { config } from "../../../../config/config";

const { SALT_ROUNDS } = config();

export class BcryptManagerImpl {
	async hash(password: string): Promise<string> {
		return bcrypt.hash(password, +SALT_ROUNDS);
	}

	async compare(password: string, hash: string): Promise<boolean> {
		return bcrypt.compare(password, hash);
	}
}
