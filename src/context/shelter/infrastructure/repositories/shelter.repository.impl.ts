import { injectable } from "inversify";
import { prisma } from "../../../../database/database";
import { ShelterRepository } from "../../domain/repositories/shelter.repository";

@injectable()
export class ShelterRepositoryImpl implements ShelterRepository {
	async searchPlacesAndShelters(search: string): Promise<any> {
		const searchTerm = `%${search}%`;
		const queryset = await prisma.$queryRaw`
            SELECT * 
            FROM search_places_and_shelters(${searchTerm}) LIMIT 5;
        `;
		return queryset;
	}
}
