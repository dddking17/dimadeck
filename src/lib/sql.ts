import { neon } from "@neondatabase/serverless";

type SqlClient = ReturnType<typeof neon<false, false>>;
let client: SqlClient | null = null;

/** Neon(Postgres) 연결. DATABASE_URL 은 Vercel Storage → Neon 을 연결하면 자동으로 들어옵니다. */
export function sql(): SqlClient {
  if (!client) {
    const url = process.env.DATABASE_URL;
    if (!url) throw new Error("DATABASE_URL 환경변수가 설정되지 않았습니다.");
    client = neon<false, false>(url);
  }
  return client;
}
