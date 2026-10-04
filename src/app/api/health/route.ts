import { sql } from "@/lib/sql";

export const dynamic = "force-dynamic";

/**
 * 배포 점검용. 설정이 빠졌거나 오타가 있는지 한눈에 확인합니다.
 * 비밀값 자체는 절대 노출하지 않고, "설정됨/누락/형식 이상"만 알려줍니다.
 * 사용: https://<내 주소>/api/health  →  problems 가 비어 있으면 준비 완료.
 */

type Level = "ok" | "missing" | "bad-format";

const clean = (v?: string) => (v ?? "").trim();
const hasJunk = (v: string) => /\s/.test(v) || /^["']|["']$/.test(v);

function checkValue(v: string | undefined, valid: (s: string) => boolean): Level {
  const s = clean(v);
  if (!s) return "missing";
  if (hasJunk(s) || s !== v || !valid(s)) return "bad-format";
  return "ok";
}

function dbRegion(url?: string) {
  return url?.match(/\.([a-z]{2}-[a-z]+-\d+)\.(?:aws|azure)\.neon\.tech/i)?.[1] ?? null;
}

export async function GET() {
  const env = process.env;
  const dbUrl = env.DATABASE_URL ?? env.POSTGRES_URL;
  const problems: string[] = [];

  // ── DB 연결 + 데이터 완성도
  let db: Record<string, unknown>;
  try {
    const t0 = Date.now();
    const rows = await sql()`
      select
        (select count(*) from decks)::int as decks,
        (select count(*) from digimons)::int as digimons,
        (select count(*) from digimons where image_url is not null)::int as digimons_with_image,
        (select count(*) from decks where description <> '' and effect <> '')::int as decks_with_details`;
    db = { ok: true, ms: Date.now() - t0, region: dbRegion(dbUrl), ...rows[0] };
    if (!rows[0].decks) problems.push("DB는 연결됐지만 덱 데이터가 없습니다 → npm run db:setup (또는 db/setup/ SQL 실행)");
    else if (rows[0].decks_with_details < rows[0].decks) {
      problems.push(`덱 ${rows[0].decks - rows[0].decks_with_details}개에 설명/효과가 비어 있습니다 → db/setup/05~07 실행`);
    }
  } catch (e) {
    const msg = e instanceof Error ? e.message : "";
    db = { ok: false, error: /does not exist/.test(msg) ? "tables-missing" : "cannot-connect" };
    problems.push(
      !dbUrl
        ? "DB 주소 환경변수(POSTGRES_URL 또는 DATABASE_URL)가 없습니다 → Vercel Storage에서 Neon 연결"
        : /does not exist/.test(msg)
          ? "DB 테이블이 없습니다 → db/setup/01_schema.sql 부터 실행"
          : "DB에 연결하지 못했습니다 → Neon 연결/환경변수 확인"
    );
  }

  // ── 로그인 설정
  const authSecret = checkValue(env.AUTH_SECRET ?? env.NEXTAUTH_SECRET, (s) => s.length >= 16);
  const googleClientId = checkValue(env.AUTH_GOOGLE_ID, (s) => s.endsWith(".apps.googleusercontent.com"));
  const googleClientSecret = checkValue(env.AUTH_GOOGLE_SECRET, (s) => s.length >= 10);
  // ADMIN_EMAIL 은 서버가 공백/따옴표를 정리해서 읽으므로 이메일 형태인지만 확인
  const adminParts = clean(env.ADMIN_EMAIL).split(",").map((x) => x.trim().replace(/^["']+|["']+$/g, ""));
  const adminEmail: Level = !clean(env.ADMIN_EMAIL)
    ? "missing"
    : adminParts.every((x) => /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(x))
      ? "ok"
      : "bad-format";

  const label: Record<string, string> = { missing: "없음", "bad-format": "형식이 이상함(공백/따옴표/오타 확인)" };
  for (const [name, level] of [
    ["AUTH_SECRET", authSecret],
    ["AUTH_GOOGLE_ID", googleClientId],
    ["AUTH_GOOGLE_SECRET", googleClientSecret],
    ["ADMIN_EMAIL", adminEmail],
  ] as [string, Level][]) {
    if (level !== "ok") problems.push(`${name} ${label[level]} → Vercel 환경변수 확인 후 Redeploy`);
  }

  // ── 이미지 업로드(Blob): 토큰 또는 스토어 ID 가 있어야 합니다 (없어도 조회/보유 체크는 정상)
  const blob = clean(env.BLOB_READ_WRITE_TOKEN) ? "token" : clean(env.BLOB_STORE_ID) ? "store-id-only" : "missing";
  if (blob === "missing") problems.push("(선택) Blob 연결 없음 → 관리자 이미지 업로드만 안 됩니다");

  return Response.json(
    {
      ready: problems.filter((p) => !p.startsWith("(선택)")).length === 0,
      problems,
      db,
      auth: { authSecret, googleClientId, googleClientSecret, adminEmail },
      blob,
      functionRegion: env.VERCEL_REGION ?? null,
    },
    { headers: { "Cache-Control": "no-store" } }
  );
}
