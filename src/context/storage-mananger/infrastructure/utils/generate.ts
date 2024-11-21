import moment from "moment";

export const generateKey = (fileName: string) => {
	const nowUtc = moment.utc();
	const dateString = nowUtc.format("YYYYMMDD_HHmmss");
	return `${dateString}_${fileName}`;
};
