import { Outlet } from "react-router-dom";
import Header from "./Header";
import Footer from "./Footer";

export default function Layout() {
  return (
    <div className="min-h-screen bg-[#dfe6ec]">
      <Header />
      <main className="mx-auto w-full max-w-[1240px] px-4 py-6">
        <Outlet />
      </main>
      <Footer />
    </div>
  );
}
