import { UserResponseDto } from "../dtos";
import { UserEntity } from "../../domain/entities/User.entity";
import { DistrictEntity } from "../../domain/entities/District.entity";

export class UserMapper {
	static map(user: UserEntity & { district: DistrictEntity }): UserResponseDto {
		return {
			id: user.userId,
			firstName: user.firstName,
			lastName: user.lastName,
			email: user.email,
			phone: user.phone,
			address: user.address,
			avatar: user.avatar as Record<string, string>,
			channel: user.channel,
			birthdate: user.birthdate,
			districtId: user.district?.districtId ?? null,
			provinceId: user.district?.provinceId ?? null,
			departmentId: user.district?.departmentId ?? null,
		};
	}
}
