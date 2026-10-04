import { sql } from "@/lib/sql";
import { isUuid, requireAdmin } from "@/lib/server-auth";

/** 디지몬 등록/수정 (관리자 전용). image_url / is_u_grade 는 보낸 경우에만 갱신 */
export async function POST(request: Request) {
  const { user, error } = await requireAdmin();
  if (!user) return error;

  const b = await request.json().catch(() => null);
  const name = typeof b?.name === "string" ? b.name.trim() : "";
  if (!name || name.length > 100) return Response.json({ error: "bad name" }, { status: 400 });
  if (b.id != null && !isUuid(b.id)) return Response.json({ error: "bad id" }, { status: 400 });
  if (b.image_url != null && (typeof b.image_url !== "string" || b.image_url.length > 2000)) {
    return Response.json({ error: "bad image_url" }, { status: 400 });
  }

  const hasImage = b.image_url !== undefined;
  const hasU = typeof b.is_u_grade === "boolean";

  const rows = await sql()`
    insert into digimons (id, name, image_url, is_u_grade)
    values (coalesce(${b.id ?? null}::uuid, gen_random_uuid()), ${name}, ${b.image_url ?? null}, ${hasU ? b.is_u_grade : false})
    on conflict (id) do update set
      name = excluded.name,
      image_url = case when ${hasImage}::boolean then excluded.image_url else digimons.image_url end,
      is_u_grade = case when ${hasU}::boolean then excluded.is_u_grade else digimons.is_u_grade end
    returning id, name, image_url, is_u_grade, created_at`;
  return Response.json(rows[0]);
}

/** 디지몬 삭제 (관리자 전용) — 모든 덱의 구성원에서도 함께 제거 */
export async function DELETE(request: Request) {
  const { user, error } = await requireAdmin();
  if (!user) return error;

  const id = new URL(request.url).searchParams.get("id");
  if (!isUuid(id)) return Response.json({ error: "bad id" }, { status: 400 });

  const db = sql();
  await db`update decks set member_ids = array_remove(member_ids, ${id}::uuid) where ${id}::uuid = any(member_ids)`;
  await db`delete from digimons where id = ${id}::uuid`;
  return Response.json({ ok: true });
}
