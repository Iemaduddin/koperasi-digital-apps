import { Router } from "express";
import {
  createUserHandler,
  deleteUserHandler,
  getAllUsersHandler,
  getUserByIdHandler,
  toggleBlockUserHandler,
  updateUserHandler,
} from "../controllers/user.controller.js";
import { requireAuth } from "../middlewares/auth.middleware.js";
import { requireRoles } from "../middlewares/role.middleware.js";

const userRouter = Router();

// Semua rute user management hanya bisa diakses oleh MASTER_ADMIN dan SUPER_ADMIN
userRouter.use(requireAuth);
userRouter.use(requireRoles(["MASTER_ADMIN", "SUPER_ADMIN"]));

userRouter.get("/", getAllUsersHandler);
userRouter.get("/:id", getUserByIdHandler);
userRouter.post("/", createUserHandler);
userRouter.put("/:id", updateUserHandler);
userRouter.delete("/:id", deleteUserHandler);
userRouter.patch("/:id/block", toggleBlockUserHandler);

export { userRouter };
