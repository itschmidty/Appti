import { pbkdf2, randomBytes } from "crypto";
import { promisify } from "util";

const ITERATIONS = 100000;
const KEYLEN = 64;
const DIGEST = "sha512";

const pbkdf2Async = promisify(pbkdf2);

export const hash = async (password: string): Promise<string> => {
  const salt = randomBytes(16).toString("hex");
  const hash = await pbkdf2Async(password, salt, ITERATIONS, KEYLEN, DIGEST);

  return `${salt}:${hash.toString("hex")}`;
};
