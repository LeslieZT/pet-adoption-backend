import { Router } from "express";
import { authenticationRouter } from "./../context/authentication/authentication.routes";
import { userRouter } from "../context/user/user.routes";
import { storageRouter } from "../context/storage-manager/storage-manager.routes";
import { donationRouter } from "../context/donation/donation.routes";
import { planRouter } from "../context/plan/plan.routes";
import { shelterRouter } from "../context/shelter/shelter.routes";
import { petRoutes } from "../context/pet/pet.routes";
import { placeRouter } from "../context/place/place.routes";
import { adoptionRoutes } from "../context/adoption/adoption.routes";
import { emailSenderRouter } from "../context/email-sender/email-sender.routes";

const mainRouter = Router();

mainRouter.use("/authentication", authenticationRouter);
mainRouter.use("/users", userRouter);
mainRouter.use("/storage", storageRouter);
mainRouter.use("/donations", donationRouter);
mainRouter.use("/plans", planRouter);
mainRouter.use("/shelters", shelterRouter);
mainRouter.use("/pets", petRoutes);
mainRouter.use("/places", placeRouter);
mainRouter.use("/adoptions", adoptionRoutes);
mainRouter.use("/email-sender", emailSenderRouter);

export default mainRouter;
