import { useEffect, useMemo, useState } from "react";
import * as LucideIcons from "lucide-react";
import * as TablerIcons from "@tabler/icons-react";
import { createMenuItem, deleteMenuItem, fetchMenuAdmin, fetchNextMenuId, reorderMenuItem, updateMenuItem } from "../api/menuAdmin";

function kebabToPascal(name) {
  return (name || "")
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
  if (!raw) return <span className={className}>•</span>;
  const [library, key] = raw.includes(":") ? raw.split(":", 2) : ["", raw];

  if (library === "lucide") {
    const Comp = LucideIcons[kebabToPascal(key)];
    if (Comp) return <Comp className={className} strokeWidth={2} />;
  }
  if (library === "tabler") {
    const Comp = TablerIcons[`Icon${kebabToPascal(key)}`];
    if (Comp) return <Comp className={className} stroke={2} />;
  }
  return <span className={className}>•</span>;
}

function buildTree(items) {
  const byId = new Map(items.map((x) => [x.id, { ...x, children: [] }]));
  const roots = [];
  byId.forEach((node) => {
    if (node.parent_id && byId.has(node.parent_id)) byId.get(node.parent_id).children.push(node);
    else roots.push(node);
  });
  return roots;
}

function TreeNode({ node, selectedId, onSelect, onDropMove, level = 0 }) {
  const [dragOver, setDragOver] = useState(false);

  return (
    <li>
      <button
        draggable
        onDragStart={(e) => {
          e.dataTransfer.setData("text/menu-id", String(node.id));
          e.dataTransfer.effectAllowed = "move";
        }}
        onDragOver={(e) => {
          e.preventDefault();
          setDragOver(true);
        }}
        onDragLeave={() => setDragOver(false)}
        onDrop={(e) => {
          e.preventDefault();
          setDragOver(false);
          const fromId = Number(e.dataTransfer.getData("text/menu-id"));
          if (!Number.isNaN(fromId) && fromId !== node.id) onDropMove(fromId, node.id);
        }}
        className={`w-full rounded px-2 py-1 text-left text-sm ${selectedId === node.id ? "bg-blue-100 text-blue-900" : "hover:bg-slate-100"} ${dragOver ? "ring-2 ring-blue-300" : ""}`}
        onClick={() => onSelect(node)}
      >
        <span className="font-semibold">{node.menu_id}</span> - {node.sub_menu_name || node.menu_name}
      </button>
      {node.children?.length ? (
        <ul className={level === 0 ? "ml-4 mt-1 space-y-1 border-l border-slate-200 pl-3" : "ml-4 mt-1 space-y-1 border-l border-slate-200 pl-3"}>
          {node.children.map((c) => (
            <TreeNode key={c.id} node={c} selectedId={selectedId} onSelect={onSelect} onDropMove={onDropMove} level={level + 1} />
          ))}
        </ul>
      ) : null}
    </li>
  );
}

const emptyForm = {
  id: null,
  parent_menu_id: "",
  menu_id: "",
  menu_name: "",
  sub_menu_name: "",
  sub_menu_id: "",
  sub_menu_level_id: "",
  sub_menu_text: "",
  icon_class: "",
  css_class: "",
  url: "",
  url_mobile: "",
  business: "",
  business_set: "",
  website: "",
  website_set: "",
  website_anchor: "",
  enabled: "Y",
  menu_order: "",
  menu_id_order: "",
  menu_order_clone: "",
  product_type: "",
  discipline_id: "",
  product_group_id: "",
  supplier_id: "",
  product_id: "",
  oracle_parent_id: "",
};

const LEVELS = ["L0", "L1", "L2", "L3"];

