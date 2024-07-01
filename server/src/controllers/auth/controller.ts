import { Request, Response } from "express";
import jwt from "jsonwebtoken";
import pool from "@config/database";
import { hash } from "@/utils/crypto";

export const register = async (req: Request, res: Response) => {
  const { email, password } = req.body;

  try {
    // check if user already exists in the database
    const user = await pool.query("SELECT * FROM users WHERE email = $1", [
      email,
    ]);
    if (user.rows.length > 0) {
      return res
        .status(400)
        .json({ message: "User with that email already exists." });
    }

    const hashed = await hash(password);

    // insert new user
    const newUser = await pool.query(
      `INSERT INTO users(email, password_hash) VALUES ($1, $2) RETURNING user_id, email`,
      [email, hashed],
    );

    res
      .status(201)
      .json({ message: "User created successfully.", user: newUser.rows[0] });
  } catch (error) {
    console.error("Something went wrong with registration.", error);
    res.status(500).json({
      message: "Something went wrong with registration. Error: [ACR1]",
    });
  }
};
