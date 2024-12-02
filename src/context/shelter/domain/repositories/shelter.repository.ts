export interface SearchPlacesAndShelters {
	place_id: string;
	department_name: string;
	province_name: string;
	district_name: string;
	place_level: string;
	full_location: string;
	shelter_address: string;
}

export interface ShelterRepository {
	searchPlacesAndShelters(search: string): Promise<SearchPlacesAndShelters[]>;
}
