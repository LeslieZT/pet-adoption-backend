import { Router } from "express";
import { authenticationRoutes } from "./../context/authentication/authentication.routes";

const mainRouter = Router();

mainRouter.use("/authentication", authenticationRoutes);

export default mainRouter;