import type { Request, Response } from "express";
import { getProfile, login, register } from "../services/auth.service.js";

export const registerHandler = async (
  req: Request,
  res: Response,
): Promise<void> => {
  const { name, email, password, role } = req.body ?? {};

  if (!name || !email || !password) {
    res.status(400).json({ message: "name, email, and password are required" });
    return;
  }

  try {
    const result = await register({ name, email, password, role });
    res.status(201).json(result);
  } catch (error) {
    const message = error instanceof Error ? error.message : "Register failed";
    res.status(400).json({ message });
  }
};

export const loginHandler = async (
  req: Request,
  res: Response,
): Promise<void> => {
  const { email, password } = req.body ?? {};

  if (!email || !password) {
    res.status(400).json({ message: "email and password are required" });
    return;
  }

  try {
    const result = await login({ email, password });
    res.status(200).json(result);
  } catch (error) {
    const message = error instanceof Error ? error.message : "Login failed";
    res.status(401).json({ message });
  }
};

export const meHandler = async (req: Request, res: Response): Promise<void> => {
  const userId = req.user?.userId;

  if (!userId) {
    res.status(401).json({ message: "Unauthorized" });
    return;
  }

  try {
    const user = await getProfile(userId);
    res.status(200).json({ user });
  } catch (error) {
    const message = error instanceof Error ? error.message : "Failed to load user";
    res.status(404).json({ message });
  }
};
