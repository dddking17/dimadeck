import { sql } from "@/lib/sql";

export const dynamic = "force-dynamic";

/** 덱/디지몬 카탈로그 — 로그인 없이 누구나 조회 */
export async function GET() {
  const db = sql();
  const [digimons, decks] = await Promise.all([
    db`select id, name, image_url, is_u_grade, created_at from digimons order by created_at asc, name asc`,
    db`select id, name, tier, description, effect, member_ids, order_index, created_at from decks order by created_at asc, name asc`,
  ]);
  return Response.json({ digimons, decks });
}
