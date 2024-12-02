import { CountApplicationResult, FindAllResult, Pet } from "../entities/Pet.entity";

export interface FindAllParams {
	idUser?: string;
	location?: string;
	petType?: number;
	gender?: string;
	age?: {
		minAge: number;
		maxAge?: number;
	};
	option?: {
		id: string;
		field: string;
	};
	limit: number;
	offset: number;
}

export interface FindAllFavoriteParams {
	userId: string;
	offset: number;
	limit: number;
}

export interface PetRepository {
	findAll(params: FindAllParams): Promise<FindAllResult>;
	countApplications(params: number[]): Promise<CountApplicationResult[]>;
	findOne(id: number): Promise<Pet>;
	getPetApplications(petId: number): Promise<number>;
	getPetMonths(petId: number): Promise<number>;
	findAllFavorite(params: FindAllFavoriteParams): Promise<FindAllResult>;
}
