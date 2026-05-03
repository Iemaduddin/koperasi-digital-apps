import * as bcrypt from "bcrypt";
import jwt from "jsonwebtoken";
import type { Role, User } from "../../generated/prisma/client.js";
import { env } from "../config/env.js";
import { prisma } from "../prisma/client.js";
import type { AuthTokenPayload } from "../types/auth.js";

type RegisterInput = {
  name: string;
  email: string;
  password: string;
  role?: Role;
};

type LoginInput = {
  email: string;
  password: string;
};

type SafeUser = Omit<User, "password">;

const SALT_ROUNDS = 10;

const toSafeUser = (user: User): SafeUser => {
  const { password: _password, ...safeUser } = user;
  return safeUser;
};

const createAccessToken = (payload: AuthTokenPayload): string => {
  const signOptions: jwt.SignOptions = {};
  if (env.JWT_EXPIRES_IN) {
    signOptions.expiresIn =
      env.JWT_EXPIRES_IN as Exclude<jwt.SignOptions["expiresIn"], undefined>;
  }

  return jwt.sign(payload, env.JWT_SECRET, signOptions);
};

export const register = async (
  input: RegisterInput,
): Promise<{ user: SafeUser; token: string }> => {
  const normalizedEmail = input.email.trim().toLowerCase();
  const existingUser = await prisma.user.findUnique({
    where: { email: normalizedEmail },
  });

  if (existingUser) {
    throw new Error("Email already registered");
  }

  const hashedPassword = await bcrypt.hash(input.password, SALT_ROUNDS);
  const roleData = input.role ? { role: input.role } : {};
  const user = await prisma.user.create({
    data: {
      name: input.name.trim(),
      email: normalizedEmail,
      password: hashedPassword,
      ...roleData,
    },
  });

  const token = createAccessToken({
    userId: user.id,
    email: user.email,
    role: user.role,
  });

  return {
    user: toSafeUser(user),
    token,
  };
};

export const login = async (
  input: LoginInput,
): Promise<{ user: SafeUser; token: string }> => {
  const normalizedEmail = input.email.trim().toLowerCase();
  const user = await prisma.user.findUnique({
    where: { email: normalizedEmail },
  });

  if (!user) {
    throw new Error("Invalid credentials");
  }

  if (user.isBlocked) {
    throw new Error("Akun Anda telah diblokir. Silakan hubungi admin.");
  }

  const isPasswordValid = await bcrypt.compare(input.password, user.password);
  if (!isPasswordValid) {
    throw new Error("Invalid credentials");
  }

  const token = createAccessToken({
    userId: user.id,
    email: user.email,
    role: user.role,
  });

  return {
    user: toSafeUser(user),
    token,
  };
};

export const getProfile = async (userId: number): Promise<SafeUser> => {
  const user = await prisma.user.findUnique({ where: { id: userId } });
  if (!user) {
    throw new Error("User not found");
  }

  return toSafeUser(user);
};
