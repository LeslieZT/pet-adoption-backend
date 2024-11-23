import { Router } from "express";
import { authenticationRouter } from "./../context/authentication/authentication.routes";
import { userRouter } from "../context/user/user.routes";
import { storageRouter } from "../context/storage-mananger/storage-manager.routes";
import { donationRouter } from "../context/donation/donation.routes";

const mainRouter = Router();

mainRouter.use("/authentication", authenticationRouter);
mainRouter.use("/users", userRouter);
mainRouter.use("/storage", storageRouter);
mainRouter.use("/donations", donationRouter);

export default mainRouter;
