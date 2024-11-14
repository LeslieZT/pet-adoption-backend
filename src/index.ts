import http from "http";
import app from "./app";
import { config } from "./config/config";

(async () => {
	const { PORT } = config();
	const server = http.createServer(app);
	server.listen(PORT, () => {
		console.log(`Server is running on http://localhost:${PORT}`);
	});
})();
