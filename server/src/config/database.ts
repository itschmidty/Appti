import { Pool } from "pg";
import dotenv from "dotenv";

dotenv.config();

const pool = new Pool({
  connectionString: process.env.DATABASE_URL,
});

pool.on("connect", () => {
  console.log("Connected to the database.");
});

pool.on("error", (err) => {
  console.error("Something went wrong with the database connection:", err);
  process.exit(-1);
});

export default pool;
