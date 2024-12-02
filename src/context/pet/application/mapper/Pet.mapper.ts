import { Pet, PetResult } from "../../domain/entities/Pet.entity";
import { FindOneResponseDto } from "../dto/FindOne.response.dto";

export class PetMapper {
	static mapApplications(applications: any): any {
		const output = {};
		applications.forEach((application: any) => {
			output[application.pet_id] = application.applications;
		});
		return output;
	}

	static mapPets(pets: PetResult[], applications: Record<string, string>): any {
		const output = [];
		pets.forEach((pet: PetResult) => {
			const record = {
				petId: pet.pet_id,
				categoryId: pet.category_id,
				name: pet.pet_name,
				profilePicture: pet.profile_picture?.url,
				gender: pet.gender,
				breedId: pet.breed_id,
				birthdate: pet.birthdate,
				totalMonths: pet.total_months,
				shelterName: pet.shelter_name,
				shelterId: pet.shelter_id,
				address: pet.address,
				districtId: pet.district_id,
				provinceId: pet.province_id,
				departmentId: pet.department_id,
				isFavorite: pet.is_favorite != null ? pet.is_favorite : false,
			};
			if (pet.status) {
				record["status"] = pet.status;
			}
			const petApplications = applications[pet.pet_id];
			record["applications"] = petApplications ? petApplications : 0;
			output.push(record);
		});
		return output;
	}

	static mapCategories(categories: any): any {
		const output = [];
		categories.forEach((category: any) => {
			output.push({
				value: category.petCategoryId,
				label: category.name,
			});
		});
		return output;
	}

	static mapBreeds(breeds: any): any {
		const output = {};
		breeds.forEach((breed: any) => {
			output[breed.petBreedId] = breed;
		});
		return output;
	}

	static mapPet(
		pet: Pet,
		isFavorite: boolean,
		applications: number,
		months: number
	): FindOneResponseDto {
		const output = {
			petId: pet.petId,
			name: pet.name,
			description: pet.description,
			birthdate: pet.birthdate,
			age: months,
			weight: pet.weight as string,
			height: pet.height as string,
			gender: pet.gender,
			color: pet.color,
			behavior: pet.behavior,
			profilePicture: pet.profilePicture?.["url"],
			breed: pet.breed.name,
			shelter: {
				name: pet.shelter.name,
				address: pet.shelter.address,
				phone: pet.shelter.phone,
				email: pet.shelter.email,
				district: pet.shelter.district.name,
				province: pet.shelter.district.province.name,
				department: pet.shelter.district.department.name,
				latitude: pet.shelter.latitude as string,
				longitude: pet.shelter.longitude as string,
			},
			photos: pet.photos.map((photo: any) => photo.url),
			isFavorite,
			applications,
		};
		return output;
	}
}
