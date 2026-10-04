# 디지몬 덱 아카이브

덱 목록·구성·효과를 한눈에 보고, 구글 로그인 후 내 보유 디지몬을 체크해 덱 완성도를 확인하는 웹사이트.
**Vercel 단독 구성**: Next.js + Neon(Postgres, Vercel Storage) + Auth.js(구글 로그인) + Vercel Blob(이미지 업로드).

## 구조

- 덱/디지몬 카탈로그: 모두에게 공통, 로그인 없이 조회. 수정은 관리자(`ADMIN_EMAIL`)만 (서버 API가 검사)
- 보유 여부·즐겨찾기: 로그인한 구글 계정별로 저장 (서버가 항상 로그인한 본인 ID로만 기록)
- 실시간 동기화는 없고, 탭으로 돌아올 때 최신 데이터로 갱신

## 배포 순서

1. **GitHub**에 저장소 생성 후 push
2. **Vercel** → Add New Project → 저장소 선택 → Deploy (처음엔 DB가 없어 화면이 비어도 정상)
3. Vercel 프로젝트 → **Storage** → Neon(Postgres) 만들기 → 프로젝트에 연결 (`DATABASE_URL` 자동 등록)
   - 같은 곳에서 **Blob** 스토어도 만들어 연결 (`BLOB_READ_WRITE_TOKEN` 자동 등록, 이미지 업로드용)
4. Neon **SQL Editor**에서 순서대로 실행
   `db/schema.sql` → `supabase/seed_decks.sql` → `update_deck_details.sql` → `update_image_urls.sql` → `update_u_grade.sql` → `rename_decks.sql` → `update_deck_order.sql`
   (`supabase/` 폴더의 시드 파일은 일반 Postgres SQL이라 그대로 사용 가능)
5. **Google Cloud** → 사용자 인증 정보 → OAuth 클라이언트 ID(웹 애플리케이션)
   - 승인된 리디렉션 URI: `https://<내 도메인>/api/auth/callback/google` (로컬: `http://localhost:3000/api/auth/callback/google`)
6. Vercel → Settings → Environment Variables 추가
   - `AUTH_SECRET` (임의의 긴 문자열), `AUTH_GOOGLE_ID`, `AUTH_GOOGLE_SECRET`, `ADMIN_EMAIL`
7. Redeploy

## 로컬 실행

```bash
npm install
cp .env.example .env.local   # 값 채우기
npm run dev
```
