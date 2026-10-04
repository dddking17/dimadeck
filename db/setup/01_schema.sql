-- 디지몬 덱 아카이브 — Neon(Postgres) 스키마 (Vercel 단독 구성)
-- Vercel 대시보드 → Storage → Neon 연결 → "Open in Neon" → SQL Editor 에 전체 붙여넣고 실행하세요.
--
-- 구조: digimons / decks 는 모두에게 공통인 "카탈로그"이고, 수정은 서버(API)가
-- 관리자 이메일(ADMIN_EMAIL)인지 확인한 뒤에만 처리합니다.
-- 사용자별 데이터(보유 여부, 즐겨찾기)는 구글 계정 고유 ID(text)로 구분합니다.
-- 여러 번 실행해도 안전합니다.


create table if not exists public.digimons (
  id uuid primary key default gen_random_uuid(),
  name text not null check (char_length(trim(name)) > 0),
  image_url text,
  is_u_grade boolean not null default false,
  created_at timestamptz not null default now()
);

create table if not exists public.decks (
  id uuid primary key default gen_random_uuid(),
  name text not null check (char_length(trim(name)) > 0),
  tier text not null default 'A' check (tier in ('S', 'A', 'B', 'C', 'D')),
  description text not null default '',
  effect text not null default '',
  member_ids uuid[] not null default '{}',
  order_index integer not null default 0,
  created_at timestamptz not null default now()
);

create table if not exists public.user_digimon_ownership (
  user_id text not null,
  digimon_id uuid not null references public.digimons(id) on delete cascade,
  owned boolean not null default true,
  updated_at timestamptz not null default now(),
  primary key (user_id, digimon_id)
);

create table if not exists public.user_deck_favorites (
  user_id text not null,
  deck_id uuid not null references public.decks(id) on delete cascade,
  created_at timestamptz not null default now(),
  primary key (user_id, deck_id)
);

create index if not exists decks_name_idx on public.decks(name);
create index if not exists ownership_user_idx on public.user_digimon_ownership(user_id);
create index if not exists favorites_user_idx on public.user_deck_favorites(user_id);
