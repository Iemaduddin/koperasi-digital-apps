import * as bcrypt from "bcrypt";
import type { Role, User } from "../../generated/prisma/client.js";
import { prisma } from "../prisma/client.js";

type SafeUser = Omit<User, "password">;

const SALT_ROUNDS = 10;

const toSafeUser = (user: User): SafeUser => {
  const { password: _password, ...safeUser } = user;
  return safeUser;
};

export const getAllUsers = async (): Promise<SafeUser[]> => {
  const users = await prisma.user.findMany({
    orderBy: { createdAt: "desc" },
  });
  return users.map(toSafeUser);
};

export const getUserById = async (id: number): Promise<SafeUser | null> => {
  const user = await prisma.user.findUnique({ where: { id } });
  return user ? toSafeUser(user) : null;
};

export const createUser = async (data: {
  name: string;
  email: string;
  password?: string;
  role?: Role;
}): Promise<SafeUser> => {
  const normalizedEmail = data.email.trim().toLowerCase();
  const existingUser = await prisma.user.findUnique({
    where: { email: normalizedEmail },
  });

  if (existingUser) {
    throw new Error("Email already in use");
  }

  // Default password if not provided
  const rawPassword = data.password || "password123";
  const hashedPassword = await bcrypt.hash(rawPassword, SALT_ROUNDS);

  const roleData = data.role ? { role: data.role } : {};
  const user = await prisma.user.create({
    data: {
      name: data.name.trim(),
      email: normalizedEmail,
      password: hashedPassword,
      ...roleData,
    },
  });

  return toSafeUser(user);
};

export const updateUser = async (
  id: number,
  data: { name?: string; email?: string; role?: Role },
): Promise<SafeUser> => {
  const user = await prisma.user.findUnique({ where: { id } });
  if (!user) throw new Error("User not found");

  let normalizedEmail = data.email;
  if (data.email) {
    normalizedEmail = data.email.trim().toLowerCase();
    const existingUser = await prisma.user.findUnique({
      where: { email: normalizedEmail },
    });
    if (existingUser && existingUser.id !== id) {
      throw new Error("Email already in use");
    }
  }

  const updateData: any = {};
  if (data.name) updateData.name = data.name.trim();
  if (normalizedEmail) updateData.email = normalizedEmail;
  if (data.role) updateData.role = data.role;

  const updatedUser = await prisma.user.update({
    where: { id },
    data: updateData,
  });

  return toSafeUser(updatedUser);
};

export const deleteUser = async (id: number): Promise<void> => {
  await prisma.user.delete({ where: { id } });
};

export const toggleBlockUser = async (id: number, isBlocked: boolean): Promise<SafeUser> => {
  const updatedUser = await prisma.user.update({
    where: { id },
    data: { isBlocked },
  });
  return toSafeUser(updatedUser);
};
