import type { NextFunction, Request, Response } from "express";
import jwt from "jsonwebtoken";
import { env } from "../config/env.js";
import type { AuthTokenPayload } from "../types/auth.js";

export const requireAuth = (
  req: Request,
  res: Response,
  next: NextFunction,
): void => {
  const authHeader = req.headers.authorization;
  if (!authHeader || !authHeader.startsWith("Bearer ")) {
    res.status(401).json({ message: "Unauthorized" });
    return;
  }

  const token = authHeader.slice(7);

  try {
    const decoded = jwt.verify(token, env.JWT_SECRET);
    if (!decoded || typeof decoded === "string") {
      res.status(401).json({ message: "Unauthorized" });
      return;
    }

    const payload = decoded as AuthTokenPayload;
    req.user = payload;
    next();
  } catch {
    res.status(401).json({ message: "Unauthorized" });
  }
};
