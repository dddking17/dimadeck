import { sql } from "@/lib/sql";
import { getSessionUser } from "@/lib/server-auth";

export const dynamic = "force-dynamic";

/** 로그인한 사용자의 보유 디지몬 / 즐겨찾기 덱. 비로그인이면 빈 값 */
export async function GET() {
  const user = await getSessionUser();
  if (!user) return Response.json({ ownership: {}, favorites: [] });

  const db = sql();
  const [own, fav] = await Promise.all([
    db`select digimon_id, owned from user_digimon_ownership where user_id = ${user.id}`,
    db`select deck_id from user_deck_favorites where user_id = ${user.id}`,
  ]);
  const ownership: Record<string, boolean> = {};
  for (const row of own) ownership[row.digimon_id as string] = row.owned as boolean;
  return Response.json({ ownership, favorites: fav.map((r) => r.deck_id as string) });
}
