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
			avatar: user.avatar as unknown as Record<string, unknown>,
			district: {
				districtId: user.district.districtId,
				provinceId: user.district.provinceId,
				departmentId: user.district.departmentId,
			},
		};
	}
}
