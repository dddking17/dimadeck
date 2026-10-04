// Neon DB 초기 세팅: db/setup/ 의 SQL 을 번호 순서대로 한 번에 실행합니다.
//
// 사용법 (둘 중 하나)
//   npm run db:setup -- "postgres://...."        ← Vercel 의 POSTGRES_URL 값을 따옴표로 감싸 붙여넣기
//   npm run db:setup                              ← .env.local 이나 환경변수에 값이 이미 있을 때
//
// 여러 번 실행해도 안전하지만, 덱 설명/이미지/U등급/정렬은 파일 내용으로 덮어씁니다.
// (앱에서 관리자 화면으로 직접 수정한 내용은 다시 실행하면 원래 값으로 돌아가요.)
import { readFileSync, readdirSync } from "node:fs";
import pg from "pg";

// .env.local 의 값을 불러옵니다 (이미 설정된 환경변수가 우선)
try {
  for (const line of readFileSync(".env.local", "utf8").split(/\r?\n/)) {
    const m = line.match(/^\s*([A-Z0-9_]+)\s*=\s*(.*?)\s*$/);
    if (m && !(m[1] in process.env)) process.env[m[1]] = m[2];
  }
} catch {}

const clean = (v) => (v ?? "").trim().replace(/^["']+|["']+$/g, "");
const argUrl = process.argv.slice(2).find((a) => /^postgres(ql)?:\/\//i.test(clean(a)));
const url = clean(
  argUrl ??
    process.env.POSTGRES_URL_NON_POOLING ??
    process.env.DATABASE_URL_UNPOOLED ??
    process.env.DATABASE_URL ??
    process.env.POSTGRES_URL
);
if (!/^postgres(ql)?:\/\//i.test(url)) {
  console.error(
    "DB 주소를 찾지 못했습니다.\n" +
      '  npm run db:setup -- "postgres://..."  처럼 Vercel 의 POSTGRES_URL 값을 따옴표로 감싸 넣어 주세요.'
  );
  process.exit(1);
}

let host = "";
try { host = new URL(url).hostname; } catch {}
const isLocal = ["localhost", "127.0.0.1", "::1"].includes(host);

// db/setup/ 안의 번호 순서(01_, 02_, …)대로 실행합니다. 파일을 추가하려면 번호만 맞춰 넣으면 됩니다.
const files = readdirSync("db/setup")
  .filter((f) => f.endsWith(".sql"))
  .sort()
  .map((f) => `db/setup/${f}`);

const client = new pg.Client({ connectionString: url, ssl: isLocal ? false : { rejectUnauthorized: false } });
try {
  console.log(`연결 대상: ${host}`);
  await client.connect();
  for (const f of files) {
    process.stdout.write(`${f} ... `);
    await client.query(readFileSync(f, "utf8"));
    console.log("OK");
  }
  const { rows } = await client.query(`
    select
      (select count(*) from decks)::int as decks,
      (select count(*) from digimons)::int as digimons,
      (select count(*) from digimons where image_url is not null)::int as images,
      (select count(*) from digimons where is_u_grade)::int as u_grade,
      (select count(*) from decks where description = '' or effect = '')::int as decks_missing_details,
      (select count(*) from decks where order_index = 0)::int as decks_unordered`);
  const r = rows[0];
  console.log(`\n완료 → 덱 ${r.decks}개, 디지몬 ${r.digimons}종, 이미지 ${r.images}개, U등급 ${r.u_grade}종`);
  const warn = [];
  if (r.decks_missing_details) warn.push(`설명/효과가 빈 덱 ${r.decks_missing_details}개`);
  if (r.decks_unordered) warn.push(`정렬 순서가 없는 덱 ${r.decks_unordered}개`);
  console.log(warn.length ? `⚠ 확인 필요: ${warn.join(", ")}` : "✔ 설명/효과/정렬 모두 채워졌습니다");
} catch (e) {
  console.error("\n실패:", e.message);
  process.exitCode = 1;
} finally {
  await client.end().catch(() => {});
}
