import {
	AdoptionApplication,
	AdoptionEntity,
	UserPetApplication,
} from "../entities/adoption.entity";

export interface AdoptionRepository {
	create(data: AdoptionEntity): Promise<any>;
	findById(id: string): Promise<AdoptionEntity>;
	findAllByUserId(userId: string): Promise<AdoptionApplication[]>;
	findByUser(userId: string, petId: number): Promise<UserPetApplication>;
}
