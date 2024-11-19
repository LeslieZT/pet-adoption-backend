import express from "express";
import cookieParser from "cookie-parser";
import cors from "cors";
import { errorHandler } from "./middleware";
import { httpLoggerMiddleware } from "./utils/logger/http-logger";
import mainRouter from "./routes";

const app = express();

const whiteList = ["http://localhost:5173", "http://localhost:3000", "https://example.com"];

app.use(
	cors({
		origin: function (origin, callback) {
			if (!origin || whiteList.includes(origin)) {
				callback(null, true);
			} else {
				callback(new Error("Not allowed by CORS"));
			}
		},
	})
);
// app.use(httpLoggerMiddleware);
app.use(express.json());
app.use(cookieParser());
app.use(mainRouter);
app.use(errorHandler);

export default app;
