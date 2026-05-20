import { useMemo, useRef, useState } from "react";
import { Link } from "react-router-dom";
import * as LucideIcons from "lucide-react";
import * as TablerIcons from "@tabler/icons-react";

function isMega(item) {
  return (item?.cssClass || "").includes("mega-menu");
}

function rowTitle(item) {
  return item?.title || "";
}

function kebabToPascal(name) {
  return name
    .split("-")
    .filter(Boolean)
    .map((part) => part.charAt(0).toUpperCase() + part.slice(1))
    .join("");
}

function IconMark({ iconClass, className = "" }) {
  const raw = (iconClass || "").toLowerCase().trim();
  if (!raw) {
    return <span className={className}>•</span>;
  }

  const [library, key] = raw.includes(":") ? raw.split(":", 2) : ["", raw];

  if (library === "lucide") {
    const compName = kebabToPascal(key);
    const Comp = LucideIcons[compName];
    if (Comp) return <Comp className={className} strokeWidth={2} />;
  }

  if (library === "tabler") {
    const compName = `Icon${kebabToPascal(key)}`;
    const Comp = TablerIcons[compName];
    if (Comp) return <Comp className={className} stroke={2} />;
  }
  return <span className={className}>•</span>;
}

function groupIcon(group) {
  if (group?.iconClass) return group.iconClass;
  const firstChildWithIcon = (group?.children || []).find((x) => x.iconClass);
  return firstChildWithIcon?.iconClass || "";
}

function CascadeCol({ items, onHover, activeId }) {
  return (
    <ul className="min-w-[230px] border border-slate-200 bg-[#f3f5f7] shadow-lg">
      {items.map((it) => {
        const hasChildren = !!it.children?.length;
        const active = activeId === it.id;
        return (
          <li
            key={it.id}
            onMouseEnter={() => onHover(it)}
            className={`border-b border-slate-200 last:border-b-0 ${active ? "bg-white" : ""}`}
          >
            <Link to={it.url || "#"} className="flex items-center justify-between px-4 py-3 text-[15px] font-semibold text-slate-600">
              <span className="flex items-center gap-2">
                <IconMark iconClass={it.iconClass} className="h-4 w-4 text-[var(--syntec-blue)]" />
                {rowTitle(it)}
              </span>
              {hasChildren ? <span className="text-slate-400">{active ? "⌄" : ">"}</span> : null}
            </Link>
          </li>
        );
      })}
    </ul>
  );
}

