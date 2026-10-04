import { neon } from "@neondatabase/serverless";

type SqlClient = ReturnType<typeof neon<false, false>>;
let client: SqlClient | null = null;

/** Neon(Postgres) 연결. DATABASE_URL 은 Vercel Storage → Neon 을 연결하면 자동으로 들어옵니다. */
export function sql(): SqlClient {
  if (!client) {
    // Vercel 의 Neon 연동은 POSTGRES_URL 이름으로 넣어줍니다 (직접 설정한 DATABASE_URL 이 있으면 우선)
    const url = process.env.DATABASE_URL ?? process.env.POSTGRES_URL;
    if (!url) throw new Error("DATABASE_URL 또는 POSTGRES_URL 환경변수가 설정되지 않았습니다.");
    client = neon<false, false>(url);
  }
  return client;
}
