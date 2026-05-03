import type { Role } from "../../generated/prisma/client.ts";

export type AuthTokenPayload = {
  userId: number;
  email: string;
  role: Role;
};
