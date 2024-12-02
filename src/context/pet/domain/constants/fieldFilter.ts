import { PlaceLevel } from "../enum/PlaceLevel.enum";

export const FIELD_FILTER = {
	[PlaceLevel.DISTRICT]: "district_id",
	[PlaceLevel.PROVINCE]: "province_id",
	[PlaceLevel.DEPARTMENT]: "department_id",
	[PlaceLevel.SHELTER]: "shelter_id",
};
