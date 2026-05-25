import { useEffect, useMemo, useState } from "react";
import { renderToStaticMarkup } from "react-dom/server";
import * as LucideIcons from "lucide-react";
import * as TablerIcons from "@tabler/icons-react";
import { buildApiUrl } from "../api/config";
import "../styles/legacy-content.css";

export default function ProductsPage() {
  const [discipline, setDiscipline] = useState("All");
  const [group, setGroup] = useState("All");
  const [query, setQuery] = useState("");
  const [products, setProducts] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState("");
  const [activeProduct, setActiveProduct] = useState(null);
  const [showEnquiry, setShowEnquiry] = useState(false);
  const [enquirySent, setEnquirySent] = useState(false);
  const [enquiryForm, setEnquiryForm] = useState({ name: "", company: "", email: "", message: "" });

  const toProductImageUrl = (rawValue) => {
    const rawImage = String(rawValue || "").trim();
    if (!rawImage) return "/assets/images/images_misc/Misc_77.jpg";
    if (rawImage.startsWith("http")) return rawImage;
    const raw = rawImage.replace(/^\/+/, "");
    if (raw.startsWith("assets/")) return `/${raw}`;
    if (raw.startsWith("images/")) return `/assets/${raw}`;
    if (raw.startsWith("Scientific/suppliers/")) return `/assets/images/${raw}`;
    if (raw.startsWith("suppliers/")) return `/assets/images/${raw}`;
    return `/assets/images/Scientific/suppliers/${raw}`;
  };

  useEffect(() => {
    let mounted = true;
    setLoading(true);
    fetch(buildApiUrl("products-admin.php?lang=en"))
      .then(async (res) => {
        const data = await res.json().catch(() => ({}));
        if (!res.ok || data?.ok === false) throw new Error(data?.error || "Failed to load products.");
        const all = Array.isArray(data?.items) ? data.items : [];
        const syntecScientific = all.filter((p) => String(p.business || "").trim() === "Syntec Scientific");
        const normalized = syntecScientific.map((p) => ({
          id: p.product_id,
          name: p.product_name || "(no name)",
          discipline: p.discipline || "(no discipline)",
          group: p.product_group || "(no group)",
          supplier: p.supplier_name_join || p.supplier_id || "(no supplier)",
          about: String(p.about_2 || p.about_1 || ""),
          aboutHtml: String(p.about_1 || ""),
          supplierLogo: p.supplier_logo_small || p.supplier_logo_large || "",
          image: toProductImageUrl(p.product_image_display || p.product_image_1 || p.product_image_large),
        }));
        if (mounted) {
          setProducts(normalized);
          setError("");
        }
      })
      .catch((e) => {
        if (mounted) setError(e?.message || "Failed to load products.");
      })
      .finally(() => {
        if (mounted) setLoading(false);
      });
    return () => {
      mounted = false;
    };
  }, []);

  const disciplines = useMemo(() => ["All", ...Array.from(new Set(products.map((p) => p.discipline)))], [products]);
  const groups = useMemo(() => {
    const src = discipline === "All" ? products : products.filter((p) => p.discipline === discipline);
    return ["All", ...Array.from(new Set(src.map((p) => p.group)))];
  }, [discipline, products]);

  const filtered = useMemo(() => {
    const q = query.trim().toLowerCase();
    return products.filter((p) => {
      if (discipline !== "All" && p.discipline !== discipline) return false;
      if (group !== "All" && p.group !== group) return false;
      if (!q) return true;
      return [p.id, p.name, p.supplier, p.group, p.discipline].some((v) => String(v).toLowerCase().includes(q));
    });
  }, [discipline, group, query, products]);

  const toSupplierLogoUrl = (rawValue) => {
    const rawLogo = String(rawValue || "").trim();
    if (!rawLogo) return "";
    if (rawLogo.startsWith("http")) return rawLogo;
    const raw = rawLogo.replace(/^\/+/, "");
    if (raw.startsWith("assets/")) return `/${raw}`;
    if (raw.startsWith("images/")) return `/assets/${raw}`;
    if (raw.startsWith("Scientific/suppliers/")) return `/assets/images/${raw}`;
    if (raw.startsWith("suppliers/")) return `/assets/images/${raw}`;
    return `/assets/images/Scientific/suppliers/${raw}`;
  };

  const textSnippet = (htmlish) => {
    const plain = String(htmlish || "")
      .replace(/<[^>]+>/g, " ")
      .replace(/&nbsp;/g, " ")
      .replace(/\s+/g, " ")
      .trim();
    if (!plain) return "";
    return plain.length > 155 ? `${plain.slice(0, 155).trim()}...` : plain;
  };
  const decodeHtml = (raw) => {
    const s = String(raw || "");
    if (!s) return "";
    if (typeof document === "undefined") return s;
    if (s.includes("&lt;") || s.includes("&gt;") || s.includes("&amp;")) {
      const t = document.createElement("textarea");
      t.innerHTML = s;
      return t.value;
    }
    return s;
  };
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
  const renderRichHtml = (raw) => {
    const decoded = decodeHtml(raw);
    if (typeof DOMParser === "undefined") return decoded;
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
    return doc.body.innerHTML;
  };

  return (
    <section className="rounded border border-slate-300 bg-white shadow-sm">
      <div className="border-b border-slate-200 bg-gradient-to-r from-[#e9f2fb] to-[#f7fbff] px-6 py-8">
        <p className="text-xs font-bold uppercase tracking-[0.16em] text-[#2e78bc]">Syntec Scientific</p>
        <h1 className="mt-2 text-4xl font-black text-[#113255]">Products Catalogue</h1>
        <p className="mt-2 max-w-3xl text-slate-700">Discover premium scientific instruments, products and services organised by discipline and product group.</p>
      </div>

      <div className="grid gap-0 lg:grid-cols-[250px_1fr]">
        <aside className="border-b border-r border-slate-200 bg-[#f7fbff] p-5 lg:border-b-0">
          <h2 className="text-sm font-extrabold uppercase tracking-[0.1em] text-[#2d4a67]">Filter Products</h2>

          <label className="mt-4 block text-xs font-bold uppercase tracking-[0.08em] text-slate-600">Discipline</label>
          <select className="mt-1 h-10 w-full rounded border border-slate-300 bg-white px-2 text-sm" value={discipline} onChange={(e) => { setDiscipline(e.target.value); setGroup("All"); }}>
            {disciplines.map((d) => <option key={d} value={d}>{d}</option>)}
          </select>

          <label className="mt-4 block text-xs font-bold uppercase tracking-[0.08em] text-slate-600">Product Group</label>
          <select className="mt-1 h-10 w-full rounded border border-slate-300 bg-white px-2 text-sm" value={group} onChange={(e) => setGroup(e.target.value)}>
            {groups.map((g) => <option key={g} value={g}>{g}</option>)}
          </select>

          <label className="mt-4 block text-xs font-bold uppercase tracking-[0.08em] text-slate-600">Search</label>
          <input className="mt-1 h-10 w-full rounded border border-slate-300 bg-white px-2 text-sm" placeholder="Name, SKU, supplier..." value={query} onChange={(e) => setQuery(e.target.value)} />
        </aside>

        <div className="p-5">
          <div className="mb-4 flex items-center justify-between">
            <h3 className="text-lg font-bold text-[#173a61]">Syntec Scientific Products</h3>
            <span className="rounded-full bg-[#e8f3ff] px-3 py-1 text-xs font-bold text-[#2e78bc]">{filtered.length} results</span>
          </div>
          {loading ? <p className="mb-4 text-sm text-slate-600">Loading products...</p> : null}
          {error ? <p className="mb-4 text-sm text-rose-700">{error}</p> : null}

          <div className="grid gap-4 sm:grid-cols-2 xl:grid-cols-3">
            {filtered.map((p) => (
              <article key={p.id} className="group flex h-full flex-col overflow-hidden rounded border border-slate-200 bg-white shadow-sm transition hover:-translate-y-0.5 hover:shadow-md">
                <div className="h-56 w-full bg-slate-100 p-3">
                  <img src={p.image} alt={p.name} className="h-full w-full object-contain" />
                </div>
                <div className="flex flex-1 flex-col p-3">
                  <div className="mb-2 flex flex-wrap gap-1">
                    <span className="rounded bg-[#e8f3ff] px-2 py-0.5 text-[10px] font-bold uppercase text-[#2e78bc]">{p.discipline}</span>
                    <span className="rounded bg-slate-100 px-2 py-0.5 text-[10px] font-bold uppercase text-slate-600">{p.group}</span>
                  </div>
                  <h4 className="line-clamp-2 text-base font-bold text-[#173a61]">{p.name}</h4>
                  <div className="mt-2 flex items-center justify-between gap-2">
                    <p className="text-sm text-slate-700">{p.supplier}</p>
                    {toSupplierLogoUrl(p.supplierLogo) ? (
                      <img
                        src={toSupplierLogoUrl(p.supplierLogo)}
                        alt={p.supplier}
                        className="h-8 w-auto max-w-[120px] object-contain"
                        onError={(e) => {
                          const fallback = toSupplierLogoUrl(p.supplierLogo).replace("/assets/images/Scientific/suppliers/", "/assets/images/");
                          if (e.currentTarget.src.endsWith(fallback)) {
                            e.currentTarget.style.display = "none";
                            return;
                          }
                          e.currentTarget.src = fallback;
                        }}
                      />
                    ) : null}
                  </div>
                  <p className="mt-2 min-h-[120px] text-sm leading-5 text-slate-700">{textSnippet(p.about)}</p>
                  <button
                    className="mt-auto w-full rounded bg-[#5ca2ea] px-3 py-2 text-sm font-bold text-white transition hover:bg-[#4a92dc]"
                    onClick={() => setActiveProduct(p)}
                  >
                    View Product
                  </button>
                </div>
              </article>
            ))}
          </div>
        </div>
      </div>

      {activeProduct ? (
        <div className="fixed inset-0 z-50 flex">
          <button
            type="button"
            aria-label="Close product drawer"
            className="h-full w-full bg-slate-900/45"
            onClick={() => setActiveProduct(null)}
          />
          <aside className="h-full w-full max-w-[560px] overflow-y-auto border-l border-slate-300 bg-white shadow-2xl animate-[slideIn_.28s_ease-out]">
            <div className="sticky top-0 z-10 flex items-center justify-between border-b border-slate-200 bg-white px-5 py-4">
              <h3 className="text-xl font-bold text-[#173a61]">Product Details</h3>
              <button
                type="button"
                className="rounded border border-slate-300 px-3 py-1 text-sm font-semibold text-slate-700 hover:bg-slate-100"
                onClick={() => setActiveProduct(null)}
              >
                Close
              </button>
            </div>
            <div className="space-y-4 p-5">
              <div className="h-64 w-full rounded border border-slate-200 bg-slate-50 p-3">
                <img src={activeProduct.image} alt={activeProduct.name} className="h-full w-full object-contain" />
              </div>
              <div className="flex flex-wrap gap-2">
                <span className="rounded bg-[#e8f3ff] px-2 py-0.5 text-[10px] font-bold uppercase text-[#2e78bc]">{activeProduct.discipline}</span>
                <span className="rounded bg-slate-100 px-2 py-0.5 text-[10px] font-bold uppercase text-slate-600">{activeProduct.group}</span>
              </div>
              <h4 className="text-2xl font-black text-[#173a61]">{activeProduct.name}</h4>
              <div className="flex items-center justify-between gap-3">
                <p className="text-base text-slate-700">{activeProduct.supplier}</p>
                {toSupplierLogoUrl(activeProduct.supplierLogo) ? (
                  <img src={toSupplierLogoUrl(activeProduct.supplierLogo)} alt={activeProduct.supplier} className="h-9 w-auto max-w-[140px] object-contain" />
                ) : null}
              </div>
              {activeProduct.aboutHtml ? (
                <div
                  className="legacy-products-content max-w-none text-slate-700"
                  dangerouslySetInnerHTML={{ __html: renderRichHtml(activeProduct.aboutHtml) }}
                />
              ) : (
                <p className="text-sm leading-6 text-slate-700">{textSnippet(activeProduct.about)}</p>
              )}
              <button
                className="w-full rounded bg-[#5ca2ea] px-3 py-2 text-sm font-bold text-white transition hover:bg-[#4a92dc]"
                onClick={() => {
                  setShowEnquiry(true);
                  setEnquirySent(false);
                  setEnquiryForm((prev) => ({
                    ...prev,
                    message: prev.message || `Enquiry about: ${activeProduct.name} (${activeProduct.id})`,
                  }));
                }}
              >
                Enquire About This Product
              </button>
            </div>
          </aside>
        </div>
      ) : null}
      {showEnquiry && activeProduct ? (
        <div className="fixed inset-0 z-[60] flex items-center justify-center p-4">
          <button type="button" className="absolute inset-0 bg-slate-900/50" onClick={() => setShowEnquiry(false)} aria-label="Close enquiry form" />
          <div className="relative z-10 w-full max-w-[560px] rounded-lg border border-slate-300 bg-white p-5 shadow-2xl">
            <div className="mb-3 flex items-center justify-between">
              <h4 className="text-lg font-bold text-[#173a61]">Product Enquiry</h4>
              <button className="rounded border border-slate-300 px-2 py-1 text-xs font-semibold text-slate-700" onClick={() => setShowEnquiry(false)}>Close</button>
            </div>
            <p className="mb-3 text-sm text-slate-600">{activeProduct.name}</p>
            {enquirySent ? (
              <div className="rounded border border-emerald-300 bg-emerald-50 px-3 py-2 text-sm text-emerald-800">
                Enquiry captured. Next step is wiring to the final contact API endpoint.
              </div>
            ) : (
              <form
                className="space-y-2"
                onSubmit={(e) => {
                  e.preventDefault();
                  setEnquirySent(true);
                }}
              >
                <input className="w-full rounded border border-slate-300 px-3 py-2 text-sm" placeholder="Your name" value={enquiryForm.name} onChange={(e) => setEnquiryForm((p) => ({ ...p, name: e.target.value }))} required />
                <input className="w-full rounded border border-slate-300 px-3 py-2 text-sm" placeholder="Company" value={enquiryForm.company} onChange={(e) => setEnquiryForm((p) => ({ ...p, company: e.target.value }))} />
                <input className="w-full rounded border border-slate-300 px-3 py-2 text-sm" type="email" placeholder="Email" value={enquiryForm.email} onChange={(e) => setEnquiryForm((p) => ({ ...p, email: e.target.value }))} required />
                <textarea className="min-h-[120px] w-full rounded border border-slate-300 px-3 py-2 text-sm" placeholder="Message" value={enquiryForm.message} onChange={(e) => setEnquiryForm((p) => ({ ...p, message: e.target.value }))} required />
                <button className="w-full rounded bg-[#5ca2ea] px-3 py-2 text-sm font-bold text-white transition hover:bg-[#4a92dc]" type="submit">Send Enquiry</button>
              </form>
            )}
          </div>
        </div>
      ) : null}
      <style>{`@keyframes slideIn { from { transform: translateX(100%); } to { transform: translateX(0); } }`}</style>
    </section>
  );
}
