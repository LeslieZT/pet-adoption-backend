export interface AdoptionEntity {
	userId: string;
	adoptionId: string;
	application: {
		housingType: string;
		isPlaceOwned: boolean;
		hasPermission: boolean;
		hasOutdoorSpace: boolean;
		hasPastExperience: boolean;
		canCoverCosts: boolean;
		canTakePetWalk: boolean;
		canTakeTimeOff: boolean;
		agreesToVisit: boolean;
		agreesToFollowUp: boolean;
		adoptionReason: string;
		situationChange: string;
	};
	status: string;
	petId: number;
	createdAt: Date;
	updatedAt: Date | null;
}

export interface AdoptionApplication {
	adoptionId: string;
	status: string;
	petId: number;
	createdAt: Date;
	pet: {
		name: string;
		category: {
			name: string;
		};
	};
}

export interface UserPetApplication {
	adoptionId: string;
	status: string;
	petId: number;
	createdAt: Date;
}
