import express from "express";
import cookieParser from "cookie-parser";
import cors from "cors";
import { errorHandler } from "./middleware";
import { httpLoggerMiddleware } from "./utils/logger/http-logger";
import mainRouter from "./routes";

const app = express();

const whiteList = ["http://localhost:5173", "http://localhost:3000", "https://happypaws-app.vercel.app/"];

app.use(
	cors({
		origin: function (origin, callback) {
			if (!origin || whiteList.includes(origin)) {
				callback(null, true);
			} else {
				callback(new Error("Not allowed by CORS"));
			}
		},
		credentials: true,
		methods: ["GET", "POST", "PUT", "DELETE"],
	})
);
app.use(httpLoggerMiddleware);
app.use(express.json());
app.use(cookieParser());

app.get("/", (req, res) =>  {
    res.send("Hello World!")}
);

app.use("/api/v1", mainRouter);
app.use(errorHandler);

export default app;
