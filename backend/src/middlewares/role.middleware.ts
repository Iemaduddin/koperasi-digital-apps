import type { NextFunction, Request, Response } from "express";

export const requireRoles = (roles: string[]) => {
  return (req: Request, res: Response, next: NextFunction): void => {
    const userRole = req.user?.role;

    if (!userRole) {
      res.status(401).json({ message: "Unauthorized: No role found" });
      return;
    }

    if (!roles.includes(userRole)) {
      res.status(403).json({ message: "Forbidden: You do not have access to this resource" });
      return;
    }

    next();
  };
};
