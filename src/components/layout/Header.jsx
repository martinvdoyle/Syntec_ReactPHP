import { useEffect, useMemo, useState } from "react";
import { Link, useNavigate } from "react-router-dom";
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
  const navigate = useNavigate();
  const [mobileOpen, setMobileOpen] = useState(false);
  const [menuItems, setMenuItems] = useState(menuSeed);
  const [selectedMenuItemId, setSelectedMenuItemId] = useState(() => Number(localStorage.getItem("syntec_selected_menu_item_id") || 0) || null);
  const [isSticky, setIsSticky] = useState(false);
  const [languageOptions, setLanguageOptions] = useState([]);
  const [lang, setLang] = useState(() => localStorage.getItem("syntec_lang") || "en");
  const [menuContext, setMenuContext] = useState(() => localStorage.getItem("syntec_menu_context") || "Ireland");
  const [langOpen, setLangOpen] = useState(false);

  const contextToParams = (ctx) => {
    if (ctx === "Group") return { business: "Ireland", website: "Syntec Group" };
    if (ctx === "International") return { business: "International", website: "Syntec International" };
    return { business: "Ireland", website: "Syntec Scientific" };
  };

  const loadMenu = (ctx) => {
    const params = contextToParams(ctx);
    fetchMenu(params).then((items) => {
      if (Array.isArray(items) && items.length > 0) setMenuItems(items);
    });
  };

  useEffect(() => {
    loadMenu(menuContext);
    // eslint-disable-next-line react-hooks/exhaustive-deps
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
        const savedLang = localStorage.getItem("syntec_lang");
        const nextLang = opts.some((opt) => opt.code === savedLang) ? savedLang : opts[0]?.code || "en";
        setLang(nextLang);
        localStorage.setItem("syntec_lang", nextLang);
      })
      .catch(() => {
        setLanguageOptions([{ code: "en", label: "English", flag: "/assets/images/flags/gb.svg" }]);
        setLang("en");
        localStorage.setItem("syntec_lang", "en");
      });
  }, []);

  useEffect(() => {
    const onScroll = () => {
      const y = window.scrollY || 0;
      setIsSticky((prev) => {
        if (!prev && y > 80) return true;
        if (prev && y < 20) return false;
        return prev;
      });
    };
    onScroll();
    window.addEventListener("scroll", onScroll, { passive: true });
    return () => window.removeEventListener("scroll", onScroll);
  }, []);

  const rootItems = useMemo(() => {
    const l0 = menuItems.filter((i) => (i.menuLevel || "") === "L0");
    return l0.length ? l0 : menuItems.filter((i) => i.parentId == null);
  }, [menuItems]);
  const menuContextOptions = ["Group", "Ireland", "International"];
  const contextLogo = useMemo(() => {
    if (menuContext === "Group") return "/assets/images/Logos/Syntec_Group_Logo_Menu.png";
    if (menuContext === "International") return "/assets/images/Logos/Syntec_International_Logo_Menu.png";
    if (menuContext === "Ireland") return "/assets/images/Logos/Syntec_Scientific_Logo_Menu.png";
    return "/assets/images/Logos/Syntec_Group_Logo_Menu.png";
  }, [menuContext]);

  useEffect(() => {
    const onDocClick = () => setLangOpen(false);
    if (langOpen) document.addEventListener("click", onDocClick);
    return () => document.removeEventListener("click", onDocClick);
  }, [langOpen]);

  const handleMenuClick = (item, e) => {
    const rawWebsiteSet = String(item?.websiteSet || "").trim();
    const rawBusinessSet = String(item?.businessSet || "").trim();
    const rawWebsite = String(item?.website || "").trim();
    const rawBusiness = String(item?.business || "").trim();
    const title = String(item?.title || "").trim();

    let website = rawWebsiteSet || rawWebsite;
    let business = rawBusinessSet || rawBusiness;

    if (!rawWebsiteSet && rawWebsite === "Syntec Group") {
      if (title === "Syntec Scientific" || title === "SyS Laboratories") {
        website = "Syntec Scientific";
        business = "Ireland";
      } else if (title === "Syntec International") {
        website = "Syntec International";
        business = "International";
      } else if (title === "Syntec Group") {
        website = "Syntec Group";
        business = "Ireland";
      }
    }

    let nextContext = "Ireland";
    if (website === "Syntec Group") nextContext = "Group";
    else if (website === "Syntec International" || business === "International") nextContext = "International";
    else nextContext = "Ireland";

    e?.preventDefault?.();
    setSelectedMenuItemId(item?.id ? Number(item.id) : null);
    localStorage.setItem("syntec_selected_menu_item_id", String(item?.id || ""));
    setMenuContext(nextContext);
    localStorage.setItem("syntec_menu_context", nextContext);
    loadMenu(nextContext);

    const params = new URLSearchParams({
      item_id: String(item?.id || ""),
      website: website || "Syntec Scientific",
      business: business || "Ireland",
      target_url: String(item?.url || ""),
    });
    navigate(`/menu-target?${params.toString()}`);
  };

  return (
    <header className="sticky top-0 z-[80] border-b border-slate-200 bg-white shadow-sm">
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

      <div className="syn-bnav relative w-full border-t border-slate-200 px-4 py-0">
        <div className="mx-auto max-w-[1240px]">
            <div className="syn-bnav-row grid h-[74px] grid-cols-1 items-stretch gap-0 lg:grid-cols-[180px_minmax(0,1fr)_170px]">
            <div className="syn-bnav-logo justify-self-start lg:w-[180px]">
              <Link to="/" className="relative z-50 inline-flex h-full items-center pl-2 pr-2">
                <img src={contextLogo} alt="Syntec" className="h-full w-auto" />
              </Link>
            </div>

            <div className="relative z-50 hidden min-w-0 lg:block">
              <div className="mx-auto w-full">
                <MegaMenu items={rootItems} onMenuClick={handleMenuClick} selectedItemId={selectedMenuItemId} />
              </div>
            </div>

            <div className="syn-bnav-lang z-[70] flex items-center justify-end gap-2 lg:w-[170px]">
              <div className="hidden items-center gap-2 whitespace-nowrap text-sm text-slate-600 lg:flex">
                <select
                  className="w-[138px] cursor-pointer rounded border border-slate-300 bg-white px-2 py-1 text-sm text-slate-700"
                  value={menuContext}
                  onChange={(e) => {
                    const next = e.target.value;
                    setMenuContext(next);
                    localStorage.setItem("syntec_menu_context", next);
                    loadMenu(next);
                  }}
                >
                  {menuContextOptions.map((w) => (
                    <option key={w} value={w}>{w}</option>
                  ))}
                </select>
                <div className="relative">
                  <button
                    type="button"
                    className="inline-flex h-7 w-7 items-center justify-center rounded-full border border-slate-300 bg-white"
                    onClick={(e) => {
                      e.stopPropagation();
                      setLangOpen((v) => !v);
                    }}
                  >
                    <img
                      src={languageOptions.find((x) => x.code === lang)?.flag || "/assets/images/flags/gb.svg"}
                      alt={lang}
                      className="h-5 w-5 rounded-full object-cover"
                    />
                  </button>
                  {langOpen ? (
                    <div
                      className="absolute left-[calc(100%+8px)] top-0 z-[120] min-w-[170px] rounded-md border border-slate-200 bg-white py-2 shadow-lg"
                      onClick={(e) => e.stopPropagation()}
                    >
                      {languageOptions.map((opt) => (
                        <button
                          key={opt.code}
                          type="button"
                          className={`flex w-full items-center gap-2 px-3 py-2 text-left text-sm ${opt.code === lang ? "bg-slate-100 font-semibold text-slate-900" : "text-slate-700 hover:bg-slate-50"}`}
                          onClick={() => {
                            setLang(opt.code);
                            localStorage.setItem("syntec_lang", opt.code);
                            window.dispatchEvent(new CustomEvent("syntec-language-change", { detail: opt.code }));
                            setLangOpen(false);
                          }}
                        >
                          <img src={opt.flag || "/assets/images/flags/gb.svg"} alt={opt.code} className="h-5 w-5 rounded-full object-cover" />
                          <span>{opt.label}</span>
                        </button>
                      ))}
                    </div>
                  ) : null}
                </div>
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
      <MobileMenu isOpen={mobileOpen} onClose={() => setMobileOpen(false)} onMenuClick={handleMenuClick} items={menuItems} />
    </header>
  );
}
