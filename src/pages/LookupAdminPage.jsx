import { useEffect, useMemo, useRef, useState } from "react";
import * as LucideIcons from "lucide-react";
import { createTableRow, deleteTableRow, fetchTableAdmin, updateTableRow } from "../api/tableAdmin";
import SaveSuccessDialog from "../components/admin/SaveSuccessDialog";

const TABLE_CONFIG = {
  discipline: { label: "Discipline", table: "syntec_discipline" },
  product_group: { label: "Product Group", table: "syntec_product_group" },
  product_type: { label: "Product Type", table: "syntec_product_type" },
  divisions: { label: "Divisions", table: "syntec_divisions" },
  job_titles: { label: "Job Titles", table: "syntec_job_titles" },
  message_enquiry_type: { label: "Message Enquiry Type", table: "syntec_message_enquiry_type" },
  message_types: { label: "Message Types", table: "syntec_message_types" },
  sources: { label: "Sources", table: "syntec_sources" },
  users: { label: "Users", table: "syntec_users" },
  messages: { label: "Messages", table: "syntec_messages" },
};

const ORACLE_COLUMNS = {
  discipline: [
    "deleted",
    "active",
    "discipline_id",
    "discipline_name",
    "discipline_icon_class",
    "discipline_order",
    "date_created",
    "date_deleted",
    "anchor_id",
    "discipline_image_1",
    "discipline_image_2",
  ],
  product_group: ["deleted","active","product_group_id","product_group_name","discipline_name","product_group_icon_class","product_group_order","date_created","date_deleted","anchor_id","discipline_id","product_group_image_1","product_group_image_2"],
  product_type: ["deleted","active","product_type_id","product_type_name","product_type_icon_class","product_type_order","date_created","date_deleted","anchor_id"],
  divisions: ["deleted","active","division_id","division_description","sort_order","date_created","date_deleted","anchor_id"],
  job_titles: ["deleted","active","job_title_id","job_title_description","sort_order","date_created","date_deleted","anchor_id"],
  message_enquiry_type: ["email_address","active","deleted","enquiry_type_id","enquiry_type_description"],
  message_types: ["message_type_id","message_description"],
  sources: ["source_type_id","source_description"],
  users: ["username","first_name","last_name","email","alt_email","phone_01","phone_02","mobile","access_level","is_deleted_yn","locked","user_id","created","updated","password","initials","user_job_title","division","user_role","address_line1","address_line2","address_line3","town","county","country","eircode","linkedin","facebook","twitter","title","post_code","photo_blob","photo_name","photo_mimetype","photo_charset","photo_lastupd","isactive","deleted_by","deleted_on","created_by","updated_by"],
  messages: ["message_id","name","organisation","email","phone","message","message_date","message_time","message_type","source_type","created_date","product_id","subject","enquiry_type_id","ip_address","city","region","country_name","device_type","browser_type","user_agent","os","website_user_email","message_ref"],
};

const LINKS = [
  ["discipline", "Discipline"],
  ["product_group", "Product Group"],
  ["product_type", "Product Type"],
  ["divisions", "Divisions"],
  ["job_titles", "Job Titles"],
  ["message_enquiry_type", "Enquiry Types"],
  ["message_types", "Message Types"],
  ["sources", "Sources"],
  ["users", "Users"],
  ["messages", "Messages"],
];
const LANGUAGE_OPTIONS = [
  { code: "en", label: "English (en)", flag: "/assets/images/flags/gb.svg" },
  { code: "fr", label: "French (fr)", flag: "/assets/images/flags/fr.svg" },
  { code: "it", label: "Italian (it)", flag: "/assets/images/flags/it.svg" },
];

