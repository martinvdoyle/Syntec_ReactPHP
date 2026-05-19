import { useMemo, useState } from "react";
import { Link } from "react-router-dom";
import MegaMenu from "../menus/MegaMenu";
import MobileMenu from "../menus/MobileMenu";

const menuSeed = [
  { id: 1, title: "Home", route: "/", menuType: "standard" },
  { id: 2, title: "Suppliers", route: "/suppliers", menuType: "mega" },
  { id: 3, title: "Products", route: "/products", menuType: "mega" },
  { id: 4, title: "Contact", route: "/contact", menuType: "standard" },
];

export default function Header() {
  const [mobileOpen, setMobileOpen] = useState(false);
  const menuItems = useMemo(() => menuSeed, []);

  return (
    <header className="sticky top-0 z-30 border-b border-slate-200 bg-white/95 backdrop-blur">
      <div className="mx-auto flex max-w-7xl items-center justify-between px-4 py-3">
        <Link to="/" className="flex items-center gap-3">
          <img src="/assets/images/Syntec_Group_Logo_Small.png" alt="Syntec" className="h-10 w-auto" />
          <span className="text-sm font-semibold text-[var(--syntec-navy)]">Syntec</span>
        </Link>

        <nav className="hidden items-center gap-6 lg:flex">
          {menuItems.map((item) => (
            <Link
              key={item.id}
              className="text-sm font-medium text-slate-700 hover:text-[var(--syntec-blue)]"
              to={item.route}
            >
              {item.title}
            </Link>
          ))}
        </nav>

        <button
          type="button"
          className="rounded-md border border-slate-300 px-3 py-2 text-xs font-semibold text-slate-700 lg:hidden"
          onClick={() => setMobileOpen((prev) => !prev)}
        >
          Menu
        </button>
      </div>

      <MegaMenu items={menuItems.filter((i) => i.menuType === "mega")} />
      <MobileMenu isOpen={mobileOpen} onClose={() => setMobileOpen(false)} items={menuItems} />
    </header>
  );
}
