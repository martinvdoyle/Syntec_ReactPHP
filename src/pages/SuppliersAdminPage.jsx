import { useEffect, useMemo, useRef, useState } from "react";
import * as LucideIcons from "lucide-react";
import { createSupplier, deleteSupplier, fetchSupplierImpact, fetchSuppliersAdmin, updateSupplier } from "../api/suppliersAdmin";
import { fetchLanguages } from "../api/languagesAdmin";
import { API_BASE_URL } from "../api/config";
import SaveSuccessDialog from "../components/admin/SaveSuccessDialog";
import "../styles/legacy-content.css";

export default function SuppliersAdminPage() {
  const [lang, setLang] = useState("en");
  const [languageOptions, setLanguageOptions] = useState([]);
  const [items, setItems] = useState([]);
  const [query, setQuery] = useState("");
  const [filterActiveY, setFilterActiveY] = useState(true);
  const [filterDeletedN, setFilterDeletedN] = useState(false);
  const [selectedId, setSelectedId] = useState(null);
  const [error, setError] = useState("");
  const [showSaveDialog, setShowSaveDialog] = useState(false);
  const [form, setForm] = useState({});
  const [isNew, setIsNew] = useState(false);
  const listRef = useRef(null);

  useEffect(() => {
    fetchLanguages()
      .then((r) => {
        const opts = (r?.items || []).filter((x) => String(x.is_active || "Y").toUpperCase() === "Y")
          .map((x) => ({ code: String(x.lang_code), label: `${x.lang_name} (${x.lang_code})`, flag: x.flag_path || "/assets/images/flags/gb.svg" }));
        setLanguageOptions(opts);
        if (opts.length && !opts.some((o) => o.code === lang)) setLang(opts[0].code);
      })
      .catch(() => setLanguageOptions([{ code: "en", label: "English (en)", flag: "/assets/images/flags/gb.svg" }]));
  }, []);

  useEffect(() => {
    fetchSuppliersAdmin(lang)
      .then((payload) => {
        setError("");
        const list = Array.isArray(payload?.items) ? payload.items : [];
        setItems(list);
        if (!list.length) {
          setSelectedId(null);
          return;
        }
        setSelectedId((prev) => {
          if (prev && list.some((x) => getRowKey(x) === prev)) return prev;
          return getRowKey(list[0]);
        });
      })
      .catch((e) => setError(e?.message || "Failed to load suppliers."));
  }, [lang]);

  const filtered = useMemo(() => {
    const q = query.trim().toLowerCase();
    const yn = (v) => String(v ?? "").trim().toUpperCase();
    let list = items;
    if (filterActiveY) {
      list = list.filter((s) => yn(s.active) === "Y");
    }
    if (filterDeletedN) {
      list = list.filter((s) => yn(s.deleted) === "Y");
    }
    if (!q) return list;
    return list.filter((s) =>
      [s.supplier_id, s.supplier_name, s.short_name, s.website, s.business]
        .filter(Boolean)
        .some((v) => String(v).toLowerCase().includes(q))
    );
  }, [items, query, filterActiveY, filterDeletedN]);
  const selected = useMemo(() => filtered.find((s) => getRowKey(s) === selectedId) || filtered[0] || null, [filtered, selectedId]);
  useEffect(() => {
    if (!selected) return;
    setForm(selected);
    setIsNew(false);
  }, [selected]);
  const assetBaseUrl = useMemo(() => API_BASE_URL.replace(/\/api\/?$/, ""), []);
  const selectedLogo = selected?.supplier_logo_large || selected?.supplier_logo_small || "";
  const previewHtml = useMemo(() => {
    const raw = (form && Object.prototype.hasOwnProperty.call(form, "profile_1"))
      ? (form.profile_1 ?? "")
      : (selected?.profile_1 ?? "");
    if (!raw) return "<p class='text-slate-400'>No profile_1 content</p>";
    if (raw.includes("&lt;") || raw.includes("&gt;") || raw.includes("&amp;")) {
      const t = document.createElement("textarea");
      t.innerHTML = raw;
      return t.value;
    }
    return raw;
  }, [form?.profile_1, selected?.profile_1]);
  const selectedLogoUrl = useMemo(() => {
    if (!selectedLogo) return "";
    if (selectedLogo.startsWith("http")) return selectedLogo;

    const raw = String(selectedLogo).trim().replace(/^\/+/, "");
    const normalized = raw.startsWith("assets/")
      ? raw
      : raw.startsWith("images/")
        ? `assets/${raw}`
        : raw.startsWith("Scientific/suppliers/")
          ? `assets/images/${raw}`
        : raw.startsWith("suppliers/")
          ? `assets/images/${raw}`
          : `assets/images/Scientific/suppliers/${raw}`;

    return `${assetBaseUrl}/${normalized}`;
  }, [assetBaseUrl, selectedLogo]);
  const isHybridColumn = (key) => {
    const k = String(key || "").toLowerCase();
    return k === "id" || k.endsWith("_flag") || k === "slug" || k === "sort_order" || k === "created_at" || k === "updated_at";
  };
  const isYnField = (key, value) => {
    const k = String(key || "").toLowerCase();
    if (k.startsWith("date_")) return false;
    if (!(k.includes("active") || k.includes("deleted") || k.endsWith("_yn") || k.endsWith("_smaller") || k.includes("external"))) return false;
    if (value == null || value === "") return true;
    const v = String(value).toUpperCase();
    return v === "Y" || v === "N";
  };
  const orderedFormEntries = useMemo(() => {
    const entries = Object.entries(form).filter(([k]) => !isHybridColumn(k));
    const pinned = ["active", "deleted"];
    return entries.sort(([a], [b]) => {
      const ai = pinned.indexOf(String(a).toLowerCase());
      const bi = pinned.indexOf(String(b).toLowerCase());
      if (ai === -1 && bi === -1) return 0;
      if (ai === -1) return 1;
      if (bi === -1) return -1;
      return ai - bi;
    });
  }, [form]);
  const save = async () => {
    try {
      setError("");
      const nextActive = String(form?.active ?? "Y").trim().toUpperCase() === "N" ? "N" : "Y";
      const nextDeleted = String(form?.deleted ?? "N").trim().toUpperCase() === "Y" ? "Y" : "N";
      const prevActive = String(selected?.active ?? "Y").trim().toUpperCase() === "N" ? "N" : "Y";
      const prevDeleted = String(selected?.deleted ?? "N").trim().toUpperCase() === "Y" ? "Y" : "N";
      const flagsChanged = !isNew && (nextActive !== prevActive || nextDeleted !== prevDeleted);

      if (flagsChanged) {
        const impact = await fetchSupplierImpact({
          supplier_id: form?.supplier_id,
          active: nextActive,
          deleted: nextDeleted,
        });
        const ok = window.confirm(
          `Changing supplier flags will sync all child product flags to match.\n\n` +
          `Supplier: ${form?.supplier_id || "(unknown)"}\n` +
          `Active: ${prevActive} -> ${nextActive}\n` +
          `Deleted: ${prevDeleted} -> ${nextDeleted}\n` +
          `Products that will change: ${impact?.products_changed ?? 0} (of ${impact?.products_total ?? 0})\n\n` +
          `Continue?`
        );
        if (!ok) return;
      }
      if (isNew) {
        await createSupplier(form, lang);
      } else {
        await updateSupplier(form, lang);
      }
      const payload = await fetchSuppliersAdmin(lang);
      const list = Array.isArray(payload?.items) ? payload.items : [];
      setItems(list);
      setSelectedId(form.supplier_id || selectedId);
      setIsNew(false);
      setShowSaveDialog(true);
    } catch (e) {
      setError(e?.message || "Save failed.");
    }
  };

  const remove = async () => {
    try {
      const supplierId = String(form?.supplier_id || "");
      if (!supplierId) return;
      setError("");
      await deleteSupplier(supplierId);
      const payload = await fetchSuppliersAdmin(lang);
      const list = Array.isArray(payload?.items) ? payload.items : [];
      setItems(list);
      setSelectedId(list.length ? getRowKey(list[0]) : null);
      setForm({});
    } catch (e) {
      setError(e?.message || "Delete failed.");
    }
  };

  useEffect(() => {
    if (!selectedId || !listRef.current) return;
    const row = listRef.current.querySelector(`[data-supplier-id="${selectedId}"]`);
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
  };

  return (
    <main className="mx-auto max-w-[1780px] bg-slate-50 p-4">
      <h1 className="mb-1 text-3xl font-black tracking-tight text-slate-900">Admin: Suppliers</h1>
      <p className="mb-4 text-sm text-slate-700">Three-panel workspace with live supplier content preview.</p>
      <div className="mb-3 flex items-center gap-2">
        <span className="text-xs font-bold uppercase tracking-[0.08em] text-slate-600">Language</span>
        <span className="inline-flex min-w-10 items-center justify-center rounded-md border border-slate-300 bg-white px-2 py-1 text-xs font-bold text-slate-700">
          <img
            src={languageOptions.find((x) => x.code === lang)?.flag}
            alt={lang}
            className="h-4 w-6 rounded-sm border border-slate-300 object-cover"
          />
        </span>
        <select
          className="rounded-md border border-slate-300 bg-white px-2 py-1 text-sm"
          value={lang}
          onChange={(e) => setLang(e.target.value)}
        >
          {languageOptions.map((opt) => (
            <option key={opt.code} value={opt.code}>
              {opt.label}
            </option>
          ))}
        </select>
      </div>
      {error ? <div className="mb-3 rounded-lg border border-rose-300 bg-rose-50 px-3 py-2 text-sm text-rose-800">{error}</div> : null}

      <div className="mb-4 flex flex-wrap gap-2 rounded-xl border border-[#70A9E0] bg-[#5B9BE0] p-3 shadow-sm">
        <a className="rounded-lg border border-white/45 bg-[#4E8FD8] px-3 py-1 text-sm font-medium !text-white visited:!text-white transition hover:bg-[#3F82CE]" href="/admin/menu">Menu</a>
        <a className="rounded-lg border border-white/45 bg-[#4E8FD8] px-3 py-1 text-sm font-medium !text-white visited:!text-white transition hover:bg-[#3F82CE]" href="/admin/products">Products</a>
        <a className="rounded-lg border border-white bg-white px-3 py-1 text-sm font-semibold text-black shadow" href="/admin/suppliers">Suppliers</a>
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

      <div className="grid grid-cols-1 gap-4 xl:grid-cols-[320px_1.55fr_1.1fr]">
        <section className="rounded-xl border border-slate-200 bg-white p-3 shadow-sm">
          <div className="mb-2 flex items-center gap-2">
            <button
              className="rounded-lg bg-cyan-600 px-3 py-1 font-semibold text-white shadow-sm transition hover:bg-cyan-700"
              onClick={() => { setIsNew(true); setSelectedId(null); setForm({ active: "Y", deleted: "N" }); }}
            >
              New Supplier
            </button>
            <div className="relative min-w-0 flex-1">
              <LucideIcons.Search className="pointer-events-none absolute left-2 top-1/2 h-4 w-4 -translate-y-1/2 text-slate-400" />
            <input
                className="w-full rounded-lg border border-slate-300 px-8 py-1 text-sm focus:border-cyan-500 focus:outline-none focus:ring-2 focus:ring-cyan-100"
              placeholder="Search supplier code/name/website..."
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
          <div className="mb-2 flex items-center gap-4 px-1 text-xs font-semibold text-slate-700">
            <label className="inline-flex items-center gap-1.5">
              <input type="checkbox" checked={filterActiveY} onChange={(e) => setFilterActiveY(e.target.checked)} />
              <span>Active (Y)</span>
            </label>
            <label className="inline-flex items-center gap-1.5">
              <input type="checkbox" checked={filterDeletedN} onChange={(e) => setFilterDeletedN(e.target.checked)} />
              <span>Deleted (Y)</span>
            </label>
          </div>
          <div className="mb-1 px-1 text-xs font-semibold text-slate-500">
            Showing {filtered.length} of {items.length}
          </div>
          <ul
            ref={listRef}
            className="max-h-[calc(100vh-260px)] md:max-h-[calc(100vh-230px)] space-y-1 overflow-auto rounded-lg border border-slate-200 bg-slate-50 p-1.5 pr-1"
            tabIndex={0}
            onKeyDown={handleListKeyDown}
          >
            {filtered.map((s) => (
              <li key={getRowKey(s)}>
                <button
                  data-supplier-id={getRowKey(s)}
                  type="button"
                  onClick={() => setSelectedId(getRowKey(s))}
                  className={`w-full rounded-lg border-l-4 px-2 py-1.5 text-left text-sm transition ${
                    getRowKey(selected) === getRowKey(s)
                      ? "border-l-cyan-700 border-r-cyan-300 border-y-cyan-300 bg-cyan-100 text-cyan-950"
                      : "border-l-transparent border-r-transparent border-y-transparent hover:border-r-slate-200 hover:border-y-slate-200 hover:bg-slate-50"
                  } focus:outline-none`}
                >
                  <p className="truncate text-[15px] font-semibold text-slate-900">{s.supplier_name || "(no name)"}</p>
                </button>
              </li>
            ))}
          </ul>
        </section>

        <section className="rounded-xl border border-slate-200 bg-white p-3 shadow-sm">
          <h2 className="mb-3 text-2xl font-bold text-slate-800">Supplier Details</h2>
          {!selected ? (
            <p className="text-slate-500">No suppliers found.</p>
          ) : (
            <div className="rounded-xl border border-slate-200 bg-white p-4 shadow-sm">
              <h3 className="mb-3 border-l-4 border-cyan-500 pl-2 text-[13px] font-extrabold uppercase tracking-[0.08em] text-slate-700">
                Supplier Fields
              </h3>
              <div className="grid grid-cols-1 gap-2 md:grid-cols-2 text-sm">
                {orderedFormEntries.map(([k, v]) => (
                  <label key={k} className="flex flex-col gap-1">
                    <span className="text-[11px] font-bold uppercase tracking-[0.06em] text-slate-600">{k}</span>
                    {isYnField(k, v) ? (
                      <label className="inline-flex items-center gap-2 text-sm font-medium text-slate-800">
                        <input type="checkbox" checked={String(v ?? "N").toUpperCase() === "Y"} onChange={(e) => setForm((p) => ({ ...p, [k]: e.target.checked ? "Y" : "N" }))} />
                        <span>{String(v ?? "N").toUpperCase() === "Y" ? "Y" : "N"}</span>
                      </label>
                    ) : String(k).toLowerCase() === "profile_1" ? (
                      <textarea
                        className="min-h-[160px] rounded-lg border border-slate-400 bg-slate-50 px-2 py-1.5 font-medium text-slate-800 focus:border-cyan-500 focus:outline-none focus:ring-2 focus:ring-cyan-100"
                        value={v === null || v === undefined ? "" : String(v)}
                        onChange={(e) => setForm((p) => ({ ...p, [k]: e.target.value }))}
                      />
                    ) : (
                      <input
                        className="rounded-lg border border-slate-400 bg-slate-50 px-2 py-1.5 font-medium text-slate-800 focus:border-cyan-500 focus:outline-none focus:ring-2 focus:ring-cyan-100"
                        value={v === null || v === undefined ? "" : String(v)}
                        onChange={(e) => setForm((p) => ({ ...p, [k]: e.target.value }))}
                      />
                    )}
                  </label>
                ))}
              </div>
              <div className="mt-4 flex gap-2">
                <button className="rounded-lg bg-emerald-600 px-4 py-2 text-sm font-semibold text-white" onClick={save}>Save</button>
                {!isNew && form?.supplier_id ? <button className="rounded-lg bg-rose-600 px-4 py-2 text-sm font-semibold text-white" onClick={remove}>Delete</button> : null}
              </div>
            </div>
          )}
        </section>

        <section className="rounded-xl border border-slate-200 bg-white p-3 shadow-sm">
          <div className="mb-3 border-l-4 border-cyan-500 pl-2">
            <div className="flex items-center gap-2">
              <h3 className="text-[13px] font-extrabold uppercase tracking-[0.08em] text-slate-700">Live Preview</h3>
              <img
                src={languageOptions.find((x) => x.code === lang)?.flag}
                alt={lang}
                className="h-4 w-6 rounded-sm border border-slate-300 object-cover"
              />
            </div>
          </div>
          <div className="legacy-suppliers-content max-h-[72vh] overflow-auto rounded-xl border border-slate-200 bg-white p-4">
            {selectedLogoUrl ? (
              <div className="mb-4 inline-block overflow-hidden rounded-xl border border-slate-200 bg-white p-2">
                <img
                  src={selectedLogoUrl}
                  alt={selected?.supplier_name || "Supplier logo"}
                  className="h-14 w-auto max-w-full object-contain"
                />
              </div>
            ) : null}
            <div dangerouslySetInnerHTML={{ __html: previewHtml }} />
          </div>
        </section>
      </div>
      <SaveSuccessDialog open={showSaveDialog} onClose={() => setShowSaveDialog(false)} />
    </main>
  );
}
  const getRowKey = (row) => row?.supplier_id ?? row?.anchor_id ?? row?.supplier_name;
