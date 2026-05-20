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

function IconMark({ iconClass, className = "" }) {
  const raw = (iconClass || "").toLowerCase().trim();
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

  const load = async () => {
    const data = await fetchMenuAdmin();
    setItems(data.items || []);
  };

  useEffect(() => {
    load();
  }, []);

  const tree = useMemo(() => buildTree(items), [items]);
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
    if (!window.confirm("Delete this menu item?")) return;
    await deleteMenuItem(form.id);
    setForm(emptyForm);
    setSelected(null);
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
    <main className="mx-auto max-w-[1400px] p-4">
      <h1 className="mb-1 text-2xl font-bold">Admin: Menu Maintenance</h1>
      <p className="mb-4 text-sm text-slate-600">Hierarchy-first editor. Drag/drop works for sibling reorder, plus move up/down controls.</p>

      <div className="mb-4 flex flex-wrap gap-2 rounded border bg-white p-3">
        <a className="rounded bg-blue-700 px-3 py-1 text-sm font-semibold text-white" href="/admin/menu">Menu</a>
        <span className="rounded bg-slate-100 px-3 py-1 text-sm text-slate-500">Products (coming)</span>
        <span className="rounded bg-slate-100 px-3 py-1 text-sm text-slate-500">Suppliers (coming)</span>
      </div>

      <div className="grid grid-cols-1 gap-4 lg:grid-cols-[1fr_1.35fr]">
        <section className="rounded border bg-white p-3">
          <div className="mb-2 flex flex-wrap gap-2">
            <button className="rounded bg-blue-600 px-3 py-1 text-white" onClick={newChild}>New Child</button>
            <button className="rounded bg-indigo-600 px-3 py-1 text-white disabled:opacity-50" disabled={!selected} onClick={newSibling}>Create Sibling</button>
            <button className="rounded bg-slate-600 px-3 py-1 text-white" onClick={() => { setIsNew(true); setSelected(null); setForm(emptyForm); }}>New Root</button>
            <button className="rounded bg-amber-600 px-3 py-1 text-white disabled:opacity-50" disabled={!selected} onClick={() => move("up")}>Move Up</button>
            <button className="rounded bg-amber-700 px-3 py-1 text-white disabled:opacity-50" disabled={!selected} onClick={() => move("down")}>Move Down</button>
          </div>
          <ul className="space-y-1">
            {tree.map((n) => (
              <TreeNode key={n.id} node={n} selectedId={selected?.id || null} onSelect={onSelect} onDropMove={onDropMove} />
            ))}
          </ul>
        </section>

        <section className="rounded border bg-white p-3">
          <h2 className="mb-3 text-lg font-semibold">{isNew ? "Create Item" : "Edit Item"}</h2>

          <div className="mb-3 grid grid-cols-1 gap-2 rounded border bg-slate-50 p-2 md:grid-cols-[1fr_auto] md:items-end">
            <label className="flex flex-col gap-1">
              <span className="text-xs font-semibold text-slate-600">ICON_CLASS (editable)</span>
              <input className="rounded border px-2 py-1" value={form.icon_class ?? ""} onChange={(e) => f("icon_class", e.target.value)} placeholder="lucide:microscope or tabler:virus" />
            </label>
            <div className="flex items-center gap-2">
              <span className="text-xs text-slate-500">Preview</span>
              <span className="inline-flex h-8 w-8 items-center justify-center rounded border bg-white text-[var(--syntec-blue)]">
                <IconMark iconClass={form.icon_class} className="h-5 w-5" />
              </span>
            </div>
            <label className="md:col-span-2 flex flex-col gap-1">
              <span className="text-xs font-semibold text-slate-600">Used Icons (helper)</span>
              <select className="rounded border px-2 py-1" value="" onChange={(e) => e.target.value && f("icon_class", e.target.value)}>
                <option value="">Choose an existing icon...</option>
                {usedIcons.map((ic) => <option key={ic} value={ic}>{ic}</option>)}
              </select>
            </label>
          </div>

          <div className="grid grid-cols-2 gap-2 text-sm">
            {["parent_menu_id", "menu_id", "menu_name", "sub_menu_name", "sub_menu_id", "sub_menu_text", "css_class", "url", "url_mobile", "business", "business_set", "website", "website_set", "website_anchor", "menu_order", "menu_id_order", "menu_order_clone", "product_type", "discipline_id", "product_group_id", "supplier_id", "product_id", "oracle_parent_id"].map((k) => (
              <label key={k} className="flex flex-col gap-1">
                <span className="text-xs font-semibold uppercase text-slate-600">{k}</span>
                <input className="rounded border px-2 py-1" value={form[k] ?? ""} onChange={(e) => f(k, e.target.value)} />
              </label>
            ))}

            <label className="flex flex-col gap-1">
              <span className="text-xs font-semibold uppercase text-slate-600">sub_menu_level_id</span>
              <select className="rounded border px-2 py-1" value={form.sub_menu_level_id ?? ""} onChange={(e) => f("sub_menu_level_id", e.target.value)}>
                <option value="">Select level</option>
                {LEVELS.map((lvl) => <option key={lvl} value={lvl}>{lvl}</option>)}
              </select>
            </label>

            <label className="flex flex-col gap-1">
              <span className="text-xs font-semibold uppercase text-slate-600">enabled (Y/N)</span>
              {checkYn("enabled")}
            </label>
          </div>

          <div className="mt-4 flex gap-2">
            <button className="rounded bg-emerald-600 px-3 py-1 text-white" onClick={save}>Save</button>
            {!isNew && form.id ? <button className="rounded bg-red-600 px-3 py-1 text-white" onClick={remove}>Delete</button> : null}
          </div>
        </section>
      </div>
    </main>
  );
}