export default function LookupAdminPage({ tableKey }) {
  const cfg = TABLE_CONFIG[tableKey];
  const isDiscipline = tableKey === "discipline";
  const [lang, setLang] = useState("en");
  const [items, setItems] = useState([]);
  const [columns, setColumns] = useState([]);
  const [selectedId, setSelectedId] = useState(null);
  const [query, setQuery] = useState("");
  const [filterActiveY, setFilterActiveY] = useState(true);
  const [filterDeletedN, setFilterDeletedN] = useState(false);
  const [form, setForm] = useState({});
  const [isNew, setIsNew] = useState(false);
  const [error, setError] = useState("");
  const [showSaveDialog, setShowSaveDialog] = useState(false);
  const listRef = useRef(null);

  const getRowKey = (row) =>
    row?.id ?? row?.discipline_id ?? row?.product_group_id ?? row?.product_type_id ?? row?.division_id ?? row?.job_title_id ?? row?.enquiry_type_id ?? row?.message_type ?? row?.source_type ?? row?.user_id ?? row?.message_id;
  const load = async () => {
    if (!cfg) {
      setError(`Invalid table route key: ${String(tableKey)}`);
      return;
    }
    try {
      setError("");
      const data = await fetchTableAdmin(cfg.table, isDiscipline ? lang : undefined);
      const rows = data.items || [];
      setItems(rows);
      setColumns(data.columns || []);
      if (rows.length && !selectedId) setSelectedId(getRowKey(rows[0]));
    } catch (e) {
      setError(e?.message || "Failed to load table data.");
    }
  };

  useEffect(() => { load(); }, [cfg?.table, tableKey, lang]);
  const selected = useMemo(() => items.find((x) => getRowKey(x) === selectedId) || null, [items, selectedId]);

  useEffect(() => {
    if (!selected) return;
    setForm(selected);
    setIsNew(false);
  }, [selected]);

  const isYnField = (key, value) => {
    const k = String(key || "").toLowerCase();
    if (!(k === "active" || k === "deleted" || k.endsWith("_yn") || k === "is_active" || k === "isactive" || k === "is_deleted_yn" || k === "enabled")) return false;
    if (value == null || value === "") return true;
    const v = String(value).toUpperCase();
    return v === "Y" || v === "N";
  };
  const isHybridColumn = (key) => {
    const k = String(key || "").toLowerCase();
    return k === "id" || k.endsWith("_flag") || k.endsWith("_code") || k === "slug" || k === "created_at" || k === "updated_at";
  };
  const hiddenWhenOracleTwinExists = (allCols, key) => {
    const k = String(key || "").toLowerCase();
    const set = new Set(allCols.map((c) => String(c).toLowerCase()));
    if (k === "is_active" && set.has("isactive")) return true;
    if (k === "user_code" && set.has("user_id")) return true;
    if (k === "message_code" && set.has("message_id")) return true;
    if (k === "message_type_code" && set.has("message_type")) return true;
    if (k === "source_type_code" && set.has("source_type")) return true;
    if (k === "enquiry_type_code" && set.has("enquiry_type_id")) return true;
    if (k === "division_code" && set.has("division_id")) return true;
    if (k === "job_title_code" && set.has("job_title_id")) return true;
    if (k === "isactive" && set.has("is_active")) return true;
    return false;
  };
  const visibleColumns = useMemo(() => {
    const base = columns.filter((c) => !isHybridColumn(c) && !hiddenWhenOracleTwinExists(columns, c));
    const whitelist = ORACLE_COLUMNS[tableKey];
    if (!whitelist) return base;
    const allow = new Set(whitelist.map((x) => String(x).toLowerCase()));
    const filtered = base.filter((c) => allow.has(String(c).toLowerCase()));
    const pinned = ["active", "deleted"];
    return filtered.sort((a, b) => {
      const ai = pinned.indexOf(String(a).toLowerCase());
      const bi = pinned.indexOf(String(b).toLowerCase());
      if (ai === -1 && bi === -1) return 0;
      if (ai === -1) return 1;
      if (bi === -1) return -1;
      return ai - bi;
    });
  }, [columns, tableKey]);
  const hasActiveColumn = useMemo(() => visibleColumns.some((c) => String(c).toLowerCase() === "active"), [visibleColumns]);
  const hasDeletedColumn = useMemo(() => visibleColumns.some((c) => String(c).toLowerCase() === "deleted"), [visibleColumns]);

  const filtered = useMemo(() => {
    const q = query.trim().toLowerCase();
    const yn = (v) => String(v ?? "").trim().toUpperCase();
    let list = items;
    if (hasActiveColumn && filterActiveY) {
      list = list.filter((row) => yn(row.active) === "Y");
    }
    if (hasDeletedColumn && filterDeletedN) {
      list = list.filter((row) => yn(row.deleted) === "Y");
    }
    if (!q) return list;
    return list.filter((row) => visibleColumns.some((c) => String(row[c] ?? "").toLowerCase().includes(q)));
  }, [items, query, visibleColumns, hasActiveColumn, hasDeletedColumn, filterActiveY, filterDeletedN]);

  useEffect(() => {
    if (!selectedId || !listRef.current) return;
    const row = listRef.current.querySelector(`[data-row-id="${selectedId}"]`);
    if (row) {
      row.scrollIntoView({ block: "nearest" });
      row.focus();
    }
  }, [selectedId]);

  const handleListKeyDown = (e) => {
    if (!filtered.length) return;
    if (e.key !== "ArrowDown" && e.key !== "ArrowUp") return;
    e.preventDefault();
    const currentIndex = Math.max(0, filtered.findIndex((it) => getRowKey(it) === selectedId));
    const nextIndex =
      e.key === "ArrowDown"
        ? Math.min(filtered.length - 1, currentIndex + 1)
        : Math.max(0, currentIndex - 1);
    setSelectedId(getRowKey(filtered[nextIndex]));
    setIsNew(false);
  };

  const save = async () => {
    if (isNew) await createTableRow(cfg.table, form, isDiscipline ? lang : undefined);
    else await updateTableRow(cfg.table, form, isDiscipline ? lang : undefined);
    await load();
    setShowSaveDialog(true);
  };

  const remove = async () => {
    const keyName = keyByTable[tableKey];
    const keyValue = form[keyName];
    if (!keyName || keyValue == null || keyValue === "") return;
    await deleteTableRow(cfg.table, keyName, keyValue, isDiscipline ? lang : undefined);
    setForm({});
    setSelectedId(null);
    await load();
  };

  return (
    <main className="mx-auto max-w-[1780px] bg-slate-50 p-4">
      <h1 className="mb-1 text-3xl font-black tracking-tight text-slate-900">Admin: {cfg?.label || "Unknown"}</h1>
      <p className="mb-4 text-sm text-slate-700">Three-panel workspace with live content preview.</p>
      {isDiscipline ? (
        <div className="mb-3 flex items-center gap-2">
          <span className="text-xs font-bold uppercase tracking-[0.08em] text-slate-600">Language</span>
          <span className="inline-flex min-w-10 items-center justify-center rounded-md border border-slate-300 bg-white px-2 py-1 text-xs font-bold text-slate-700">
            <img
              src={LANGUAGE_OPTIONS.find((x) => x.code === lang)?.flag}
              alt={lang}
              className="h-4 w-6 rounded-sm border border-slate-300 object-cover"
            />
          </span>
          <select
            className="rounded-md border border-slate-300 bg-white px-2 py-1 text-sm"
            value={lang}
            onChange={(e) => setLang(e.target.value)}
          >
            {LANGUAGE_OPTIONS.map((opt) => (
              <option key={opt.code} value={opt.code}>
                {opt.label}
              </option>
            ))}
          </select>
        </div>
      ) : null}
      {error ? <div className="mb-3 rounded-lg border border-rose-300 bg-rose-50 px-3 py-2 text-sm text-rose-800">{error}</div> : null}

      <div className="mb-4 flex flex-wrap gap-2 rounded-xl border border-[#70A9E0] bg-[#5B9BE0] p-3 shadow-sm">
        <a className="rounded-lg border border-white/45 bg-[#4E8FD8] px-3 py-1 text-sm font-medium !text-white visited:!text-white transition hover:bg-[#3F82CE]" href="/admin/menu">Menu</a>
        <a className="rounded-lg border border-white/45 bg-[#4E8FD8] px-3 py-1 text-sm font-medium !text-white visited:!text-white transition hover:bg-[#3F82CE]" href="/admin/products">Products</a>
        <a className="rounded-lg border border-white/45 bg-[#4E8FD8] px-3 py-1 text-sm font-medium !text-white visited:!text-white transition hover:bg-[#3F82CE]" href="/admin/suppliers">Suppliers</a>
        {LINKS.map(([key, label]) => (
          <a key={key} className={`rounded-lg border px-3 py-1 text-sm font-medium transition ${tableKey===key ? 'border-white bg-white font-semibold text-black shadow' : 'border-white/45 bg-[#4E8FD8] !text-white visited:!text-white hover:bg-[#3F82CE]'}`} href={`/admin/${key}`}>{label}</a>
        ))}
      </div>

      <div className="grid grid-cols-1 gap-4 xl:grid-cols-[320px_1.55fr]">
        <section className="rounded-xl border border-slate-200 bg-white p-3 shadow-sm">
          <div className="mb-2 flex items-center gap-2">
            <button className="rounded-lg bg-cyan-600 px-3 py-1 font-semibold text-white" onClick={() => { setIsNew(true); setSelectedId(null); setForm({}); }}>New</button>
            <div className="relative min-w-0 flex-1">
              <LucideIcons.Search className="pointer-events-none absolute left-2 top-1/2 h-4 w-4 -translate-y-1/2 text-slate-400" />
              <input
                className="w-full rounded-lg border border-slate-300 px-8 py-1 text-sm focus:border-cyan-500 focus:outline-none focus:ring-2 focus:ring-cyan-100"
                placeholder="Search..."
                value={query}
                onChange={(e) => setQuery(e.target.value)}
              />
              {query ? (
                <button
                  type="button"
                  aria-label="Clear search"
                  className="absolute right-1 top-1/2 inline-flex h-6 w-6 -translate-y-1/2 items-center justify-center rounded-md text-slate-500 transition hover:bg-slate-100 hover:text-slate-700"
                  onClick={() => setQuery("")}
                >
                  <LucideIcons.X className="h-4 w-4" />
                </button>
              ) : null}
            </div>
          </div>
          {(hasActiveColumn || hasDeletedColumn) ? (
            <div className="mb-2 flex items-center gap-4 px-1 text-xs font-semibold text-slate-700">
              {hasActiveColumn ? (
                <label className="inline-flex items-center gap-1.5">
                  <input type="checkbox" checked={filterActiveY} onChange={(e) => setFilterActiveY(e.target.checked)} />
                  <span>Active (Y)</span>
                </label>
              ) : null}
              {hasDeletedColumn ? (
                <label className="inline-flex items-center gap-1.5">
                  <input type="checkbox" checked={filterDeletedN} onChange={(e) => setFilterDeletedN(e.target.checked)} />
                  <span>Deleted (Y)</span>
                </label>
              ) : null}
            </div>
          ) : null}
          <div className="mb-1 px-1 text-xs font-semibold text-slate-500">
            Showing {filtered.length} of {items.length}
          </div>
          <ul
            ref={listRef}
            className="max-h-[calc(100vh-260px)] md:max-h-[calc(100vh-230px)] space-y-1 overflow-auto rounded-lg border border-slate-200 bg-slate-50 p-1.5 pr-1"
            tabIndex={0}
            onKeyDown={handleListKeyDown}
          >
            {filtered.map((r) => (
              <li key={getRowKey(r)}>
                <button
                  data-row-id={getRowKey(r)}
                  type="button"
                  onClick={() => setSelectedId(getRowKey(r))}
                  className={`w-full rounded-lg border-l-4 px-2 py-1.5 text-left text-sm transition ${
                    getRowKey(selected) === getRowKey(r)
                      ? "border-l-cyan-700 border-r-cyan-300 border-y-cyan-300 bg-cyan-100 text-cyan-950"
                      : "border-l-transparent border-r-transparent border-y-transparent hover:border-r-slate-200 hover:border-y-slate-200 hover:bg-slate-50"
                  } focus:outline-none`}
                >
                  <p className="truncate text-[15px] font-semibold">
                    {(tableKey === "users"
                      ? `${String(r.first_name || "").trim()} ${String(r.last_name || "").trim()}`.trim() || r.username
                      : r.discipline_name || r.product_group_name || r.product_type_name || r.division_description || r.job_title_description || r.enquiry_type_description || r.message_description || r.source_description || r.message_ref) || "(no name)"}
                  </p>
                </button>
              </li>
            ))}
          </ul>
        </section>

        <section className="rounded-xl border border-slate-200 bg-white p-4 shadow-sm">
          <h3 className="mb-3 border-l-4 border-cyan-500 pl-2 text-[13px] font-extrabold uppercase tracking-[0.08em] text-slate-700">Edit Fields</h3>
          <div className="grid grid-cols-1 gap-2 md:grid-cols-2 text-sm">
            {visibleColumns.map((k) => (
              <label key={k} className="flex flex-col gap-1">
                <span className="text-[11px] font-bold uppercase tracking-[0.06em] text-slate-600">{k}</span>
                {isYnField(k, form[k]) ? (
                  <label className="inline-flex items-center gap-2 text-sm font-medium text-slate-800">
                    <input
                      type="checkbox"
                      checked={String(form[k] ?? "N").toUpperCase() === "Y"}
                      onChange={(e) => setForm((p) => ({ ...p, [k]: e.target.checked ? "Y" : "N" }))}
                    />
                    <span>{String(form[k] ?? "N").toUpperCase() === "Y" ? "Y" : "N"}</span>
                  </label>
                ) : (
                  <input className="rounded-lg border border-slate-400 bg-slate-50 px-2 py-1.5 font-medium text-slate-800 focus:border-cyan-500 focus:outline-none focus:ring-2 focus:ring-cyan-100" value={form[k] ?? ""} onChange={(e) => setForm((p) => ({ ...p, [k]: e.target.value }))} />
                )}
              </label>
            ))}
          </div>
          <div className="mt-4 flex gap-2">
            <button className="rounded-lg bg-emerald-600 px-4 py-2 text-sm font-semibold text-white" onClick={save}>Save</button>
            {!isNew && selected ? <button className="rounded-lg bg-rose-600 px-4 py-2 text-sm font-semibold text-white" onClick={remove}>Delete</button> : null}
          </div>
        </section>
      </div>
      <SaveSuccessDialog open={showSaveDialog} onClose={() => setShowSaveDialog(false)} />
    </main>
  );
}
  const keyByTable = {
    discipline: "discipline_id",
    product_group: "product_group_id",
    product_type: "product_type_id",
    divisions: "division_id",
    job_titles: "job_title_id",
    message_enquiry_type: "enquiry_type_id",
    message_types: "message_type_id",
    sources: "source_type_id",
    users: "user_id",
    messages: "message_id",
  };
