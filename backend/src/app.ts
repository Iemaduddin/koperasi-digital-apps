import express from "express";
import { authRouter } from "./routes/auth.routes.js";
import { userRouter } from "./routes/user.routes.js";

const app = express();

app.use(express.json());

app.get("/health", (_req, res) => {
  res.status(200).json({ status: "ok" });
});

app.use("/api/auth", authRouter);
app.use("/api/users", userRouter);

export { app };
