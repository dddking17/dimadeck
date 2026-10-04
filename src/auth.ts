import NextAuth from "next-auth";
import Google from "next-auth/providers/google";

/**
 * 구글 로그인 (Auth.js). 세션은 DB 없이 암호화된 쿠키(JWT)로 유지합니다.
 * 필요한 환경변수: AUTH_SECRET, AUTH_GOOGLE_ID, AUTH_GOOGLE_SECRET
 * 사용자 식별자(user.id)는 구글 계정 고유 ID(sub)입니다.
 */
export const { handlers, auth, signIn, signOut } = NextAuth({
  // 구글 계정이 여러 개여도 항상 계정 선택 창을 보여줘서, 관리자 계정으로 정확히 로그인하게 함
  providers: [Google({ authorization: { params: { prompt: "select_account" } } })],
  session: { strategy: "jwt" },
  trustHost: true,
  pages: { error: "/auth/error" },
  callbacks: {
    signIn({ profile }) {
      // 이메일이 확인된 구글 계정만 허용
      return profile?.email_verified !== false;
    },
    session({ session, token }) {
      if (token.sub) session.user.id = token.sub;
      return session;
    },
  },
});