export default function MenuAdminPage() {
  const [items, setItems] = useState([]);
  const [selected, setSelected] = useState(null);
  const [form, setForm] = useState(emptyForm);
  const [isNew, setIsNew] = useState(false);
  const [showDeleteConfirm, setShowDeleteConfirm] = useState(false);
  const [previewContext, setPreviewContext] = useState("Ireland");
  const [highlightMenuId, setHighlightMenuId] = useState("");

  const load = async () => {
    const data = await fetchMenuAdmin();
    setItems(data.items || []);
  };

  useEffect(() => {
    load();
  }, []);

  const tree = useMemo(() => buildTree(items), [items]);
  const topLevelPreview = useMemo(() => {
    const isInContext = (x) => {
      const w = String(x.website || "").trim();
      const b = String(x.business || "").trim();
      if (previewContext === "Group") return w === "Syntec Group";
      if (previewContext === "International") return w === "Syntec International" || b === "International";
      return b === "Ireland" || w === "Syntec Scientific" || w === "SyS Laboratories";
    };
    return items
      .filter((x) => !x.parent_id && (x.sub_menu_level_id || "L0") === "L0" && isInContext(x))
      .sort((a, b) => String(a.menu_id || "").localeCompare(String(b.menu_id || "")));
  }, [items, previewContext]);
  const usedIcons = useMemo(() => {
    const vals = Array.from(new Set(items.map((x) => (x.icon_class || "").trim()).filter(Boolean)));
    vals.sort((a, b) => a.localeCompare(b));
    return vals;
  }, [items]);

  const onSelect = (node) => {
    setIsNew(false);
    setSelected(node);
    const parent = items.find((x) => x.id === node.parent_id);
    setForm({ ...emptyForm, ...node, parent_menu_id: parent?.menu_id || "" });
    setHighlightMenuId(String(node.menu_id || ""));
  };

  const newChild = async () => {
    const parentMenuId = selected?.menu_id || "";
    const sugg = await fetchNextMenuId(parentMenuId);
    setIsNew(true);
    setForm({ ...emptyForm, parent_menu_id: parentMenuId, menu_id: sugg.nextMenuId || "", sub_menu_level_id: sugg.nextLevel || "" });
  };

  const newSibling = async () => {
    if (!selected) return;
    const parent = items.find((x) => x.id === selected.parent_id);
    const parentMenuId = parent?.menu_id || "";
    const sugg = await fetchNextMenuId(parentMenuId);
    setIsNew(true);
    setForm({
      ...emptyForm,
      parent_menu_id: parentMenuId,
      menu_id: sugg.nextMenuId || "",
      sub_menu_level_id: selected.sub_menu_level_id || sugg.nextLevel || "",
      business: selected.business || "",
      website: selected.website || "",
    });
  };

  const save = async () => {
    const payload = { ...form };
    if (isNew) await createMenuItem(payload);
    else await updateMenuItem(payload);
    await load();
  };

  const remove = async () => {
    if (!form.id) return;
    await deleteMenuItem(form.id);
    setForm(emptyForm);
    setSelected(null);
    setShowDeleteConfirm(false);
    await load();
  };

  const f = (k, v) => setForm((prev) => ({ ...prev, [k]: v }));

  const move = async (direction) => {
    if (!selected?.id) return;
    await reorderMenuItem(selected.id, direction);
    await load();
  };

  const onDropMove = async (fromId, toId) => {
    const from = items.find((x) => x.id === fromId);
    const to = items.find((x) => x.id === toId);
    if (!from || !to) return;
    if ((from.parent_id || null) !== (to.parent_id || null)) {
      alert("Drag/drop reorder is limited to siblings (same parent) for now.");
      return;
    }
    const fromOrd = Number(from.menu_order_clone ?? from.menu_order ?? from.menu_id_order ?? 0);
    const toOrd = Number(to.menu_order_clone ?? to.menu_order ?? to.menu_id_order ?? 0);
    await reorderMenuItem(fromId, fromOrd > toOrd ? "up" : "down");
    await load();
  };

  const checkYn = (key) => (
    <label className="inline-flex items-center gap-2 text-sm">
      <input type="checkbox" checked={(form[key] || "N") === "Y"} onChange={(e) => f(key, e.target.checked ? "Y" : "N")} />
      <span>{form[key] || "N"}</span>
    </label>
  );

  return (
    <main className="mx-auto max-w-[1780px] bg-slate-50 p-4">
      <h1 className="mb-1 text-3xl font-black tracking-tight text-slate-900">Admin: Menu Maintenance</h1>
      <p className="mb-4 text-sm text-slate-700">Hierarchy-first editor. Drag/drop works for sibling reorder, plus move up/down controls.</p>

      <div className="mb-4 flex flex-wrap gap-2 rounded-xl border border-[#70A9E0] bg-[#5B9BE0] p-3 shadow-sm">
        <a className="rounded-lg border border-white bg-white px-3 py-1 text-sm font-semibold text-black shadow" href="/admin/menu">Menu</a>
        <a className="rounded-lg border border-white/45 bg-[#4E8FD8] px-3 py-1 text-sm font-medium !text-white visited:!text-white transition hover:bg-[#3F82CE]" href="/admin/products">Products</a>
        <a className="rounded-lg border border-white/45 bg-[#4E8FD8] px-3 py-1 text-sm font-medium !text-white visited:!text-white transition hover:bg-[#3F82CE]" href="/admin/suppliers">Suppliers</a>
        <a className="rounded-lg border border-white/45 bg-[#4E8FD8] px-3 py-1 text-sm font-medium !text-white visited:!text-white transition hover:bg-[#3F82CE]" href="/admin/discipline">Discipline</a>
        <a className="rounded-lg border border-white/45 bg-[#4E8FD8] px-3 py-1 text-sm font-medium !text-white visited:!text-white transition hover:bg-[#3F82CE]" href="/admin/product_group">Product Group</a>
        <a className="rounded-lg border border-white/45 bg-[#4E8FD8] px-3 py-1 text-sm font-medium !text-white visited:!text-white transition hover:bg-[#3F82CE]" href="/admin/product_type">Product Type</a>
        <a className="rounded-lg border border-white/45 bg-[#4E8FD8] px-3 py-1 text-sm font-medium !text-white visited:!text-white transition hover:bg-[#3F82CE]" href="/admin/divisions">Divisions</a>
        <a className="rounded-lg border border-white/45 bg-[#4E8FD8] px-3 py-1 text-sm font-medium !text-white visited:!text-white transition hover:bg-[#3F82CE]" href="/admin/job_titles">Job Titles</a>
        <a className="rounded-lg border border-white/45 bg-[#4E8FD8] px-3 py-1 text-sm font-medium !text-white visited:!text-white transition hover:bg-[#3F82CE]" href="/admin/message_enquiry_type">Enquiry Types</a>
        <a className="rounded-lg border border-white/45 bg-[#4E8FD8] px-3 py-1 text-sm font-medium !text-white visited:!text-white transition hover:bg-[#3F82CE]" href="/admin/message_types">Message Types</a>
        <a className="rounded-lg border border-white/45 bg-[#4E8FD8] px-3 py-1 text-sm font-medium !text-white visited:!text-white transition hover:bg-[#3F82CE]" href="/admin/sources">Sources</a>
        <a className="rounded-lg border border-white/45 bg-[#4E8FD8] px-3 py-1 text-sm font-medium !text-white visited:!text-white transition hover:bg-[#3F82CE]" href="/admin/users">Users</a>
        <a className="rounded-lg border border-white/45 bg-[#4E8FD8] px-3 py-1 text-sm font-medium !text-white visited:!text-white transition hover:bg-[#3F82CE]" href="/admin/messages">Messages</a>
        <a className="rounded-lg border border-white/45 bg-[#4E8FD8] px-3 py-1 text-sm font-medium !text-white visited:!text-white transition hover:bg-[#3F82CE]" href="/admin/languages">Languages</a>
      </div>

      <section className="mb-4 rounded-xl border border-slate-200 bg-white shadow-sm">
        <div className="flex items-center justify-between border-b border-slate-200 px-4 py-3">
          <h3 className="text-sm font-bold uppercase tracking-[0.14em] text-[#2c4868]">Menu Preview</h3>
          <select className="rounded-md border border-slate-300 bg-white px-2 py-1.5 text-sm" value={previewContext} onChange={(e) => setPreviewContext(e.target.value)}>
            <option value="Group">Group</option>
            <option value="Ireland">Ireland</option>
            <option value="International">International</option>
          </select>
        </div>
        <div className="flex gap-2 overflow-x-auto px-4 py-3">
          {topLevelPreview.map((r) => (
            <button
              key={r.id}
              type="button"
              onClick={() => onSelect(r)}
              className={`whitespace-nowrap rounded-full border px-3 py-1.5 text-sm font-semibold ${selected?.id === r.id ? "border-blue-400 bg-blue-100 text-blue-900" : "border-slate-300 bg-white text-slate-800"}`}
            >
              <span className="font-semibold">{r.menu_id}</span> - {r.sub_menu_name || r.menu_name}
            </button>
          ))}
        </div>
      </section>

      <div className="grid grid-cols-1 gap-4 lg:grid-cols-[1fr_1.35fr]">
        <section className="rounded-xl border border-slate-200 bg-white p-3 shadow-sm">
          <div className="mb-2 flex flex-wrap gap-2">
            <button className="rounded-lg bg-cyan-600 px-3 py-1.5 text-sm font-semibold text-white shadow-sm transition hover:bg-cyan-700" onClick={newChild}>New Child</button>
            <button className="rounded-lg bg-indigo-600 px-3 py-1.5 text-sm font-semibold text-white shadow-sm transition hover:bg-indigo-700 disabled:opacity-50" disabled={!selected} onClick={newSibling}>Create Sibling</button>
            <button className="rounded-lg bg-slate-700 px-3 py-1.5 text-sm font-semibold text-white shadow-sm transition hover:bg-slate-800" onClick={() => { setIsNew(true); setSelected(null); setForm(emptyForm); }}>New Root</button>
            <button className="rounded-lg bg-amber-600 px-3 py-1.5 text-sm font-semibold text-white shadow-sm transition hover:bg-amber-700 disabled:opacity-50" disabled={!selected} onClick={() => move("up")}>Move Up</button>
            <button className="rounded-lg bg-amber-700 px-3 py-1.5 text-sm font-semibold text-white shadow-sm transition hover:bg-amber-800 disabled:opacity-50" disabled={!selected} onClick={() => move("down")}>Move Down</button>
          </div>
          <ul className="max-h-[72vh] space-y-1 overflow-auto rounded-lg border border-slate-200 bg-slate-50 p-1.5 pr-1">
            {tree.map((n) => (
              <li key={n.id} className={highlightMenuId && String(n.menu_id || "").startsWith(highlightMenuId) ? "rounded bg-yellow-100/70 ring-1 ring-yellow-400" : ""}>
                <TreeNode node={n} selectedId={selected?.id || null} onSelect={onSelect} onDropMove={onDropMove} />
              </li>
            ))}
          </ul>
        </section>

        <section className="rounded-xl border border-slate-200 bg-white p-4 shadow-sm">
          <h2 className="mb-3 text-lg font-semibold">{isNew ? "Create Item" : "Edit Item"}</h2>

          <div className="mb-3 grid grid-cols-1 gap-2 rounded-xl border border-slate-200 bg-slate-50 p-3 md:grid-cols-[1fr_auto] md:items-end">
            <label className="flex flex-col gap-1">
              <span className="text-[11px] font-bold uppercase tracking-[0.06em] text-slate-600">ICON_CLASS (editable)</span>
              <input className="rounded-lg border border-slate-400 bg-white px-2 py-1.5 font-medium text-slate-800 focus:border-cyan-500 focus:outline-none focus:ring-2 focus:ring-cyan-100" value={form.icon_class ?? ""} onChange={(e) => f("icon_class", e.target.value)} placeholder="lucide:microscope or tabler:virus" />
            </label>
            <div className="flex items-center gap-2">
              <span className="text-xs text-slate-500">Preview</span>
              <span className="inline-flex h-8 w-8 items-center justify-center rounded border bg-white text-[var(--syntec-blue)]">
                <IconMark iconClass={form.icon_class} className="h-5 w-5" />
              </span>
            </div>
            <label className="md:col-span-2 flex flex-col gap-1">
              <span className="text-[11px] font-bold uppercase tracking-[0.06em] text-slate-600">Used Icons (helper)</span>
              <select className="rounded-lg border border-slate-400 bg-white px-2 py-1.5 font-medium text-slate-800 focus:border-cyan-500 focus:outline-none focus:ring-2 focus:ring-cyan-100" value="" onChange={(e) => e.target.value && f("icon_class", e.target.value)}>
                <option value="">Choose an existing icon...</option>
                {usedIcons.map((ic) => <option key={ic} value={ic}>{ic}</option>)}
              </select>
            </label>
          </div>

          <div className="grid grid-cols-2 gap-2 text-sm">
            {["parent_menu_id", "menu_id", "menu_name", "sub_menu_name", "sub_menu_id", "sub_menu_text", "css_class", "url", "url_mobile", "business", "business_set", "website", "website_set", "website_anchor", "menu_order", "menu_id_order", "menu_order_clone", "product_type", "discipline_id", "product_group_id", "supplier_id", "product_id", "oracle_parent_id"].map((k) => (
              <label key={k} className="flex flex-col gap-1">
                <span className="text-[11px] font-bold uppercase tracking-[0.06em] text-slate-600">{k}</span>
                <input className="rounded-lg border border-slate-400 bg-slate-50 px-2 py-1.5 font-medium text-slate-800 focus:border-cyan-500 focus:outline-none focus:ring-2 focus:ring-cyan-100" value={form[k] ?? ""} onChange={(e) => f(k, e.target.value)} />
              </label>
            ))}

            <label className="flex flex-col gap-1">
              <span className="text-[11px] font-bold uppercase tracking-[0.06em] text-slate-600">sub_menu_level_id</span>
              <select className="rounded-lg border border-slate-400 bg-slate-50 px-2 py-1.5 font-medium text-slate-800 focus:border-cyan-500 focus:outline-none focus:ring-2 focus:ring-cyan-100" value={form.sub_menu_level_id ?? ""} onChange={(e) => f("sub_menu_level_id", e.target.value)}>
                <option value="">Select level</option>
                {LEVELS.map((lvl) => <option key={lvl} value={lvl}>{lvl}</option>)}
              </select>
            </label>

            <label className="flex flex-col gap-1">
              <span className="text-[11px] font-bold uppercase tracking-[0.06em] text-slate-600">enabled (Y/N)</span>
              {checkYn("enabled")}
            </label>
          </div>

          <div className="mt-4 flex gap-2">
            <button className="rounded-lg bg-emerald-600 px-4 py-2 text-sm font-semibold text-white shadow-sm transition hover:bg-emerald-700" onClick={save}>Save</button>
            {!isNew && form.id ? <button className="rounded-lg bg-rose-600 px-4 py-2 text-sm font-semibold text-white shadow-sm transition hover:bg-rose-700" onClick={() => setShowDeleteConfirm(true)}>Delete</button> : null}
          </div>
        </section>
      </div>
      {showDeleteConfirm ? (
        <div className="fixed inset-0 z-50 flex items-center justify-center bg-slate-900/40 p-4">
          <div className="w-full max-w-md rounded-xl border border-slate-200 bg-white p-4 shadow-xl">
            <h3 className="text-lg font-semibold text-slate-900">Delete Menu Item</h3>
            <p className="mt-2 text-sm text-slate-700">
              Delete <span className="font-semibold">{form.menu_name || form.sub_menu_name || form.menu_id || "this item"}</span>? This cannot be undone.
            </p>
            <div className="mt-4 flex justify-end gap-2">
              <button className="rounded-lg border border-slate-300 px-3 py-2 text-sm font-semibold text-slate-700 hover:bg-slate-100" onClick={() => setShowDeleteConfirm(false)}>Cancel</button>
              <button className="rounded-lg bg-rose-600 px-3 py-2 text-sm font-semibold text-white hover:bg-rose-700" onClick={remove}>Delete</button>
            </div>
          </div>
        </div>
      ) : null}
    </main>
  );
}
