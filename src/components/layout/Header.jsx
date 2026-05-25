import { useEffect, useMemo, useState } from "react";
import { Link } from "react-router-dom";
import { fetchMenu } from "../../api/menu";
import { fetchLanguages } from "../../api/languagesAdmin";
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
  const [isSticky, setIsSticky] = useState(false);
  const [languageOptions, setLanguageOptions] = useState([]);
  const [lang, setLang] = useState("en");

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

  useEffect(() => {
    fetchLanguages()
      .then((r) => {
        const opts = (r?.items || [])
          .filter((x) => String(x.is_active || "Y").toUpperCase() === "Y")
          .map((x) => ({
            code: String(x.lang_code),
            label: String(x.lang_name || x.lang_code),
            flag: x.flag_path || "/assets/images/flags/gb.svg",
          }));
        setLanguageOptions(opts);
        if (opts.length) setLang(opts[0].code);
      })
      .catch(() => {
        setLanguageOptions([{ code: "en", label: "English", flag: "/assets/images/flags/gb.svg" }]);
        setLang("en");
      });
  }, []);

  useEffect(() => {
    const onScroll = () => setIsSticky(window.scrollY > 10);
    onScroll();
    window.addEventListener("scroll", onScroll, { passive: true });
    return () => window.removeEventListener("scroll", onScroll);
  }, []);

  const rootItems = useMemo(
    () => menuItems.filter((i) => i.parentId == null),
    [menuItems]
  );

  return (
    <header className="sticky top-0 z-40 border-b border-slate-200 bg-white shadow-sm">
      <div className={`${isSticky ? "hidden" : "block"} bg-[#c6def4] text-[10px] uppercase tracking-wide text-[#2f4b67]`}>
        <div className="mx-auto flex max-w-[1240px] items-center justify-between px-4 py-1.5">
          <div className="hidden gap-5 md:flex">
            <span>info@syntec.ie</span>
            <span>+353 1 8612100</span>
            <span>ISO Certificates</span>
            <span>Site Map</span>
          </div>
          <div className="hidden md:flex items-center gap-3">
            <span>Ireland</span>
            <img src="/assets/images/flags/gb.svg" alt="English" className="h-3.5 w-5 rounded-sm border border-[#9ab5cd]" />
          </div>
        </div>
      </div>

      <div className="relative w-full px-4 py-3.5 border-t border-slate-200">
        <div className="mx-auto max-w-[1240px]">
          <div className="relative h-[58px]">
        <div className="absolute left-0 top-1/2 -translate-y-1/2">
          <Link to="/" className="inline-block">
            <img src="/assets/images/Syntec_Group_Logo_Small.png" alt="Syntec" className="h-14 w-auto" />
          </Link>
        </div>
        <div className="mx-auto hidden min-w-0 lg:block relative z-50">
          <div className="mx-auto w-fit">
            <MegaMenu items={rootItems} />
          </div>
        </div>
        <div className="absolute right-0 top-1/2 flex -translate-y-1/2 justify-end items-center gap-3">
          <div className="hidden lg:flex items-center gap-2 text-sm text-slate-600 whitespace-nowrap">
            <select
              className="w-[92px] rounded border border-slate-300 bg-white px-2 py-1 text-sm text-slate-700"
              value={lang}
              onChange={(e) => setLang(e.target.value)}
            >
              {languageOptions.map((opt) => (
                <option key={opt.code} value={opt.code}>
                  {opt.label}
                </option>
              ))}
            </select>
            <img
              src={languageOptions.find((x) => x.code === lang)?.flag || "/assets/images/flags/gb.svg"}
              alt={lang}
              className="h-4 w-6 rounded-sm border border-slate-300"
            />
          </div>
          <button
            type="button"
            className="rounded-md border border-slate-300 px-3 py-2 text-xs font-semibold text-slate-700 lg:hidden"
            onClick={() => setMobileOpen((prev) => !prev)}
          >
            Menu
          </button>
        </div>
          </div>
        </div>
      </div>
      <MobileMenu isOpen={mobileOpen} onClose={() => setMobileOpen(false)} items={menuItems} />
    </header>
  );
}