function StandardCascade({ items = [], onClose }) {
  const [l1Id, setL1Id] = useState(null);
  const [l2Id, setL2Id] = useState(null);
  const [l1Top, setL1Top] = useState(0);
  const [l3Top, setL3Top] = useState(0);
  const wrapRef = useRef(null);
  const l1Active = items.find((x) => x.id === l1Id) || null;
  const l2Items = l1Active?.children || [];
  const l2Active = l2Items.find((x) => x.id === l2Id) || null;
  const l3Items = l2Active?.children || [];

  return (
    <div ref={wrapRef} className="absolute left-0 top-full z-50 flex items-start" onMouseLeave={onClose}>
      <ul className="min-w-[260px] self-start border border-slate-200 bg-[#f3f5f7] text-slate-700 shadow-lg">
        {items.map((c) => (
          <li
            key={c.id}
            className="border-b border-slate-200 last:border-b-0"
            onMouseEnter={(e) => {
              setL1Id(c.id);
              setL2Id(null);
              setL1Top(e.currentTarget.offsetTop);
              setL3Top(0);
            }}
          >
            <Link to={c.url || "#"} className="flex items-center justify-between px-4 py-3 text-sm font-semibold text-slate-700 hover:bg-white">
              <span className="flex items-center gap-2">
                <span className="inline-flex w-5 shrink-0 justify-center">
                  <IconMark iconClass={c.iconClass} className="h-4 w-4 text-[var(--syntec-blue)]" />
                </span>
                <span>{c.title}</span>
              </span>
              {c.children?.length ? <span className="text-slate-400">{l1Id === c.id ? "⌄" : ">"}</span> : null}
            </Link>
          </li>
        ))}
      </ul>

      {l2Items.length ? (
        <ul
          className="ml-[1px] min-w-[260px] self-start border border-slate-200 bg-[#f3f5f7] text-slate-700 shadow-lg"
          style={{ marginTop: `${l1Top}px` }}
        >
          {l2Items.map((c) => (
            <li
              key={c.id}
              className="border-b border-slate-200 last:border-b-0"
              onMouseEnter={(e) => {
                setL2Id(c.id);
                const wrapTop = wrapRef.current?.getBoundingClientRect().top ?? 0;
                const rowTop = e.currentTarget.getBoundingClientRect().top;
                setL3Top(Math.max(0, rowTop - wrapTop));
              }}
            >
              <Link to={c.url || "#"} className="flex items-center justify-between px-4 py-3 text-sm font-semibold text-slate-700 hover:bg-white">
                <span className="flex items-center gap-2">
                  <span className="inline-flex w-5 shrink-0 justify-center">
                    <IconMark iconClass={c.iconClass} className="h-4 w-4 text-[var(--syntec-blue)]" />
                  </span>
                  <span>{c.title}</span>
                </span>
                {c.children?.length ? <span className="text-slate-400">{l2Id === c.id ? "⌄" : ">"}</span> : null}
              </Link>
            </li>
          ))}
        </ul>
      ) : null}

      {l3Items.length ? (
        <ul
          className="ml-[1px] min-w-[230px] self-start border border-slate-200 bg-[#f3f5f7] text-slate-700 shadow-lg"
          style={{ marginTop: `${l3Top}px` }}
        >
          {l3Items.map((c) => (
            <li key={c.id} className="border-b border-slate-200 last:border-b-0">
              <Link to={c.url || "#"} className="flex items-center gap-2 px-4 py-3 text-sm font-semibold text-slate-700 hover:bg-white">
                <span className="inline-flex w-5 shrink-0 justify-center">
                  <IconMark iconClass={c.iconClass} className="h-4 w-4 text-[var(--syntec-blue)]" />
                </span>
                <span>{c.title}</span>
              </Link>
            </li>
          ))}
        </ul>
      ) : null}
    </div>
  );
}

