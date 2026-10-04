import { put } from "@vercel/blob";
import { requireAdmin } from "@/lib/server-auth";

const MAX_BYTES = 4 * 1024 * 1024; // Vercel 함수 요청 본문 제한(약 4.5MB) 안쪽
const ALLOWED = new Set(["image/png", "image/jpeg", "image/webp", "image/gif"]);

/** 디지몬 이미지 업로드 (관리자 전용) → Vercel Blob 공개 URL 반환 */
export async function POST(request: Request) {
  const { user, error } = await requireAdmin();
  if (!user) return error;

  const form = await request.formData().catch(() => null);
  const file = form?.get("file");
  if (!(file instanceof File)) return Response.json({ error: "no file" }, { status: 400 });
  if (!ALLOWED.has(file.type)) return Response.json({ error: "unsupported type" }, { status: 400 });
  if (file.size > MAX_BYTES) return Response.json({ error: "too large" }, { status: 413 });

  const ext = file.type.split("/")[1] ?? "png";
  const blob = await put(`catalog/${crypto.randomUUID()}.${ext}`, file, { access: "public" });
  return Response.json({ url: blob.url });
}
