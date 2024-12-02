import { injectable } from "inversify";
import { Prisma } from "@prisma/client";
import { prisma } from "../../../../database/database";
import {
	FindAllFavoriteParams,
	FindAllParams,
	PetRepository,
} from "../../domain/repositories/pet.repository";
import {
	CountApplicationResult,
	FindAllResult,
	Pet,
	PetResult,
} from "../../domain/entities/Pet.entity";

@injectable()
export class PetRepositoryImpl implements PetRepository {
	async findAll(params: FindAllParams): Promise<FindAllResult> {
		const whereConditions = [];
		if (params.location) {
			whereConditions.push(
				Prisma.sql`(S.address ILIKE ${`%${params.location}%`} OR S.name ILIKE ${`%${params.location}%`})`
			);
		}

		if (params.petType) {
			whereConditions.push(Prisma.sql`P.category_id = ${params.petType}`);
		}

		if (params.gender) {
			whereConditions.push(Prisma.sql`P.gender = ${params.gender}`);
		}

		if (params.age) {
			const minAgeCondition = Prisma.sql`(EXTRACT(YEAR FROM AGE(P.birthdate)) * 12 + EXTRACT(MONTH FROM AGE(P.birthdate))) >= ${params.age.minAge}`;
			const maxAgeCondition = params.age.maxAge
				? Prisma.sql`AND (EXTRACT(YEAR FROM AGE(P.birthdate)) * 12 + EXTRACT(MONTH FROM AGE(P.birthdate))) <= ${params.age.maxAge}`
				: Prisma.empty;

			whereConditions.push(Prisma.sql`${minAgeCondition} ${maxAgeCondition}`);
		}

		if (params.option) {
			if (params.option.field === "shelter_id") {
				whereConditions.push(Prisma.sql`S.shelter_id = ${params.option.id}::uuid`);
			} else {
				whereConditions.push(
					Prisma.sql`D.${Prisma.raw(params.option.field)} = ${parseInt(params.option.id)}`
				);
			}
		}

		const baseQuery = Prisma.sql`
            SELECT 
                ${params.idUser ? Prisma.sql`COALESCE(FP.value, false) AS is_favorite,` : Prisma.empty}
                P.pet_id,
                P.category_id,
                P.name as pet_name, 
                P.profile_picture, 
                P.gender, 
                P.breed_id, 
                P.birthdate, 
                EXTRACT(YEAR FROM AGE(P.birthdate)) * 12 + EXTRACT(MONTH FROM AGE(P.birthdate)) AS total_months,
                S.shelter_id,
                S.name as shelter_name, 
                S.address,
                D.district_id,
                D.province_id,
                D.department_id
            FROM public.pets P
            INNER JOIN public.shelters S ON S.shelter_id = P.shelter_id
            INNER JOIN public.districts D ON D.district_id = S.district_id
            ${params.idUser ? Prisma.sql`LEFT JOIN public.favorite_pets FP ON FP.pet_id = P.pet_id AND FP.user_id = ${Prisma.sql`uuid(${params.idUser})`}` : Prisma.empty}
            WHERE P.status = 'Available' ${whereConditions.length ? Prisma.sql` AND ${Prisma.join(whereConditions, " AND ")}` : Prisma.empty}`;

		const query = Prisma.sql`${baseQuery} ORDER BY P.name ASC LIMIT ${params.limit} OFFSET ${params.offset};`;
		const totalRowsQuery = Prisma.sql`SELECT COUNT(*)::int AS total FROM (${baseQuery}) AS total_data;`;
		const result = (await prisma.$queryRaw(query)) as PetResult[];
		const total = await prisma.$queryRaw(totalRowsQuery);
		return { total: total[0].total, rows: result };
	}

	async countApplications(params: number[]): Promise<CountApplicationResult[]> {
		const query = Prisma.sql`
            SELECT P.pet_id, COUNT(A.adoption_id)::int AS applications 
            FROM public.pets P
            LEFT JOIN public.adoptions A ON A.pet_id = P.pet_id
            WHERE ${params.length ? Prisma.sql`P.pet_id IN (${Prisma.join(params, ",")})` : Prisma.empty}
            GROUP BY P.pet_id 
            ORDER BY P.name ASC;
        `;
		const result = (await prisma.$queryRaw(query)) as CountApplicationResult[];
		return result;
	}

	async findOne(id: number): Promise<Pet> {
		const query = await prisma.pet.findFirst({
			where: { petId: id },
			include: {
				shelter: {
					select: {
						name: true,
						address: true,
						phone: true,
						email: true,
						latitude: true,
						longitude: true,
						district: {
							select: {
								name: true,
								department: {
									select: {
										name: true,
									},
								},
								province: {
									select: {
										name: true,
									},
								},
							},
						},
					},
				},
				breed: {
					select: { name: true },
				},
				photos: {
					select: { url: true },
				},
			},
		});
		return query;
	}

	async getPetApplications(petId: number): Promise<number> {
		const query = Prisma.sql`
            SELECT COUNT(A.adoption_id)::int AS applications 
            FROM public.adoptions A
            WHERE A.pet_id = ${petId}
        `;
		const result = await prisma.$queryRaw(query);
		return result[0].applications;
	}

	async getPetMonths(petId: number): Promise<number> {
		const query = Prisma.sql`
            SELECT EXTRACT(YEAR FROM AGE(P.birthdate)) * 12 + EXTRACT(MONTH FROM AGE(P.birthdate)) AS total_months
            FROM public.pets P
            WHERE P.pet_id = ${petId}
        `;
		const result = await prisma.$queryRaw(query);
		return result[0].total_months;
	}

	async findAllFavorite(params: FindAllFavoriteParams): Promise<FindAllResult> {
		const baseQuery = Prisma.sql`
            SELECT  
				true AS is_favorite,          
                P.pet_id,
                P.category_id,
                P.name as pet_name, 
                P.profile_picture, 
                P.gender, 
                P.breed_id, 
                P.birthdate, 
                P.status,
                EXTRACT(YEAR FROM AGE(P.birthdate)) * 12 + EXTRACT(MONTH FROM AGE(P.birthdate)) AS total_months,
                S.shelter_id,
                S.name as shelter_name, 
                S.address,
                D.district_id,
                D.province_id,
                D.department_id
            FROM public.pets P
            INNER JOIN public.shelters S ON S.shelter_id = P.shelter_id
            INNER JOIN public.districts D ON D.district_id = S.district_id
            INNER JOIN public.favorite_pets FP ON FP.pet_id = P.pet_id AND FP.user_id = ${Prisma.sql`uuid(${params.userId})`}
			WHERE FP.value = true
			`;

		const query = Prisma.sql`${baseQuery} ORDER BY P.name ASC LIMIT ${params.limit} OFFSET ${params.offset};`;
		const totalRowsQuery = Prisma.sql`SELECT COUNT(*)::int AS total FROM (${baseQuery}) AS total_data;`;

		const result = (await prisma.$queryRaw(query)) as PetResult[];
		const total = await prisma.$queryRaw(totalRowsQuery);
		return { total: total[0].total, rows: result };
	}
}
