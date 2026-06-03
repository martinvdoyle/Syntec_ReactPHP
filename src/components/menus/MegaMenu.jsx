import { useEffect, useMemo, useRef, useState } from "react";
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

function normalizeIconClass(iconClass) {
  const raw = (iconClass || "").toLowerCase().trim();
  if (!raw) return "";
  if (raw.includes(":")) return raw;

  const legacyMap = [
    ["fa-syringe", "lucide:syringe"],
  ];
  return legacyMap.find(([legacy]) => raw.includes(legacy))?.[1] || raw;
}

function IconMark({ iconClass, className = "" }) {
  const raw = normalizeIconClass(iconClass);
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

function findItemPath(items, targetId, parentPath = []) {
  for (const item of items) {
    const nextPath = [...parentPath, item];
    if (item.id === targetId) return nextPath;
    const childPath = findItemPath(item.children || [], targetId, nextPath);
    if (childPath.length) return childPath;
  }
  return [];
}

function CascadeCol({ items, onHover, activeId, selectedId, onMenuClick }) {
  return (
    <ul className="min-w-[230px] border border-slate-200 bg-[#f3f5f7] shadow-lg">
      {items.map((it) => {
        const hasChildren = !!it.children?.length;
        const active = activeId === it.id;
        const selected = selectedId === it.id;
        return (
          <li
            key={it.id}
            onMouseEnter={() => onHover(it)}
            className={`border-b border-slate-200 last:border-b-0 ${(active || selected) ? "bg-white" : ""}`}
          >
            <Link
              to={it.url || "#"}
              onClick={(e) => onMenuClick?.(it, e)}
              className={`flex items-center justify-between px-4 py-3 text-[15px] font-semibold tracking-[0.005em] ${(active || selected) ? "text-[var(--syntec-blue)]" : "text-slate-700"}`}
            >
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

function StandardCascade({ items = [], onClose, onMenuClick, selectedIds = {} }) {
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
      <div className="absolute left-0 top-0 h-[2px] w-full overflow-hidden">
        <div className="h-full w-full bg-lime-500" />
      </div>
      <ul className="min-w-[260px] self-start border border-slate-200 bg-[#f3f5f7] text-slate-700 shadow-lg">
        {items.map((c) => (
          <li
            key={c.id}
            className={`border-b border-slate-200 last:border-b-0 ${selectedIds.L1 === c.id ? "bg-white" : ""}`}
            onMouseEnter={(e) => {
              setL1Id(c.id);
              setL2Id(null);
              setL1Top(e.currentTarget.offsetTop);
              setL3Top(0);
            }}
          >
            <Link
              to={c.url || "#"}
              onClick={(e) => onMenuClick?.(c, e)}
              className={`flex items-center justify-between px-4 py-3 text-[15px] font-semibold tracking-[0.005em] hover:bg-white ${selectedIds.L1 === c.id ? "text-[var(--syntec-blue)]" : "text-slate-700"}`}
            >
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
              className={`border-b border-slate-200 last:border-b-0 ${selectedIds.L2 === c.id ? "bg-white" : ""}`}
              onMouseEnter={(e) => {
                setL2Id(c.id);
                const wrapTop = wrapRef.current?.getBoundingClientRect().top ?? 0;
                const rowTop = e.currentTarget.getBoundingClientRect().top;
                setL3Top(Math.max(0, rowTop - wrapTop));
              }}
            >
              <Link
                to={c.url || "#"}
                onClick={(e) => onMenuClick?.(c, e)}
                className={`flex items-center justify-between px-4 py-3 text-[15px] font-semibold tracking-[0.005em] hover:bg-white ${selectedIds.L2 === c.id ? "text-[var(--syntec-blue)]" : "text-slate-700"}`}
              >
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
            <li key={c.id} className={`border-b border-slate-200 last:border-b-0 ${selectedIds.L3 === c.id ? "bg-white" : ""}`}>
              <Link
                to={c.url || "#"}
                onClick={(e) => onMenuClick?.(c, e)}
                className={`flex items-center gap-2 px-4 py-3 text-[15px] font-semibold tracking-[0.005em] hover:bg-white ${selectedIds.L3 === c.id ? "text-[var(--syntec-blue)]" : "text-slate-700"}`}
              >
                <span className="inline-flex w-5 shrink-0 justify-center">
                  <IconMark iconClass={c.iconClass} className="h-4 w-4 text-[var(--syntec-blue)]" />
                </span>
                <span>{c.title}</span>
              </Link>
            </li>
          ))}
        </ul>
      ) : null}
      <div className="absolute left-0 top-0 h-[2px] w-full overflow-hidden">
        <div className="h-full w-full bg-lime-500" />
      </div>
    </div>
  );
}

export default function MegaMenu({ items = [], onMenuClick, selectedItemId = null }) {
  const l0Items = useMemo(() => items.filter((i) => i.menuLevel === "L0"), [items]);
  const [hoveredTabId, setHoveredTabId] = useState(null);
  const [activeL0Id, setActiveL0Id] = useState(null);
  const [activeL1Id, setActiveL1Id] = useState(null);
  const [activeL2Id, setActiveL2Id] = useState(null);
  const [activeStdId, setActiveStdId] = useState(null);
  const [selectedL0Id, setSelectedL0Id] = useState(null);
  const [selectedPathIds, setSelectedPathIds] = useState({});
  const itemRefs = useRef(new Map());

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

  const megaColumns = useMemo(() => {
    const hasTaggedGroups = [1, 2, 3, 4].some((k) => groupedCols[k].length > 0);
    if (hasTaggedGroups) {
      return [1, 2, 3, 4].filter((k) => groupedCols[k].length > 0).map((k) => groupedCols[k]);
    }

    if (!l1.length) return [];

    // Legacy-safe fallback: untagged L1 groups are columns, as used by Syntec International.
    const targetCols = Math.min(4, l1.length);
    const cols = Array.from({ length: targetCols }, () => []);
    l1.forEach((item, idx) => {
      cols[idx % targetCols].push(item);
    });
    return cols;
  }, [groupedCols, l1]);

  const blobTargetId = hoveredTabId || selectedL0Id;
  const [blobStyle, setBlobStyle] = useState({ left: 0, width: 176 });

  useEffect(() => {
    setSelectedL0Id(null);
    setSelectedPathIds({});
    setHoveredTabId(null);
  }, [items]);

  useEffect(() => {
    if (!selectedItemId) return;
    const path = findItemPath(l0Items, Number(selectedItemId));
    if (!path.length) return;

    const nextSelected = {};
    path.forEach((node, index) => {
      nextSelected[`L${index}`] = node.id;
    });

    setSelectedPathIds(nextSelected);
    setSelectedL0Id(path[0]?.id ?? null);
    setActiveL0Id(path[0] && isMega(path[0]) ? path[0].id : null);
    setActiveStdId(path[0] && !isMega(path[0]) ? path[0].id : null);
    setActiveL1Id(path[1]?.id ?? null);
    setActiveL2Id(path[2]?.id ?? null);
  }, [selectedItemId, l0Items]);

  useEffect(() => {
    if (!blobTargetId) return;
    const node = itemRefs.current.get(blobTargetId);
    if (!node) return;
    setBlobStyle({ left: node.offsetLeft, width: node.offsetWidth });
  }, [blobTargetId, l0Items]);

  if (!l0Items.length) return null;

  const handleItemClick = (item, e) => {
    const path = findItemPath(l0Items, item?.id);
    if (path.length) {
      const nextSelected = {};
      path.forEach((node, index) => {
        nextSelected[`L${index}`] = node.id;
      });
      setSelectedPathIds(nextSelected);
      setSelectedL0Id(path[0]?.id ?? null);
      setActiveL0Id(path[0]?.id ?? null);
      setActiveStdId(path[0] && !isMega(path[0]) ? path[0].id : null);
      setActiveL1Id(path[1]?.id ?? null);
      setActiveL2Id(path[2]?.id ?? null);
    } else if (item?.id) {
      setSelectedL0Id(item.id);
      setSelectedPathIds({ L0: item.id });
    }
    setHoveredTabId(null);
    onMenuClick?.(item, e);
  };

  return (
    <div className="mega-concept-b relative hidden h-[78px] bg-transparent lg:block">
      <div className="h-full w-full">
        <div className="mega-concept-b-rail relative h-full bg-white px-[6px]">
          {blobTargetId ? (
            <span
              className="mega-concept-b-blob pointer-events-none absolute top-[6px] z-[1] h-[62px] rounded-[34px] bg-[var(--syntec-blue)] shadow-[0_10px_20px_rgba(36,96,167,0.24)] transition-opacity duration-200"
              style={{
                left: `${blobStyle.left + 10}px`,
                width: `${blobStyle.width}px`,
                opacity: hoveredTabId && hoveredTabId !== selectedL0Id ? 1 : 0,
              }}
            />
          ) : null}
          <ul
            className="relative z-[2] m-0 flex h-full list-none items-stretch justify-center gap-[8px] p-0"
            onMouseLeave={() => {
              setHoveredTabId(null);
            }}
          >
          {l0Items.map((item) => {
            const mega = isMega(item);
            const active = hoveredTabId === item.id;
            const selected = selectedL0Id === item.id;
            return (
              <li
                key={item.id}
                ref={(el) => {
                  if (el) itemRefs.current.set(item.id, el);
                  else itemRefs.current.delete(item.id);
                }}
                className={`mega-concept-b-pill relative inline-flex h-[78px] min-w-[120px] shrink-0 items-center justify-center whitespace-nowrap rounded-[36px] px-[11px] text-[16px] font-bold tracking-[0.005em] transition-colors duration-200 ${active ? "mega-concept-b-pill-hovered" : ""} ${selected ? "mega-concept-b-pill-active bg-[var(--syntec-blue)] text-white z-[3]" : "bg-transparent text-[#2b4465]"}`}
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
                onClick={() => {
                  setSelectedL0Id(item.id);
                  setHoveredTabId(null);
                }}
                style={{}}
              >
                <Link
                  to={item.url || "#"}
                  onClick={(e) => handleItemClick(item, e)}
                  className={`block whitespace-nowrap text-center leading-tight ${selected ? "text-white" : active ? "text-[var(--syntec-blue)]" : ""}`}
                >
                  {rowTitle(item)}
                </Link>
                {!mega && activeStdId === item.id && item.children?.length ? (
                  <StandardCascade items={item.children} onClose={() => setActiveStdId(null)} onMenuClick={handleItemClick} selectedIds={selectedPathIds} />
                ) : null}
              </li>
            );
          })}
          </ul>
        </div>
      </div>

      {activeL0 && isMega(activeL0) ? (
        <div
          className="absolute left-0 top-full z-40 w-full bg-transparent"
          onMouseLeave={() => {
            setActiveL0Id(null);
            setHoveredTabId(null);
          }}
        >
          <div className="w-full">
            {rowTitle(activeL0).toLowerCase() === "suppliers" ? (
              <div className="relative flex">
                <CascadeCol items={l1} activeId={activeL1Id} selectedId={selectedPathIds.L1} onHover={(it) => { setActiveL1Id(it.id); setActiveL2Id(it.children?.[0]?.id ?? null); }} onMenuClick={handleItemClick} />
                {l2.length ? <div className="ml-[1px]"><CascadeCol items={l2} activeId={activeL2Id} selectedId={selectedPathIds.L2} onHover={(it) => setActiveL2Id(it.id)} onMenuClick={handleItemClick} /></div> : null}
                {l3.length ? <div className="ml-[1px]"><CascadeCol items={l3} activeId={null} selectedId={selectedPathIds.L3} onHover={() => {}} onMenuClick={handleItemClick} /></div> : null}
                <div className="absolute -bottom-[10px] left-0 h-[10px] w-full overflow-hidden">
                  <div className="flex h-full w-full">
                    <span className="h-full w-1/3 bg-[#2f8ee5]" />
                    <span className="h-full w-1/3 bg-[#8bc53f]" />
                    <span className="h-full w-1/3 bg-[#505b66]" />
                  </div>
                </div>
              </div>
            ) : (
              <div className="relative border border-slate-200 bg-[#f3f5f7] shadow-lg">
                <div className="absolute left-0 top-0 h-[2px] w-full overflow-hidden">
                  <div className="h-full w-full bg-lime-500" />
                </div>
                <div
                  className="grid"
                  style={{ gridTemplateColumns: `repeat(${Math.max(1, megaColumns.length)}, minmax(0, 1fr))` }}
                >
                  {megaColumns.map((colGroups, colIdx) => (
                    <div key={`mega-col-${colIdx}`} className="border-r border-slate-300 p-4 last:border-r-0">
                      {colGroups.map((group) => (
                        <div key={group.id} className="mb-6">
                          <h4 className="inline-flex items-center gap-2 text-[13px] font-bold tracking-[0.01em] text-slate-600">
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
                                <Link
                                  to={it.url || "#"}
                                  onClick={(e) => handleItemClick(it, e)}
                                  className={`flex items-center gap-2 text-[15px] font-semibold tracking-[0.005em] ${selectedPathIds.L1 === it.id || selectedPathIds.L2 === it.id || selectedPathIds.L3 === it.id ? "text-[var(--syntec-blue)]" : "text-slate-700"}`}
                                >
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
                <div className="absolute -bottom-[10px] left-0 h-[10px] w-full overflow-hidden">
                  <div className="flex h-full w-full">
                    <span className="h-full w-1/3 bg-[#2f8ee5]" />
                    <span className="h-full w-1/3 bg-[#8bc53f]" />
                    <span className="h-full w-1/3 bg-[#505b66]" />
                  </div>
                </div>
              </div>
            )}
          </div>
        </div>
      ) : null}
    </div>
  );
}
