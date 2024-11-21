import { Router } from "express";
import { authenticationRoutes } from "./../context/authentication/authentication.routes";
import { userRoutes } from "../context/user/user.routes";
import { storageRouter } from "../context/storage-mananger/storage-manager.routes";

const mainRouter = Router();

mainRouter.use("/authentication", authenticationRoutes);
mainRouter.use("/users", userRoutes);
mainRouter.use("/storage", storageRouter);

export default mainRouter;
