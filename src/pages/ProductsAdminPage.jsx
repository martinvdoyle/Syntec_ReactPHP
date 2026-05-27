import { useEffect, useMemo, useRef, useState } from "react";
import { renderToStaticMarkup } from "react-dom/server";
import * as LucideIcons from "lucide-react";
import * as TablerIcons from "@tabler/icons-react";
import { createProduct, deleteProduct, fetchProductsAdmin, updateProduct } from "../api/productsAdmin";
import { fetchSuppliersAdmin } from "../api/suppliersAdmin";
import { fetchLanguages } from "../api/languagesAdmin";
import { fetchTableAdmin } from "../api/tableAdmin";
import { API_BASE_URL } from "../api/config";
import SaveSuccessDialog from "../components/admin/SaveSuccessDialog";
import DrawerFrame from "../components/products/DrawerFrame";
import "../styles/legacy-content.css";

const empty = {
  id: null,
  product_id: "",
  prouduct_sku: "",
  product_name: "",
  supplier_id: "",
  short_name: "",
  about_1: "",
  product_image_large: "",
  product_link: "",
  active: "Y",
  deleted: "N",
};

export default function ProductsAdminPage() {
  const [lang, setLang] = useState("en");
  const [languageOptions, setLanguageOptions] = useState([]);
  const [items, setItems] = useState([]);
  const [suppliers, setSuppliers] = useState([]);
  const [disciplineOptions, setDisciplineOptions] = useState([]);
  const [productGroupOptions, setProductGroupOptions] = useState([]);
  const [productTypeOptions, setProductTypeOptions] = useState([]);
  const [selectedId, setSelectedId] = useState(null);
  const [form, setForm] = useState(empty);
  const [isNew, setIsNew] = useState(false);
  const [query, setQuery] = useState("");
  const [supplierFilter, setSupplierFilter] = useState("");
  const [filterActiveY, setFilterActiveY] = useState(true);
  const [filterDeletedN, setFilterDeletedN] = useState(false);
  const [previewOn, setPreviewOn] = useState(true);
  const [showDeleteConfirm, setShowDeleteConfirm] = useState(false);
  const [error, setError] = useState("");
  const [showSaveDialog, setShowSaveDialog] = useState(false);
  const [previewVideoOpen, setPreviewVideoOpen] = useState(false);
  const listRef = useRef(null);

  const load = async () => {
    try {
      setError("");
      const data = await fetchProductsAdmin(lang);
      const list = data.items || [];
      setItems(list);
      if (!list.length) {
        setSelectedId(null);
        return;
      }
      setSelectedId((prev) => {
        if (prev && list.some((x) => rowKey(x) === prev)) return prev;
        return rowKey(list[0]);
      });
    } catch (e) {
      setError(e?.message || "Failed to load products.");
    }
  };

  useEffect(() => { load(); }, [lang]);
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
    fetchSuppliersAdmin()
      .then((payload) => setSuppliers(Array.isArray(payload?.items) ? payload.items : []))
      .catch(() => setSuppliers([]));
  }, []);
  useEffect(() => {
    Promise.all([
      fetchTableAdmin("syntec_discipline", lang),
      fetchTableAdmin("syntec_product_group", lang),
      fetchTableAdmin("syntec_product_type", lang),
    ])
      .then(([d, g, t]) => {
        setDisciplineOptions(Array.isArray(d?.items) ? d.items : []);
        setProductGroupOptions(Array.isArray(g?.items) ? g.items : []);
        setProductTypeOptions(Array.isArray(t?.items) ? t.items : []);
      })
      .catch(() => {
        setDisciplineOptions([]);
        setProductGroupOptions([]);
        setProductTypeOptions([]);
      });
  }, [lang]);

  const rowKey = (x) => x?.product_id ?? "";
  const selected = useMemo(() => items.find((x) => rowKey(x) === selectedId) || null, [items, selectedId]);
  const hasCol = (k) => !!(selected && Object.prototype.hasOwnProperty.call(selected, k));
  const filteredItems = useMemo(() => {
    const q = query.trim().toLowerCase();
    const yn = (v) => String(v ?? "").trim().toUpperCase();
    let list = items;
    if (filterActiveY) {
      list = list.filter((it) => yn(it.active) === "Y");
    }
    if (filterDeletedN) {
      list = list.filter((it) => yn(it.deleted) === "Y");
    }
    if (supplierFilter) {
      list = list.filter((it) => String(it.supplier_id ?? "") === supplierFilter);
    }
    if (!q) return list;
    return list.filter((it) =>
      [it.product_id, it.product_name, it.prouduct_sku, it.supplier_id, it.supplier_name]
        .filter(Boolean)
        .some((v) => String(v).toLowerCase().includes(q))
    );
  }, [items, query, filterActiveY, filterDeletedN, supplierFilter]);
  const supplierOptions = useMemo(() => {
    const map = new Map();
    items.forEach((it) => {
      const id = String(it.supplier_id ?? "").trim();
      if (!id) return;
      const name = String(it.supplier_name ?? "").trim();
      if (!map.has(id)) map.set(id, name);
    });
    return Array.from(map.entries()).sort((a, b) => a[1].localeCompare(b[1]));
  }, [items]);

  useEffect(() => {
    if (!selected) return;
    setForm({
      ...empty,
      ...selected,
      supplier_id: selected.supplier_id ?? "",
      active: String(selected.active ?? (selected.active_flag === 1 ? "Y" : "N") ?? "Y").toUpperCase(),
      deleted: String(selected.deleted ?? "N").toUpperCase(),
    });
    setIsNew(false);
  }, [selected]);

  useEffect(() => {
    if (!selectedId || !listRef.current) return;
    const row = listRef.current.querySelector(`[data-product-id="${selectedId}"]`);
    if (row) {
      row.scrollIntoView({ block: "nearest" });
      // Keep keyboard focus and selected record visually in sync.
      if (document.activeElement && listRef.current.contains(document.activeElement)) {
        row.focus();
      }
    }
  }, [selectedId]);

  const f = (k, v) => setForm((prev) => ({ ...prev, [k]: v }));
  const fixDisplayText = (value) =>
    String(value ?? "")
      .replaceAll("�", "®")
      .replaceAll("â„¢", "™");
  const autoResize = (el) => {
    if (!el) return;
    el.style.height = "auto";
    el.style.height = `${el.scrollHeight}px`;
  };
  const isDirty = useMemo(() => {
    if (isNew) {
      return Object.entries(form).some(([k, v]) => k !== "id" && String(v ?? "") !== String(empty[k] ?? ""));
    }
    if (!selected) return false;
    const current = {
      ...empty,
      ...selected,
      supplier_id: selected.supplier_id ?? "",
      active: String(selected.active ?? (selected.active_flag === 1 ? "Y" : "N") ?? "Y").toUpperCase(),
      deleted: String(selected.deleted ?? "N").toUpperCase(),
    };
    return Object.keys(form).some((k) => String(form[k] ?? "") !== String(current[k] ?? ""));
  }, [form, selected, isNew]);
  const kebabToPascal = (value) =>
    String(value || "")
      .split("-")
      .filter(Boolean)
      .map((part) => part.charAt(0).toUpperCase() + part.slice(1))
      .join("");
  const iconSvgForToken = (token) => {
    const [lib, key] = String(token || "").split(":", 2);
    if (!lib || !key) return "";
    if ((lib === "lucide" || lib === "tabler") && key === "circle") {
      return `<span class="inline-block h-2 w-2 rounded-full align-middle" style="background-color:#0e83ad"></span>`;
    }
    if (lib === "lucide") {
      const Comp = LucideIcons[kebabToPascal(key)];
      if (!Comp) return "";
      return renderToStaticMarkup(<Comp className="inline-block h-4 w-4 align-middle text-cyan-700" strokeWidth={2} />);
    }
    if (lib === "tabler") {
      const Comp = TablerIcons[`Icon${kebabToPascal(key)}`];
      if (!Comp) return "";
      return renderToStaticMarkup(<Comp className="inline-block h-4 w-4 align-middle text-cyan-700" stroke={2} />);
    }
    return "";
  };
  const previewHtml = useMemo(() => {
    const raw = form.about_1 || "";
    if (!raw) return "";
    let decoded = raw;
    if (raw.includes("&lt;") || raw.includes("&gt;") || raw.includes("&amp;")) {
      const t = document.createElement("textarea");
      t.innerHTML = raw;
      decoded = t.value;
    }
    // Replace icon-token <i> nodes with rendered SVG icons.
    const parser = new DOMParser();
    const doc = parser.parseFromString(decoded, "text/html");
    const iconNodes = doc.querySelectorAll("i.icon-token");
    iconNodes.forEach((el) => {
      const cls = el.getAttribute("class") || "";
      const token = cls.split(/\s+/).find((c) => c.startsWith("lucide:") || c.startsWith("tabler:"));
      if (!token) return;
      const svg = iconSvgForToken(token);
      if (!svg) return;
      const span = doc.createElement("span");
      span.innerHTML = svg;
      el.replaceWith(span);
    });
    Array.from(doc.querySelectorAll(".panel")).forEach((panel) => {
      const title = (panel.querySelector(".panel-title a, .panel-title")?.textContent || "").toLowerCase();
      if (title.includes("video")) panel.remove();
    });
    doc.querySelectorAll("video").forEach((v) => v.remove());
    return doc.body.innerHTML;
  }, [form.about_1]);
  const previewMedia = useMemo(() => {
    const raw = String(form.about_1 || "");
    const mp4 = raw.match(/(?:#WORKSPACE_FILES#assets\/|\/assets\/)[^"'\s>]+\.mp4/i)?.[0] || "";
    const jpg = raw.match(/(?:#WORKSPACE_FILES#assets\/|\/assets\/)[^"'\s>]+\.jpg/i)?.[0] || "";
    const norm = (v) => v ? v.replace(/^#WORKSPACE_FILES#assets\//i, "/assets/") : "";
    return { mp4: norm(mp4), poster: norm(jpg) };
  }, [form.about_1]);
  const assetBaseUrl = useMemo(() => API_BASE_URL.replace(/\/api\/?$/, ""), []);
  const productImageUrl = useMemo(() => {
    const rawImage = String(form.product_image_display || form.product_image_1 || form.product_image_large || "").trim();
    if (!rawImage) return "";
    if (rawImage.startsWith("http")) return rawImage;

    const raw = rawImage.replace(/^\/+/, "");
    const normalized = raw.startsWith("assets/")
      ? raw
      : raw.startsWith("images/")
        ? `assets/${raw}`
        : raw.startsWith("Scientific/suppliers/")
          ? `assets/images/${raw}`
          : `assets/images/Scientific/suppliers/${raw}`;

    return `${assetBaseUrl}/${normalized}`;
  }, [assetBaseUrl, form.product_image_display, form.product_image_1, form.product_image_large]);
  const previewSupplierHoverColor = useMemo(() => {
    const sid = String(form.supplier_id || "").trim();
    const fromSupplier = suppliers.find((s) => String(s.supplier_id || "").trim() === sid)?.class_colour;
    return String(fromSupplier || form.class_colour || "").trim();
  }, [suppliers, form.supplier_id, form.class_colour]);
  const hasPreviewRecord = useMemo(
    () => Boolean(String(form.product_id || "").trim() || String(form.product_name || "").trim()),
    [form.product_id, form.product_name]
  );
  const previewSupplierLogoUrl = useMemo(() => {
    const rawLogo = String(form.supplier_logo_small || form.supplier_logo_large || "").trim();
    if (!rawLogo) return "";
    if (rawLogo.startsWith("http")) return rawLogo;
    const raw = rawLogo.replace(/^\/+/, "");
    const normalized = raw.startsWith("assets/")
      ? raw
      : raw.startsWith("images/")
        ? `assets/${raw}`
        : raw.startsWith("Scientific/suppliers/")
          ? `assets/images/${raw}`
          : `assets/images/Scientific/suppliers/${raw}`;
    return `${assetBaseUrl}/${normalized}`;
  }, [assetBaseUrl, form.supplier_logo_small, form.supplier_logo_large]);
  const isHybridColumn = (key) => {
    const k = String(key || "").toLowerCase();
    return k === "id" || k.endsWith("_flag") || k === "slug" || k === "created_at" || k === "updated_at" || k === "supplier_name_lookup";
  };
  const isYnField = (key, value) => {
    const k = String(key || "").toLowerCase();
    if (!(k === "active" || k === "deleted" || k.endsWith("_yn") || k.includes("external"))) return false;
    if (value == null || value === "") return true;
    const v = String(value).toUpperCase();
    return v === "Y" || v === "N";
  };
  const renderedMainFields = useMemo(
    () =>
      new Set([
        "product_id",
        "prouduct_sku",
        "product_name",
        "supplier_id",
        "product_image_large",
        "product_link",
        "category_summary",
        "short_name",
        "about_1",
        "about_2",
        "active",
        "deleted",
      ]),
    []
  );
  const additionalColumns = useMemo(() => {
    const source = selected ? Object.keys(selected) : Object.keys(form || {});
    const excluded = new Set(["supplier_active", "supplier_deleted", "supplier_name_join", "supplier_name"]);
    const redundantText = new Set([
      "discipline",
      "product_group",
      "product_type",
      "product_group_type_alt",
      "discipline_id",
      "product_group_id",
      "product_type_id",
      "product_group_type_alt_id",
    ]);
    return source.filter(
      (k) =>
        !isHybridColumn(k) &&
        !renderedMainFields.has(k) &&
        !excluded.has(String(k).toLowerCase()) &&
        !redundantText.has(String(k).toLowerCase())
    );
  }, [selected, form, renderedMainFields]);

  const save = async () => {
    if (isNew) await createProduct(form, lang);
    else await updateProduct(form, lang);
    await load();
    setShowSaveDialog(true);
  };
  const togglePreviewAccordion = (event) => {
    const source = event.target instanceof Element ? event.target : event.target?.parentElement;
    if (!source) return;
    const trigger = source.closest("[data-toggle='collapse'], .panel-title a, .panel-heading, .panel-title");
    if (!trigger) return;
    event.preventDefault();
    const panel = trigger.closest(".panel");
    const target = panel?.querySelector(".panel-collapse");
    if (!target) return;
    const isOpen = target.classList.contains("show") || target.classList.contains("in");
    target.classList.toggle("show", !isOpen);
    target.classList.toggle("in", !isOpen);
    target.style.display = !isOpen ? "block" : "none";
    const clickable = panel.querySelector("[data-toggle='collapse'], .panel-title a") || trigger;
    clickable.classList.toggle("collapsed", isOpen);
    clickable.setAttribute("aria-expanded", String(!isOpen));
  };

  const remove = async () => {
    if (!form.product_id) return;
    await deleteProduct(form.product_id);
    setForm(empty);
    setSelectedId(null);
    setShowDeleteConfirm(false);
    await load();
  };

  const handleListKeyDown = (e) => {
    if (!filteredItems.length) return;
    if (e.key !== "ArrowDown" && e.key !== "ArrowUp") return;
    e.preventDefault();
    const currentIndex = Math.max(
      0,
      filteredItems.findIndex((it) => rowKey(it) === selectedId)
    );
    const nextIndex =
      e.key === "ArrowDown"
        ? Math.min(filteredItems.length - 1, currentIndex + 1)
        : Math.max(0, currentIndex - 1);
    setSelectedId(rowKey(filteredItems[nextIndex]));
    setIsNew(false);
  };

  return (
    <main className="mx-auto max-w-[1780px] bg-slate-50 p-4">
      <h1 className="mb-1 text-3xl font-black tracking-tight text-slate-900">Admin: Products</h1>
      <p className="mb-4 text-sm text-slate-700">Three-panel workspace with live content preview. Supplier dropdowns and related-code poplists will be added after parent tables are imported.</p>
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
        <a className="rounded-lg border border-white bg-white px-3 py-1 text-sm font-semibold text-black shadow" href="/admin/products">Products</a>
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

      <div className="grid grid-cols-1 gap-4 xl:grid-cols-[320px_1.55fr_1.1fr]">
        <section className="rounded-xl border border-slate-200 bg-white p-3 shadow-sm">
          <div className="mb-2 flex items-center gap-2">
            <button className="rounded-lg bg-cyan-600 px-3 py-1 font-semibold text-white shadow-sm transition hover:bg-cyan-700" onClick={() => { setIsNew(true); setSelectedId(null); setForm(empty); }}>New Product</button>
            <div className="relative min-w-0 flex-1">
              <LucideIcons.Search className="pointer-events-none absolute left-2 top-1/2 h-4 w-4 -translate-y-1/2 text-slate-400" />
              <input
                className="w-full rounded-lg border border-slate-300 px-8 py-1 text-sm focus:border-cyan-500 focus:outline-none focus:ring-2 focus:ring-cyan-100"
                placeholder="Search code/product_name/sku..."
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
            <label className="inline-flex min-w-[280px] flex-col gap-1 text-[11px] font-bold uppercase tracking-[0.06em] text-slate-600">
              <span>Supplier</span>
              <select
                className="rounded-lg border border-slate-300 bg-white px-2 py-1 text-sm font-medium normal-case tracking-normal text-slate-800 focus:border-cyan-500 focus:outline-none focus:ring-2 focus:ring-cyan-100"
                value={supplierFilter}
                onChange={(e) => setSupplierFilter(e.target.value)}
              >
                <option value="">All suppliers</option>
                {supplierOptions.map(([id, name]) => (
                  <option key={id} value={id}>
                    {id} - {name || "(no supplier name)"}
                  </option>
                ))}
              </select>
            </label>
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
            Showing {filteredItems.length} of {items.length}
          </div>
          <ul
            ref={listRef}
            className="max-h-[calc(100vh-260px)] md:max-h-[calc(100vh-230px)] space-y-1 overflow-auto rounded-lg border border-slate-200 bg-slate-50 p-1.5 pr-1"
            tabIndex={0}
            onKeyDown={handleListKeyDown}
          >
            {filteredItems.map((it) => (
              <li key={rowKey(it)}>
                <button
                  data-product-id={rowKey(it)}
                  className={`w-full rounded-lg border-l-4 px-2 py-1.5 text-left text-sm transition ${
                    selectedId === rowKey(it)
                      ? "border-l-cyan-700 border-r-cyan-300 border-y-cyan-300 bg-cyan-100 text-cyan-950"
                      : "border-l-transparent border-r-transparent border-y-transparent hover:border-r-slate-200 hover:border-y-slate-200 hover:bg-slate-50"
                  } focus:outline-none focus-visible:ring-2 focus-visible:ring-cyan-300`}
                  onClick={() => setSelectedId(rowKey(it))}
                >
                  <div className="truncate text-[15px] font-semibold">{it.product_name || "(no product_name)"}</div>
                  <div
                    className={`mt-0.5 truncate text-xs font-medium text-slate-600 ${
                      (String(it.supplier_active ?? "").trim().toUpperCase() === "N" ||
                        String(it.supplier_deleted ?? "").trim().toUpperCase() === "Y")
                        ? "line-through text-slate-400"
                        : ""
                    }`}
                  >
                    {fixDisplayText(it.supplier_name || "(no supplier)")}
                  </div>
                </button>
              </li>
            ))}
          </ul>
        </section>

        <section className="space-y-4">
          <div className="sticky top-2 z-10 rounded-xl border border-slate-200 bg-white/95 p-3 shadow-sm backdrop-blur">
            <div className="mb-2 flex items-center justify-between">
              <h2 className="text-lg font-semibold">{isNew ? "Create Product" : "Edit Product"}</h2>
              <span className={`rounded-full px-3 py-1 text-xs font-bold ${isDirty ? "bg-amber-100 text-amber-800" : "bg-emerald-100 text-emerald-800"}`}>{isDirty ? "Unsaved changes" : "Saved"}</span>
            </div>
            <div className="flex gap-2">
              <button className="rounded-lg bg-emerald-600 px-4 py-2 text-sm font-semibold text-white shadow-sm transition hover:bg-emerald-700" onClick={save}>Save</button>
              {!isNew && form.product_id ? <button className="rounded-lg bg-rose-600 px-4 py-2 text-sm font-semibold text-white shadow-sm transition hover:bg-rose-700" onClick={() => setShowDeleteConfirm(true)}>Delete</button> : null}
            </div>
          </div>

          <div className="rounded-xl border border-slate-200 bg-white p-4 shadow-sm">
            <h3 className="mb-3 border-l-4 border-cyan-500 pl-2 text-[13px] font-extrabold uppercase tracking-[0.08em] text-slate-700">Flags</h3>
            <div className="inline-grid grid-cols-2 gap-3 text-sm">
              <label className="flex flex-col gap-1">
                <span className="text-[11px] font-bold uppercase tracking-[0.06em] text-slate-600">ACTIVE</span>
                <label className="inline-flex items-center gap-2 text-sm"><input type="checkbox" checked={form.active === "Y"} onChange={(e) => f("active", e.target.checked ? "Y" : "N")} /><span>{form.active === "Y" ? "Y" : "N"}</span></label>
              </label>
              <label className="flex flex-col gap-1">
                <span className="text-[11px] font-bold uppercase tracking-[0.06em] text-slate-600">DELETED</span>
                <label className="inline-flex items-center gap-2 text-sm"><input type="checkbox" checked={form.deleted === "Y"} onChange={(e) => f("deleted", e.target.checked ? "Y" : "N")} /><span>{form.deleted === "Y" ? "Y" : "N"}</span></label>
              </label>
            </div>
          </div>

          <div className="rounded-xl border border-slate-200 bg-white p-4 shadow-sm">
            <h3 className="mb-3 border-l-4 border-cyan-500 pl-2 text-[13px] font-extrabold uppercase tracking-[0.08em] text-slate-700">Identity</h3>
            <div className="grid grid-cols-2 gap-2 text-sm">
              {[["product_id", "PRODUCT_ID"], ["prouduct_sku", "PROUDUCT_SKU"], ["product_name", "PRODUCT_NAME"]].map(([k, lbl]) => (
                <label key={k} className="flex flex-col gap-1">
                  <span className="text-[11px] font-bold uppercase tracking-[0.06em] text-slate-600">{lbl}</span>
                  <input className="rounded-lg border border-slate-400 bg-slate-50 px-2 py-1.5 font-medium text-slate-800 focus:border-cyan-500 focus:outline-none focus:ring-2 focus:ring-cyan-100" value={form[k] ?? ""} onChange={(e) => f(k, e.target.value)} />
                </label>
              ))}
            </div>
          </div>

          <div className="rounded-xl border border-slate-200 bg-white p-4 shadow-sm">
            <h3 className="mb-3 border-l-4 border-cyan-500 pl-2 text-[13px] font-extrabold uppercase tracking-[0.08em] text-slate-700">Classification and Media</h3>
            <div className="grid grid-cols-2 gap-2 text-sm">
              <label className="flex flex-col gap-1">
                <span className="text-[11px] font-bold uppercase tracking-[0.06em] text-slate-600">SUPPLIER_ID</span>
                <select
                  className="rounded-lg border border-slate-400 bg-slate-50 px-2 py-1.5 font-medium text-slate-800 focus:border-cyan-500 focus:outline-none focus:ring-2 focus:ring-cyan-100"
                  value={form.supplier_id ?? ""}
                  onChange={(e) => f("supplier_id", e.target.value)}
                >
                  <option value="">Select supplier</option>
                  {suppliers.map((s) => (
                    <option key={s.supplier_id} value={s.supplier_id}>
                      {s.supplier_id} - {s.supplier_name || "(no name)"}
                    </option>
                  ))}
                </select>
              </label>
              {[["product_image_large", "PRODUCT_IMAGE_LARGE"]].map(([k, lbl]) => (
                <label key={k} className="flex flex-col gap-1">
                  <span className="text-[11px] font-bold uppercase tracking-[0.06em] text-slate-600">{lbl}</span>
                  <input className="rounded-lg border border-slate-400 bg-slate-50 px-2 py-1.5 font-medium text-slate-800 focus:border-cyan-500 focus:outline-none focus:ring-2 focus:ring-cyan-100" value={form[k] ?? ""} onChange={(e) => f(k, e.target.value)} />
                </label>
              ))}
              <label className="col-span-2 flex flex-col gap-1">
                <span className="text-[11px] font-bold uppercase tracking-[0.06em] text-slate-600">PRODUCT_LINK</span>
                <input className="rounded-lg border border-slate-400 bg-slate-50 px-2 py-1.5 font-medium text-slate-800 focus:border-cyan-500 focus:outline-none focus:ring-2 focus:ring-cyan-100" value={form.product_link ?? ""} onChange={(e) => f("product_link", e.target.value)} />
              </label>
              <label className="flex flex-col gap-1">
                <span className="text-[11px] font-bold uppercase tracking-[0.06em] text-slate-600">DISCIPLINE_ID</span>
                <select
                  className="rounded-lg border border-slate-400 bg-slate-50 px-2 py-1.5 font-medium text-slate-800 focus:border-cyan-500 focus:outline-none focus:ring-2 focus:ring-cyan-100"
                  value={form.discipline_id ?? ""}
                  onChange={(e) => f("discipline_id", e.target.value)}
                >
                  <option value="">Select discipline</option>
                  {disciplineOptions.map((r) => (
                    <option key={r.discipline_id} value={r.discipline_id}>
                      {r.discipline_id} - {r.discipline_name || "(no name)"}
                    </option>
                  ))}
                </select>
              </label>
              <label className="flex flex-col gap-1">
                <span className="text-[11px] font-bold uppercase tracking-[0.06em] text-slate-600">PRODUCT_GROUP_ID</span>
                <select
                  className="rounded-lg border border-slate-400 bg-slate-50 px-2 py-1.5 font-medium text-slate-800 focus:border-cyan-500 focus:outline-none focus:ring-2 focus:ring-cyan-100"
                  value={form.product_group_id ?? ""}
                  onChange={(e) => f("product_group_id", e.target.value)}
                >
                  <option value="">Select product group</option>
                  {productGroupOptions.map((r) => (
                    <option key={r.product_group_id} value={r.product_group_id}>
                      {r.product_group_id} - {r.product_group_name || "(no name)"}
                    </option>
                  ))}
                </select>
              </label>
              <label className="flex flex-col gap-1">
                <span className="text-[11px] font-bold uppercase tracking-[0.06em] text-slate-600">PRODUCT_TYPE_ID</span>
                <select
                  className="rounded-lg border border-slate-400 bg-slate-50 px-2 py-1.5 font-medium text-slate-800 focus:border-cyan-500 focus:outline-none focus:ring-2 focus:ring-cyan-100"
                  value={form.product_type_id ?? ""}
                  onChange={(e) => f("product_type_id", e.target.value)}
                >
                  <option value="">Select product type</option>
                  {productTypeOptions.map((r) => (
                    <option key={r.product_type_id} value={r.product_type_id}>
                      {r.product_type_id} - {r.product_type_name || "(no name)"}
                    </option>
                  ))}
                </select>
              </label>
              <label className="flex flex-col gap-1">
                <span className="text-[11px] font-bold uppercase tracking-[0.06em] text-slate-600">PRODUCT_GROUP_TYPE_ALT_ID</span>
                <select
                  className="rounded-lg border border-slate-400 bg-slate-50 px-2 py-1.5 font-medium text-slate-800 focus:border-cyan-500 focus:outline-none focus:ring-2 focus:ring-cyan-100"
                  value={form.product_group_type_alt_id ?? ""}
                  onChange={(e) => f("product_group_type_alt_id", e.target.value)}
                >
                  <option value="">Select alt product group</option>
                  {productGroupOptions.map((r) => (
                    <option key={r.product_group_id} value={r.product_group_id}>
                      {r.product_group_id} - {r.product_group_name || "(no name)"}
                    </option>
                  ))}
                </select>
              </label>
            </div>
          </div>

          <div className="rounded-xl border border-slate-200 bg-white p-4 shadow-sm">
            <h3 className="mb-3 border-l-4 border-cyan-500 pl-2 text-[13px] font-extrabold uppercase tracking-[0.08em] text-slate-700">Content</h3>
            <div className="grid grid-cols-2 gap-2 text-sm">
              {hasCol("category_summary") ? (
                <label className="col-span-2 flex flex-col gap-1">
                  <span className="text-[11px] font-bold uppercase tracking-[0.06em] text-slate-600">CATEGORY_SUMMARY</span>
                  <input className="rounded-lg border border-slate-400 bg-slate-50 px-2 py-1.5 font-medium text-slate-800 focus:border-cyan-500 focus:outline-none focus:ring-2 focus:ring-cyan-100" value={form.category_summary ?? ""} onChange={(e) => f("category_summary", e.target.value)} />
                </label>
              ) : null}
              <label className="col-span-2 flex flex-col gap-1">
                <span className="text-[11px] font-bold uppercase tracking-[0.06em] text-slate-600">short_name</span>
                <input className="rounded-lg border border-slate-400 bg-slate-50 px-2 py-1.5 font-medium text-slate-800 focus:border-cyan-500 focus:outline-none focus:ring-2 focus:ring-cyan-100" value={form.short_name ?? ""} onChange={(e) => f("short_name", e.target.value)} />
              </label>
              <label className="col-span-2 flex flex-col gap-1">
                <span className="text-[11px] font-bold uppercase tracking-[0.06em] text-slate-600">about_1</span>
                <textarea
                  className="min-h-[180px] resize-y rounded-lg border border-slate-400 bg-slate-50 px-2 py-1.5 font-medium text-slate-800 focus:border-cyan-500 focus:outline-none focus:ring-2 focus:ring-cyan-100"
                  value={form.about_1 ?? ""}
                  onChange={(e) => {
                    f("about_1", e.target.value);
                    autoResize(e.target);
                  }}
                  onInput={(e) => autoResize(e.currentTarget)}
                  ref={autoResize}
                />
              </label>
              <label className="col-span-2 flex flex-col gap-1">
                <span className="text-[11px] font-bold uppercase tracking-[0.06em] text-slate-600">about_2</span>
                <textarea
                  className="min-h-[90px] resize-y rounded-lg border border-slate-400 bg-slate-50 px-2 py-1.5 font-medium text-slate-800 focus:border-cyan-500 focus:outline-none focus:ring-2 focus:ring-cyan-100"
                  value={form.about_2 ?? ""}
                  onChange={(e) => f("about_2", e.target.value)}
                />
              </label>
            </div>
          </div>

          {additionalColumns.length ? (
            <div className="rounded-xl border border-slate-200 bg-white p-4 shadow-sm">
              <h3 className="mb-3 border-l-4 border-cyan-500 pl-2 text-[13px] font-extrabold uppercase tracking-[0.08em] text-slate-700">Additional Columns</h3>
              <div className="grid grid-cols-2 gap-2 text-sm">
                {additionalColumns.map((k) => (
                  <label key={k} className="flex flex-col gap-1">
                    <span className="text-[11px] font-bold uppercase tracking-[0.06em] text-slate-600">{k}</span>
                    {isYnField(k, form[k]) ? (
                      <label className="inline-flex items-center gap-2 text-sm">
                        <input type="checkbox" checked={String(form[k] ?? "N").toUpperCase() === "Y"} onChange={(e) => f(k, e.target.checked ? "Y" : "N")} />
                        <span>{String(form[k] ?? "N").toUpperCase() === "Y" ? "Y" : "N"}</span>
                      </label>
                    ) : (
                      <input
                        className="rounded-lg border border-slate-400 bg-slate-50 px-2 py-1.5 font-medium text-slate-800 focus:border-cyan-500 focus:outline-none focus:ring-2 focus:ring-cyan-100"
                        value={form[k] ?? ""}
                        onChange={(e) => f(k, e.target.value)}
                      />
                    )}
                  </label>
                ))}
              </div>
            </div>
          ) : null}
        </section>

        <section className="rounded-xl border border-slate-200 bg-white p-3 shadow-sm">
          <div className="mb-2 flex items-center justify-between">
            <div className="flex items-center gap-2">
              <h3 className="text-sm font-semibold uppercase tracking-wide text-slate-500">Live Preview</h3>
              <img
                src={languageOptions.find((x) => x.code === lang)?.flag}
                alt={lang}
                className="h-4 w-6 rounded-sm border border-slate-300 object-cover"
              />
            </div>
            <button className="rounded-lg border border-slate-300 px-2 py-1 text-xs transition hover:bg-slate-100" onClick={() => setPreviewOn((v) => !v)}>
              {previewOn ? "Hide HTML" : "Show HTML"}
            </button>
          </div>
          {previewOn ? (
            <div className="max-h-[calc(100vh-120px)] overflow-auto rounded-xl border border-slate-200 p-3">
              {hasPreviewRecord ? (
                <div className="mx-auto w-[760px] max-w-[760px]">
                <DrawerFrame
                  mode="preview"
                  name={form.product_name || "-"}
                  supplier={form.supplier_name || form.supplier_id || "-"}
                  supplierLogoUrl={previewSupplierLogoUrl}
                  productLink={form.product_link || ""}
                  hoverColor={previewSupplierHoverColor}
                  imageUrl={productImageUrl}
                  discipline={form.discipline || "(no discipline)"}
                  group={form.product_group || "(no group)"}
                >
                    <div
                      className="legacy-products-content prose prose-sm max-w-none [&_table]:block [&_table]:overflow-x-auto"
                      onClickCapture={togglePreviewAccordion}
                      dangerouslySetInnerHTML={{ __html: previewHtml }}
                    />
                    {previewMedia.mp4 ? (
                      <div className="rounded border border-slate-300 bg-[#dcdcdc]">
                        <button
                          type="button"
                          className="flex w-full items-center justify-between px-4 py-3 text-left text-base font-extrabold text-slate-900"
                          onClick={() => setPreviewVideoOpen((v) => !v)}
                          aria-expanded={previewVideoOpen}
                        >
                          <span className="flex items-center gap-2">
                            <LucideIcons.Video className="h-4 w-4 text-cyan-700" />
                            {form.product_name || "Product"} Video
                          </span>
                          <LucideIcons.ChevronDown className={`h-4 w-4 text-slate-700 transition-transform ${previewVideoOpen ? "rotate-180" : ""}`} />
                        </button>
                        {previewVideoOpen ? (
                          <div className="border-t border-slate-300 bg-white p-3">
                            <video controls poster={previewMedia.poster || undefined} className="mx-auto block h-auto w-full max-w-[760px] bg-black">
                              <source src={previewMedia.mp4} type="video/mp4" />
                            </video>
                          </div>
                        ) : null}
                      </div>
                    ) : null}
                  </DrawerFrame>
                </div>
              ) : (
                <div className="flex min-h-[180px] items-center justify-center rounded-xl border border-dashed border-slate-300 bg-slate-50 text-sm text-slate-500">
                  Select a product to preview drawer content.
                </div>
              )}
            </div>
          ) : (
            <div className="rounded-xl border border-slate-200 p-3 text-sm text-slate-500">Preview hidden.</div>
          )}

        </section>
      </div>
      {showDeleteConfirm ? (
        <div className="fixed inset-0 z-50 flex items-center justify-center bg-slate-900/40 p-4">
          <div className="w-full max-w-md rounded-xl border border-slate-200 bg-white p-4 shadow-xl">
            <h3 className="text-lg font-semibold text-slate-900">Delete Product</h3>
            <p className="mt-2 text-sm text-slate-700">
              Delete <span className="font-semibold">{form.product_name || form.product_id || "this product"}</span>? This cannot be undone.
            </p>
            <div className="mt-4 flex justify-end gap-2">
              <button className="rounded-lg border border-slate-300 px-3 py-2 text-sm font-semibold text-slate-700 hover:bg-slate-100" onClick={() => setShowDeleteConfirm(false)}>Cancel</button>
              <button className="rounded-lg bg-rose-600 px-3 py-2 text-sm font-semibold text-white hover:bg-rose-700" onClick={remove}>Delete</button>
            </div>
          </div>
        </div>
      ) : null}
      <SaveSuccessDialog open={showSaveDialog} onClose={() => setShowSaveDialog(false)} />
    </main>
  );
}
