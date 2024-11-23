import { DonationCreation, DonationEntity } from "./../entities/Donation.entity";

export interface DonationRepository {
	create(params: DonationCreation): Promise<DonationEntity>;
	update(donationId: string, data: Partial<DonationEntity>): Promise<void>;
}
