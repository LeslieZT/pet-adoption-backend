export interface PetFavoriteRepository {
	findOne(petId: number, userId: string): Promise<any>;
	create(petId: number, userId: string, value: boolean): Promise<void>;
	update(favoritePetId: number, value: boolean): Promise<void>;
}
