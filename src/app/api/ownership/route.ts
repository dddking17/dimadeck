import { sql } from "@/lib/sql";
import { isUuid, requireUser } from "@/lib/server-auth";

/** 내 보유 여부 저장 — 항상 로그인한 본인 ID로만 기록됩니다 */
export async function PUT(request: Request) {
  const { user, error } = await requireUser();
  if (!user) return error;

  const body = await request.json().catch(() => null);
  if (!body || !isUuid(body.digimonId) || typeof body.owned !== "boolean") {
    return Response.json({ error: "bad request" }, { status: 400 });
  }

  await sql()`
    insert into user_digimon_ownership (user_id, digimon_id, owned, updated_at)
    select ${user.id}, d.id, ${body.owned}, now() from digimons d where d.id = ${body.digimonId}::uuid
    on conflict (user_id, digimon_id) do update set owned = excluded.owned, updated_at = now()`;
  return Response.json({ ok: true });
}
