import type { Deck, Digimon, Tier } from "./types";

/**
 * 서버 API(/api/*)를 호출하는 헬퍼.
 * 카탈로그(digimons/decks)는 모두에게 공통이며, 추가/수정/삭제는 서버가 관리자 계정인지
 * 확인한 뒤에만 처리합니다. 보유 여부·즐겨찾기는 서버가 로그인한 본인 계정으로만 저장합니다.
 */

async function request<T>(url: string, init?: RequestInit): Promise<T> {
  const res = await fetch(url, { cache: "no-store", ...init });
  if (!res.ok) throw new Error(`${init?.method ?? "GET"} ${url} → ${res.status}`);
  return (await res.json()) as T;
}

const json = (method: string, body: unknown): RequestInit => ({
  method,
  headers: { "Content-Type": "application/json" },
  body: JSON.stringify(body),
});

export function fetchCatalog() {
  return request<{ digimons: Digimon[]; decks: Deck[] }>("/api/catalog");
}

/** 로그인한 사용자의 보유 여부(digimon_id -> owned)와 즐겨찾기 덱 id 목록 */
export function fetchMe() {
  return request<{ ownership: Record<string, boolean>; favorites: string[] }>("/api/me");
}

export async function setDigimonOwned(digimonId: string, owned: boolean) {
  await request("/api/ownership", json("PUT", { digimonId, owned }));
}

export async function setDeckFavorite(deckId: string, favorited: boolean) {
  await request("/api/favorites", json("PUT", { deckId, favorited }));
}

/** 카탈로그 등록/수정 — 관리자만 성공합니다 */
export function upsertDigimon(digimon: { id?: string; name: string; image_url?: string | null; is_u_grade?: boolean }) {
  return request<Digimon>("/api/admin/digimons", json("POST", digimon));
}

/** 디지몬 이미지를 업로드하고 공개 URL을 반환 (관리자만 성공) */
export async function uploadDigimonImage(file: File) {
  const form = new FormData();
  form.append("file", file);
  const { url } = await request<{ url: string }>("/api/admin/upload", { method: "POST", body: form });
  return url;
}

/** 디지몬 삭제 — 서버가 모든 덱의 구성원에서도 함께 제거합니다 */
export async function deleteDigimon(id: string) {
  await request(`/api/admin/digimons?id=${encodeURIComponent(id)}`, { method: "DELETE" });
}

export function upsertDeck(deck: {
  id?: string;
  name: string;
  tier: Tier;
  description: string;
  effect: string;
  member_ids: string[];
}) {
  return request<Deck>("/api/admin/decks", json("POST", deck));
}

export async function deleteDeck(id: string) {
  await request(`/api/admin/decks?id=${encodeURIComponent(id)}`, { method: "DELETE" });
}
