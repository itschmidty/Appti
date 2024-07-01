import express, { Express, Request, Response, NextFunction } from "express";
import dotenv from "dotenv";
import pool from "@config/database";
import auth from "@routes/auth";

dotenv.config();

const app: Express = express();
const port = process.env.PORT || 3000;
app.use(express.json());

app.get("/", (req: Request, res: Response) => {
  res.send("Express + Typescript");
});

app.use("/api/auth", auth);

app.use((err: Error, req: Request, res: Response, next: NextFunction) => {
  console.log(err.stack);
  res.status(500).send("Something went completely wrong! Ask for help.");
});

// database connection test
app.get("/db", async (req: Request, res: Response) => {
  try {
    const result = await pool.query("SELECT NOW()");
    console.log(result);
    res.json({
      message: "Database connection successful",
      time: result.rows[0].now,
    });
  } catch (error) {
    res.status(500).json({
      message:
        "Something went wrong with the database connection. Try again later.",
    });
  }
});

app.listen(port, () => {
  console.log(`[server]: Server is running on port: ${port}`);
});

export default app;
