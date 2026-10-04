import { sql } from "@/lib/sql";
import { isUuid, requireUser } from "@/lib/server-auth";

/** 내 즐겨찾기 덱 저장 — 항상 로그인한 본인 ID로만 기록됩니다 */
export async function PUT(request: Request) {
  const { user, error } = await requireUser();
  if (!user) return error;

  const body = await request.json().catch(() => null);
  if (!body || !isUuid(body.deckId) || typeof body.favorited !== "boolean") {
    return Response.json({ error: "bad request" }, { status: 400 });
  }

  const db = sql();
  if (body.favorited) {
    await db`
      insert into user_deck_favorites (user_id, deck_id)
      select ${user.id}, d.id from decks d where d.id = ${body.deckId}::uuid
      on conflict do nothing`;
  } else {
    await db`delete from user_deck_favorites where user_id = ${user.id} and deck_id = ${body.deckId}::uuid`;
  }
  return Response.json({ ok: true });
}
