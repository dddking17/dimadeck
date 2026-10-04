// Neon DB 초기 세팅: 스키마 + 시드 데이터를 한 번에 실행합니다.
// 사용법:  npm run db:setup
// .env.local 에 DATABASE_URL (또는 POSTGRES_URL) 이 있어야 합니다. 여러 번 실행해도 안전합니다.
import { readFileSync, readdirSync } from "node:fs";
import pg from "pg";

function loadEnv() {
  try {
    for (const line of readFileSync(".env.local", "utf8").split(/\r?\n/)) {
      const m = line.match(/^\s*([A-Z0-9_]+)\s*=\s*"?([^"]*)"?\s*$/);
      if (m && !(m[1] in process.env)) process.env[m[1]] = m[2];
    }
  } catch {}
}
loadEnv();

const url = process.env.DATABASE_URL || process.env.POSTGRES_URL;
if (!url) {
  console.error(".env.local 에 DATABASE_URL (또는 POSTGRES_URL) 값이 없습니다.");
  process.exit(1);
}

// db/setup/ 안의 번호 순서(01_, 02_, …)대로 실행합니다. 파일을 추가하려면 번호만 맞춰 넣으면 됩니다.
const files = readdirSync("db/setup")
  .filter((f) => f.endsWith(".sql"))
  .sort()
  .map((f) => `db/setup/${f}`);

const client = new pg.Client({ connectionString: url, ssl: { rejectUnauthorized: false } });
await client.connect();
try {
  for (const f of files) {
    process.stdout.write(`${f} ... `);
    await client.query(readFileSync(f, "utf8"));
    console.log("OK");
  }
  const r = await client.query("select (select count(*) from decks) as decks, (select count(*) from digimons) as digimons");
  console.log("완료 → 덱", r.rows[0].decks, "개, 디지몬", r.rows[0].digimons, "종");
} catch (e) {
  console.error("\n실패:", e.message);
  process.exitCode = 1;
} finally {
  await client.end();
}
