import { useEffect, useMemo, useState } from "react";
import { useSearchParams } from "react-router-dom";
import { fetchMenu } from "../api/menu";

const APEX_PAGE_NAMES = {
  "0": "Global Page",
  "1": "Syntec Group",
  "2": "SyS Laboratories Covid",
  "3": "Syntec Group Contact Us",
  "4": "Syntec Scientific Suppliers",
  "6": "SyS Laboratories Main",
  "7": "Syntec International Surgery",
  "9": "SyS Laboratories Sports Performance",
  "10": "Syntec Scientific Main",
  "11": "SyS Laboratories Regenerative Sports",
  "12": "SyS Laboratories - Biological Innovations",
  "13": "SyS Laboratories - EKF",
  "14": "SyS Laboratories Elite Sports Recovery",
  "15": "SyS Laboratories - Biobarica",
  "16": "Product Portfolio",
  "17": "SyS Laboratories - Qilta",
  "18": "SyS Laboratories - CTN",
  "20": "Syntec International Main",
  "21": "Syntec International Cytometry",
  "22": "Product Portfolio (Old Facet)",
  "25": "Syntec International Homogenization",
  "31": "Antibodies",
  "404": "Page Not Found",
  "414": "Login Page",
};

function parseApexPage(urlValue) {
  const raw = String(urlValue || "").trim();
  if (!raw) return "(none)";
  const match = raw.match(/f\?p=[^:]*:([^:]+)/i);
  return match?.[1] || raw;
}

function flattenMenu(items, parentChain = []) {
  return items.flatMap((item) => {
    const chain = [...parentChain, item];
    return [chain, ...flattenMenu(item.children || [], chain)];
  });
}

function chainLabel(node) {
  const level = String(node?.menuLevel || "").toUpperCase();
  if (level === "L0" || !level) {
    return {
      id: node?.menuId || "(none)",
      name: node?.menuName || node?.title || "(none)",
      level: "L0",
    };
  }
  return {
    id: node?.subMenuId || node?.menuId || "(none)",
    name: node?.subMenuName || node?.title || "(none)",
    level,
  };
}

export default function MenuTargetPage() {
  const [searchParams] = useSearchParams();
  const [menuTree, setMenuTree] = useState([]);
  const [error, setError] = useState("");

  const website = searchParams.get("website") || "Syntec Scientific";
  const business = searchParams.get("business") || "Ireland";
  const itemId = Number(searchParams.get("item_id") || 0);
  const targetUrl = searchParams.get("target_url") || "";
  const apexPage = parseApexPage(targetUrl);
  const apexPageName = APEX_PAGE_NAMES[String(apexPage)] || "(unknown)";

  useEffect(() => {
    let alive = true;
    fetchMenu({ business, website })
      .then((items) => {
        if (!alive) return;
        setMenuTree(Array.isArray(items) ? items : []);
        setError("");
      })
      .catch((err) => {
        if (!alive) return;
        setError(err?.message || "Failed to load menu context.");
      });
    return () => {
      alive = false;
    };
  }, [business, website]);

  const activeChain = useMemo(() => {
    const allChains = flattenMenu(menuTree);
    return allChains.find((chain) => chain.some((node) => Number(node.id) === itemId)) || [];
  }, [menuTree, itemId]);

  const labelledChain = useMemo(() => activeChain.map(chainLabel), [activeChain]);

  return (
    <section className="flex min-h-[60vh] items-center justify-center px-6 py-12">
      <div className="w-full max-w-[820px] rounded-xl border border-slate-300 bg-white px-8 py-10 text-center shadow-sm">
        <div className="space-y-4 text-[#173a61]">
          <p className="text-sm font-bold uppercase tracking-[0.16em] text-[#2e78bc]">Temporary Menu Target</p>
          <p className="text-2xl font-black">Apex page: {apexPage}</p>
          <p className="text-xl font-semibold">Apex page name: {apexPageName}</p>
          <p className="text-lg font-semibold">Website: {website}</p>
          <p className="text-lg font-semibold">Business: {business}</p>
          {labelledChain.map((entry) => (
            <p key={`${entry.level}-${entry.id}`} className="text-lg font-semibold">
              {entry.level} Menu ID: {entry.id} | {entry.level} Menu Name: {entry.name}
            </p>
          ))}
          {targetUrl ? <p className="text-sm text-slate-600">URL: {targetUrl}</p> : null}
          {error ? <p className="text-sm text-rose-700">{error}</p> : null}
        </div>
      </div>
    </section>
  );
}
