import { sql } from "@/lib/sql";
import { isUuid, requireAdmin } from "@/lib/server-auth";

const TIERS = new Set(["S", "A", "B", "C", "D"]);

/** 덱 등록/수정 (관리자 전용) */
export async function POST(request: Request) {
  const { user, error } = await requireAdmin();
  if (!user) return error;

  const b = await request.json().catch(() => null);
  const name = typeof b?.name === "string" ? b.name.trim() : "";
  if (!name || name.length > 200) return Response.json({ error: "bad name" }, { status: 400 });
  if (b.id != null && !isUuid(b.id)) return Response.json({ error: "bad id" }, { status: 400 });
  const tier = TIERS.has(b.tier) ? b.tier : "A";
  const description = typeof b.description === "string" ? b.description.slice(0, 5000) : "";
  const effect = typeof b.effect === "string" ? b.effect.slice(0, 5000) : "";
  const memberIds: string[] = Array.isArray(b.member_ids) ? b.member_ids : [];
  if (memberIds.length > 200 || !memberIds.every(isUuid)) {
    return Response.json({ error: "bad member_ids" }, { status: 400 });
  }

  const rows = await sql()`
    insert into decks (id, name, tier, description, effect, member_ids)
    values (coalesce(${b.id ?? null}::uuid, gen_random_uuid()), ${name}, ${tier}, ${description}, ${effect}, ${memberIds}::uuid[])
    on conflict (id) do update set
      name = excluded.name, tier = excluded.tier, description = excluded.description,
      effect = excluded.effect, member_ids = excluded.member_ids
    returning id, name, tier, description, effect, member_ids, order_index, created_at`;
  return Response.json(rows[0]);
}

/** 덱 삭제 (관리자 전용) */
export async function DELETE(request: Request) {
  const { user, error } = await requireAdmin();
  if (!user) return error;

  const id = new URL(request.url).searchParams.get("id");
  if (!isUuid(id)) return Response.json({ error: "bad id" }, { status: 400 });

  await sql()`delete from decks where id = ${id}::uuid`;
  return Response.json({ ok: true });
}
