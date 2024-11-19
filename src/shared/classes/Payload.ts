import { ChannelType } from "../../context/authentication/domain/enum/ChannelType.enum";

export interface PayloadRequestAttributtes {
	idUser: string;
	email: string;
	token: string;
	channel: ChannelType;
}
export class PayloadRequest {
	channel?: ChannelType;

	idUser: string;

	token: string;

	email: string;

	constructor(data: PayloadRequestAttributtes) {
		this.idUser = data.idUser;
		this.email = data.email;
		this.token = data.token;
		this.channel = data.channel;
	}
}
