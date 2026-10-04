# 디지몬 덱 아카이브

덱 목록·구성·효과를 한눈에 보고, 구글 로그인 후 내 보유 디지몬을 체크해 덱 완성도를 확인하는 웹사이트.
**Vercel 단독 구성**: Next.js + Neon(Postgres, Vercel Storage) + Auth.js(구글 로그인) + Vercel Blob(이미지 업로드).

- 덱/디지몬 카탈로그: 모두에게 공통, 로그인 없이 조회. 수정은 관리자(`ADMIN_EMAIL`)만 가능 (서버가 검사)
- 보유 여부·즐겨찾기: 로그인한 구글 계정별로 저장 (서버가 항상 로그인한 본인 ID로만 기록)
- 실시간 동기화는 없고, 탭으로 돌아올 때 최신 데이터로 갱신

## 최초 설정 (이 순서대로)

1. **GitHub → Vercel**: 저장소를 Vercel 프로젝트로 가져와 Deploy (Framework Preset 은 `Next.js`)
2. **Vercel → Storage**: **Neon(Postgres)** 와 **Blob(Public)** 을 만들어 프로젝트에 연결 (Production·Preview 체크)
3. **DB 초기 데이터** (한 번만): 터미널에서
   `npm run db:setup -- "<Vercel 환경변수 POSTGRES_URL 값>"`
   - 또는 Neon SQL Editor에 `db/setup/` 파일을 번호 순서대로 하나씩 붙여넣고 실행 (파일마다 5,500자 이하 — 붙여넣기 한계는 약 9,000자)
   - `db/setup/` 이 DB 초기 데이터의 유일한 원본입니다. 다시 실행하면 앱에서 직접 수정한 설명·이미지가 원래 값으로 돌아갑니다.
4. **Google Cloud** → Google Auth Platform → 클라이언트 → 웹 애플리케이션 클라이언트
   - 승인된 리디렉션 URI: `https://<내 도메인>/api/auth/callback/google` (정확히 이 형태, 끝에 `/` 없음)
   - 대상(Audience)이 **프로덕션**이어야 테스트 사용자가 아닌 계정도 로그인됩니다
5. **Vercel → Settings → Environment Variables** 에 4개 추가 후 **Redeploy** (`.env.example` 참고)
   `AUTH_SECRET`, `AUTH_GOOGLE_ID`, `AUTH_GOOGLE_SECRET`, `ADMIN_EMAIL`
6. **확인**: `https://<내 도메인>/api/health` 를 열어 `"ready": true` 이고 `problems` 가 비어 있으면 완료

## 문제 해결

| 증상 | 원인 / 해결 |
|---|---|
| `/api/health` 의 `problems` | 적힌 항목 그대로 조치 (환경변수 수정 후엔 반드시 Redeploy) |
| 구글 화면 `redirect_uri_mismatch` | 4번의 리디렉션 URI 오타 또는 미등록 |
| `액세스 차단됨 / 승인된 테스터만` | 대상(Audience)이 "테스트 중" → 앱 게시, 또는 테스트 사용자 추가 |
| 로그인은 되는데 관리자 버튼이 없음 | `ADMIN_EMAIL` 과 다른 구글 계정으로 로그인함 (계정 선택 창에서 확인) |
| `/api/auth/*` 가 500 | `AUTH_SECRET` 누락 |
| 이미지 업로드만 실패 | Blob 연결 확인 (스토어 Access 는 Public) |

## 로컬 실행

```bash
npm install
cp .env.example .env.local   # 값 채우기
npm run dev
```
