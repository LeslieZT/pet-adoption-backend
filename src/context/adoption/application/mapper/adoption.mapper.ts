import { AdoptionApplication } from "../../domain/entities/adoption.entity";

export class AdoptionMapper {
	static map(data: AdoptionApplication): any {
		return {
			id: data.adoptionId,
			status: data.status,
			petId: data.petId,
			createdAt: data.createdAt,
			petName: data.pet.name,
			petCategory: data.pet.category.name,
		};
	}

	static mapAll(data: AdoptionApplication[]): any {
		return data.map((adoption: AdoptionApplication) => this.map(adoption));
	}
}
