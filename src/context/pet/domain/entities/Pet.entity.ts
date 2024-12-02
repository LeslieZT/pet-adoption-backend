import { Decimal, JsonValue } from "@prisma/client/runtime/library";

export interface PetResult {
	is_favorite: boolean;
	pet_id: number;
	category_id: number;
	pet_name: string;
	profile_picture: {
		fileName: string;
		url: string;
		publicId: string;
	};
	gender: string;
	breed_id: 5;
	birthdate: Date;
	total_months: string;
	shelter_name: string;
	shelter_id: string;
	address: string;
	district_id: number;
	province_id: number;
	department_id: number;
	status?: string;
}

export interface FindAllResult {
	total: number;
	rows: PetResult[];
}

export interface CountApplicationResult {
	pet_id: number;
	applications: number;
}

export interface Pet {
	petId: number;
	name: string;
	description: string;
	birthdate: Date;
	weight: Decimal | string;
	height: Decimal | string;
	gender: string;
	color: string;
	behavior: string[];
	profilePicture: JsonValue;
	categoryId: number;
	breedId: number;
	shelterId: string;
	status: string;
	createdAt: Date;
	updatedAt: Date;
	shelter: Shelter;
	breed: Breed;
	photos: {
		url: JsonValue | null;
	}[];
}

interface Shelter {
	name: string;
	address: string;
	phone: string;
	email: string;
	district: District;
	latitude: Decimal | string;
	longitude: Decimal | string;
}

interface District {
	name: string;
	department: Department;
	province: Province;
}

interface Department {
	name: string;
}

interface Province {
	name: string;
}

interface Breed {
	name: string;
}