export default function MegaMenu({ items = [] }) {
  const l0Items = useMemo(() => items.filter((i) => i.menuLevel === "L0"), [items]);
  const [hoveredTabId, setHoveredTabId] = useState(null);
  const [activeL0Id, setActiveL0Id] = useState(null);
  const [activeL1Id, setActiveL1Id] = useState(null);
  const [activeL2Id, setActiveL2Id] = useState(null);
  const [activeStdId, setActiveStdId] = useState(null);

  const activeL0 = l0Items.find((i) => i.id === activeL0Id) || null;
  const l1 = activeL0?.children || [];
  const l1Active = l1.find((x) => x.id === activeL1Id) || null;
  const l2 = l1Active?.children || [];
  const l2Active = l2.find((x) => x.id === activeL2Id) || null;
  const l3 = l2Active?.children || [];

  const groupedCols = useMemo(() => {
    const cols = { 1: [], 2: [], 3: [], 4: [] };
    for (const g of l1) {
      const cls = g.cssClass || "";
      const m = cls.match(/col-group-(\d)/);
      const idx = m ? Number(m[1]) : 0;
      if (idx >= 1 && idx <= 4) cols[idx].push(g);
    }
    return cols;
  }, [l1]);

  if (!l0Items.length) return null;

  return (
    <div className="relative hidden border-t border-slate-200 bg-white lg:block">
      <div className="mx-auto max-w-7xl px-3 py-2">
        <div className="flex flex-wrap gap-2">
          {l0Items.map((item) => {
            const mega = isMega(item);
            const active = hoveredTabId === item.id;
            return (
              <div
                key={item.id}
                className={`relative rounded-full border px-6 py-3 text-sm font-bold uppercase tracking-wide ${
                  active
                    ? "border-transparent bg-[var(--syntec-blue)] text-white"
                    : "border-slate-200 text-slate-600"
                }`}
                onMouseEnter={() => {
                  setHoveredTabId(item.id);
                  if (mega) {
                    setActiveL0Id(item.id);
                    setActiveStdId(null);
                    const firstL1 = item.children?.[0];
                    setActiveL1Id(firstL1?.id ?? null);
                    setActiveL2Id(firstL1?.children?.[0]?.id ?? null);
                  } else {
                    setActiveStdId(item.id);
                    setActiveL0Id(null);
                  }
                }}
              >
                <Link to={item.url || "#"}>{rowTitle(item)}</Link>
                {!mega && activeStdId === item.id && item.children?.length ? (
                  <StandardCascade items={item.children} onClose={() => setActiveStdId(null)} />
                ) : null}
              </div>
            );
          })}
        </div>
      </div>

      {activeL0 && isMega(activeL0) ? (
        <div
          className="absolute left-0 top-full z-40 w-full border-t-2 border-lime-500 bg-transparent"
          onMouseLeave={() => {
            setActiveL0Id(null);
            setHoveredTabId(null);
          }}
        >
          <div className="mx-auto max-w-7xl">
            {rowTitle(activeL0).toLowerCase() === "suppliers" ? (
              <div className="relative flex">
                <CascadeCol items={l1} activeId={activeL1Id} onHover={(it) => { setActiveL1Id(it.id); setActiveL2Id(it.children?.[0]?.id ?? null); }} />
                {l2.length ? <div className="ml-[1px]"><CascadeCol items={l2} activeId={activeL2Id} onHover={(it) => setActiveL2Id(it.id)} /></div> : null}
                {l3.length ? <div className="ml-[1px]"><CascadeCol items={l3} activeId={null} onHover={() => {}} /></div> : null}
              </div>
            ) : (
              <div className="border border-slate-200 bg-[#f3f5f7] shadow-lg">
                <div className="grid grid-cols-4">
                  {[1, 2, 3, 4].map((colNo) => (
                    <div key={colNo} className="border-r border-slate-300 p-4 last:border-r-0">
                      {groupedCols[colNo].map((group) => (
                        <div key={group.id} className="mb-6">
                          <h4 className="inline-flex items-center gap-2 text-[13px] font-bold uppercase tracking-[0.04em] text-slate-600">
                            <span className="inline-flex w-5 shrink-0 justify-center">
                              <IconMark iconClass={groupIcon(group)} className="h-[18px] w-[18px] text-[var(--syntec-blue)]" />
                            </span>
                            <span className="inline-block">
                              <span>{rowTitle(group)}</span>
                              <span className="mt-1 block h-[3px] w-full bg-lime-500" />
                            </span>
                          </h4>
                          <div className="mb-2" />
                          <ul>
                            {(group.children || []).map((it) => (
                              <li key={it.id} className="border-b border-slate-200 py-2">
                                <Link to={it.url || "#"} className="flex items-center gap-2 text-[15px] font-semibold uppercase tracking-[0.02em] text-slate-700">
                                  <span className="inline-flex w-5 shrink-0 justify-center">
                                    <IconMark iconClass={it.iconClass} className="h-[18px] w-[18px] text-[var(--syntec-blue)]" />
                                  </span>
                                  <span>{rowTitle(it)}</span>
                                </Link>
                              </li>
                            ))}
                          </ul>
                        </div>
                      ))}
                    </div>
                  ))}
                </div>
              </div>
            )}
          </div>
        </div>
      ) : null}
    </div>
  );
}
