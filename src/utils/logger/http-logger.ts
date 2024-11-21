import { randomUUID } from "crypto";
import httpLogger from "pino-http";
import { logger } from "./logger";

export const httpLoggerMiddleware = httpLogger({
	logger: logger,
	genReqId: function (req, res) {
		const existingID = req.id ?? req.headers["x-request-id"];
		if (existingID) return existingID;
		const id = randomUUID();
		res.setHeader("X-Request-Id", id);
		return id;
	},
});
