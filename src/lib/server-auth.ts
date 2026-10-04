import { auth } from "@/auth";

export type SessionUser = { id: string; email: string };

/** 관리자 판별: ADMIN_EMAIL 환경변수(쉼표로 여러 개 가능)와 로그인한 구글 이메일 비교 */
export function isAdminEmail(email: string | null | undefined) {
  if (!email) return false;
  // 환경변수에 공백/따옴표가 섞여 들어가도 인식되도록 정리
  const list = (process.env.ADMIN_EMAIL ?? "")
    .split(",")
    .map((s) => s.trim().replace(/^["']+|["']+$/g, "").toLowerCase())
    .filter(Boolean);
  return list.includes(email.trim().toLowerCase());
}

export async function getSessionUser(): Promise<SessionUser | null> {
  const session = await auth();
  const id = session?.user?.id;
  const email = session?.user?.email;
  if (!id || !email) return null;
  return { id, email };
}

/** API 라우트용: 로그인 필요 */
export async function requireUser() {
  const user = await getSessionUser();
  if (!user) return { user: null, error: Response.json({ error: "login required" }, { status: 401 }) };
  return { user, error: null };
}

/** API 라우트용: 관리자 필요 */
export async function requireAdmin() {
  const { user, error } = await requireUser();
  if (!user) return { user: null, error };
  if (!isAdminEmail(user.email)) {
    return { user: null, error: Response.json({ error: "admin only" }, { status: 403 }) };
  }
  return { user, error: null };
}

const UUID_RE = /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i;
export const isUuid = (v: unknown): v is string => typeof v === "string" && UUID_RE.test(v);
