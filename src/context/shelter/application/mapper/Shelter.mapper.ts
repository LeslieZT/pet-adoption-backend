import { SearchPlacesAndShelters } from "../../domain/repositories/shelter.repository";
import { SearchResponseDto } from "../dto/Search.response.dto";

export class ShelterMapper {
	static map(record: SearchPlacesAndShelters): SearchResponseDto {
		return {
			placeId: record.place_id,
			departmentName: record.department_name,
			provinceName: record.province_name,
			districtName: record.district_name,
			placeLevel: record.place_level,
			fullLocation: record.full_location,
			shelterAddress: record.shelter_address,
		};
	}

	static mapAll(records: SearchPlacesAndShelters[]): SearchResponseDto[] {
		return records.map((record) => this.map(record));
	}
}
