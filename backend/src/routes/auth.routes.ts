import { Router } from "express";
import {
  loginHandler,
  meHandler,
  registerHandler,
} from "../controllers/auth.controller.js";
import { requireAuth } from "../middlewares/auth.middleware.js";

const authRouter = Router();

authRouter.post("/register", registerHandler);
authRouter.post("/login", loginHandler);
authRouter.get("/me", requireAuth, meHandler);

export { authRouter };
