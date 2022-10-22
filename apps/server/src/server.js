import express from "express";
import { join, dirname } from "path";
import { Octokit } from "octokit";
import { config as loadEnvironmentVariables } from "dotenv";
import { fileURLToPath } from "url";

loadEnvironmentVariables();

if (
  process.env.PORT === undefined ||
  process.env.GITHUB_PERSONAL_ACCESS_TOKEN === undefined
) {
  throw new Error(
    "The `PORT` and `GITHUB_PERSONAL_ACCESS_TOKEN` variables must exist in the environment."
  );
}

const app = express();
const octokit = new Octokit({ auth: process.env.GITHUB_PERSONAL_ACCESS_TOKEN });
const port = process.env.PORT;
const serverFilePath = fileURLToPath(import.meta.url);
const serverDirectory = dirname(serverFilePath);
const publicDirectory = join(serverDirectory, "..", "public");

app.use("/static", express.static(publicDirectory));

app.get("/auth", async (_, response) => {
  const { data: auth } = await octokit.rest.users.getAuthenticated();

  response.send({
    username: auth.login,
    name: auth.name,
    avatar: auth.avatar_url,
    location: auth.location,
    lastUpdated: auth.updated_at,
  });
});

app.get("*", (_, response) => {
  const index = join(publicDirectory, "index.html");

  response.sendFile(index);
});

app.listen(port, () => {
  console.log(`App listening at: http://localhost:${port}`);
});
