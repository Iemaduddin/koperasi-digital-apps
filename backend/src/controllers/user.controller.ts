import type { Request, Response } from "express";
import * as userService from "../services/user.service.js";

export const getAllUsersHandler = async (_req: Request, res: Response): Promise<void> => {
  try {
    const users = await userService.getAllUsers();
    res.status(200).json(users);
  } catch (error) {
    const message = error instanceof Error ? error.message : "Failed to fetch users";
    res.status(500).json({ message });
  }
};

export const getUserByIdHandler = async (req: Request, res: Response): Promise<void> => {
  const id = parseInt(req.params.id as string, 10);
  if (isNaN(id)) {
    res.status(400).json({ message: "Invalid user ID" });
    return;
  }

  try {
    const user = await userService.getUserById(id);
    if (!user) {
      res.status(404).json({ message: "User not found" });
      return;
    }
    res.status(200).json(user);
  } catch (error) {
    const message = error instanceof Error ? error.message : "Failed to fetch user";
    res.status(500).json({ message });
  }
};

export const createUserHandler = async (req: Request, res: Response): Promise<void> => {
  const { name, email, password, role } = req.body;
  if (!name || !email) {
    res.status(400).json({ message: "Name and email are required" });
    return;
  }

  try {
    const user = await userService.createUser({ name, email, password, role });
    res.status(201).json(user);
  } catch (error) {
    const message = error instanceof Error ? error.message : "Failed to create user";
    res.status(400).json({ message });
  }
};

export const updateUserHandler = async (req: Request, res: Response): Promise<void> => {
  const id = parseInt(req.params.id as string, 10);
  if (isNaN(id)) {
    res.status(400).json({ message: "Invalid user ID" });
    return;
  }

  const { name, email, role } = req.body;

  try {
    const user = await userService.updateUser(id, { name, email, role });
    res.status(200).json(user);
  } catch (error) {
    const message = error instanceof Error ? error.message : "Failed to update user";
    res.status(400).json({ message });
  }
};

export const deleteUserHandler = async (req: Request, res: Response): Promise<void> => {
  const id = parseInt(req.params.id as string, 10);
  if (isNaN(id)) {
    res.status(400).json({ message: "Invalid user ID" });
    return;
  }

  try {
    await userService.deleteUser(id);
    res.status(200).json({ message: "User deleted successfully" });
  } catch (error) {
    const message = error instanceof Error ? error.message : "Failed to delete user";
    res.status(400).json({ message });
  }
};

export const toggleBlockUserHandler = async (req: Request, res: Response): Promise<void> => {
  const id = parseInt(req.params.id as string, 10);
  if (isNaN(id)) {
    res.status(400).json({ message: "Invalid user ID" });
    return;
  }

  const { isBlocked } = req.body;
  if (typeof isBlocked !== "boolean") {
    res.status(400).json({ message: "isBlocked must be a boolean" });
    return;
  }

  try {
    const user = await userService.toggleBlockUser(id, isBlocked);
    res.status(200).json(user);
  } catch (error) {
    const message = error instanceof Error ? error.message : "Failed to update block status";
    res.status(400).json({ message });
  }
};
