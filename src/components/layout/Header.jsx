import { useEffect, useMemo, useState } from "react";
import { Link } from "react-router-dom";
import { fetchMenu } from "../../api/menu";
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
  const [menuItems, setMenuItems] = useState(menuSeed);

  useEffect(() => {
    let mounted = true;

    fetchMenu({ business: "Ireland", website: "Syntec Scientific" }).then((items) => {
      if (mounted && Array.isArray(items) && items.length > 0) {
        setMenuItems(items);
      }
    });

    return () => {
      mounted = false;
    };
  }, []);

  const rootItems = useMemo(
    () => menuItems.filter((i) => i.parentId == null),
    [menuItems]
  );

  return (
    <header className="sticky top-0 z-30 border-b border-slate-200 bg-white/95 backdrop-blur">
      <div className="mx-auto flex max-w-7xl items-center justify-between px-4 py-3">
        <Link to="/" className="flex items-center gap-3">
          <img src="/assets/images/Syntec_Group_Logo_Small.png" alt="Syntec" className="h-10 w-auto" />
          <span className="text-sm font-semibold text-[var(--syntec-navy)]">Syntec</span>
        </Link>

        <div className="hidden lg:block" />

        <button
          type="button"
          className="rounded-md border border-slate-300 px-3 py-2 text-xs font-semibold text-slate-700 lg:hidden"
          onClick={() => setMobileOpen((prev) => !prev)}
        >
          Menu
        </button>
      </div>

      <MegaMenu items={rootItems} />
      <MobileMenu isOpen={mobileOpen} onClose={() => setMobileOpen(false)} items={menuItems} />
    </header>
  );
}
