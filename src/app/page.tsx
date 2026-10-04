import { auth } from "@/auth";
import { isAdminEmail } from "@/lib/server-auth";
import DeckApp from "@/components/DeckApp";

export default async function HomePage() {
  const session = await auth();
  const user = session?.user;

  return (
    <DeckApp
      userId={user?.id ?? null}
      userName={user?.name ?? ""}
      userEmail={user?.email ?? ""}
      userAvatarUrl={user?.image ?? null}
      isAdmin={isAdminEmail(user?.email)}
    />
  );
}
