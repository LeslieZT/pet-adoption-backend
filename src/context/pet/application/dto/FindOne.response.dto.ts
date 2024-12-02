export interface FindOneResponseDto {
	petId: number;
	name: string;
	description: string;
	birthdate: Date;
	age: number;
	weight: string;
	height: string;
	gender: string;
	color: string;
	behavior: string[];
	profilePicture: string;
	breed: string;
	shelter: {
		name: string;
		address: string;
		phone: string;
		latitude: string;
		longitude: string;
		email: string;
		district: string;
		province: string;
		department: string;
	};
	photos: string[];
	isFavorite: boolean;
	applications: number;
}
