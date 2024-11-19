import http from "http";
import app from "./app";
import { config } from "./config/config";
import { logger } from "./utils/logger";

(async () => {
	const { PORT } = config();
	const server = http.createServer(app);
	server.listen(PORT, () => {
		logger.info(`Server is running on http://localhost:${PORT}`);
	});
})();
