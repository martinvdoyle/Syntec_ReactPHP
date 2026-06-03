import { useEffect, useMemo, useRef, useState } from "react";
import { renderToStaticMarkup } from "react-dom/server";
import { useSearchParams } from "react-router-dom";
import * as LucideIcons from "lucide-react";
import * as TablerIcons from "@tabler/icons-react";
import { buildApiUrl } from "../api/config";
import "../styles/legacy-content.css";

export default function ProductsPage() {
  const [searchParams, setSearchParams] = useSearchParams();
  const [lang, setLang] = useState(() => localStorage.getItem("syntec_lang") || "en");
  const [business, setBusiness] = useState(() => searchParams.get("business") || "All");
  const [discipline, setDiscipline] = useState(() => searchParams.get("discipline_id") || "All");
  const [group, setGroup] = useState(() => searchParams.get("product_group_id") || "All");
  const [query, setQuery] = useState("");
  const [products, setProducts] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState("");
  const [activeProduct, setActiveProduct] = useState(null);
  const [drawerVisible, setDrawerVisible] = useState(false);
  const [showEnquiry, setShowEnquiry] = useState(false);
  const [enquirySent, setEnquirySent] = useState(false);
  const [enquiryForm, setEnquiryForm] = useState({ name: "", company: "", email: "", message: "" });
  const [visibleCount, setVisibleCount] = useState(60);
  const loadMoreRef = useRef(null);

  useEffect(() => {
    const onLanguageChange = (event) => {
      const nextLang = event?.detail || localStorage.getItem("syntec_lang") || "en";
      setLang(nextLang);
    };
    window.addEventListener("syntec-language-change", onLanguageChange);
    window.addEventListener("storage", onLanguageChange);
    return () => {
      window.removeEventListener("syntec-language-change", onLanguageChange);
      window.removeEventListener("storage", onLanguageChange);
    };
  }, []);

  useEffect(() => {
    if (activeProduct) {
      setDrawerVisible(false);
      const id = requestAnimationFrame(() => setDrawerVisible(true));
      return () => cancelAnimationFrame(id);
    }
    setDrawerVisible(false);
  }, [activeProduct]);

  useEffect(() => {
    setBusiness(searchParams.get("business") || "All");
    setDiscipline(searchParams.get("discipline_id") || "All");
    setGroup(searchParams.get("product_group_id") || "All");
  }, [searchParams]);

  const updateProductUrl = (next) => {
    const params = new URLSearchParams(searchParams);
    const nextBusiness = next.business ?? business;
    const nextDiscipline = next.discipline ?? discipline;
    const nextGroup = next.group ?? group;

    if (nextBusiness && nextBusiness !== "All") params.set("business", nextBusiness);
    else params.delete("business");

    if (nextDiscipline && nextDiscipline !== "All") params.set("discipline_id", nextDiscipline);
    else params.delete("discipline_id");

    if (nextGroup && nextGroup !== "All") params.set("product_group_id", nextGroup);
    else params.delete("product_group_id");

    setSearchParams(params, { replace: false });
  };

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
    fetch(buildApiUrl(`products-admin.php?lang=${encodeURIComponent(lang)}`))
      .then(async (res) => {
        const data = await res.json().catch(() => ({}));
        if (!res.ok || data?.ok === false) throw new Error(data?.error || "Failed to load products.");
        const all = Array.isArray(data?.items) ? data.items : [];
        const normalized = all.map((p) => ({
          id: p.product_id,
          name: p.product_name || "(no name)",
          business: String(p.business || "(no business)").trim(),
          discipline: p.discipline || "(no discipline)",
          disciplineId: String(p.discipline_id || "").trim(),
          group: p.product_group || "(no group)",
          groupId: String(p.product_group_id || "").trim(),
          supplier: p.supplier_name_join || p.supplier_id || "(no supplier)",
          about: String(p.about_2 || p.about_1 || ""),
          about1: String(p.about_1 || ""),
          about2: String(p.about_2 || ""),
          aboutHtml: String(p.about_1 || ""),
          productLink: String(p.product_link || ""),
          classColour: String(p.supplier_class_colour || p.class_colour || "").trim(),
          supplierLogo: p.supplier_logo_small || p.supplier_logo_large || "",
          image: toProductImageUrl(p.product_image_display || p.product_image_1 || p.product_image_large),
        }));
        if (mounted) {
          setProducts(normalized);
          setActiveProduct((prev) => (prev ? normalized.find((p) => p.id === prev.id) || prev : prev));
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
  }, [lang]);

  const disciplines = useMemo(() => {
    const src = business === "All" ? products : products.filter((p) => p.business === business);
    const seen = new Map();
    src.forEach((p) => {
      const key = p.disciplineId || p.discipline;
      if (key && !seen.has(key)) seen.set(key, p.discipline);
    });
    return [{ value: "All", label: "All" }, ...Array.from(seen, ([value, label]) => ({ value, label }))];
  }, [business, products]);
  const groups = useMemo(() => {
    const src = products.filter((p) => {
      if (business !== "All" && p.business !== business) return false;
      if (discipline !== "All" && (p.disciplineId || p.discipline) !== discipline) return false;
      return true;
    });
    const seen = new Map();
    src.forEach((p) => {
      const key = p.groupId || p.group;
      if (key && !seen.has(key)) seen.set(key, p.group);
    });
    return [{ value: "All", label: "All" }, ...Array.from(seen, ([value, label]) => ({ value, label }))];
  }, [business, discipline, products]);

  const filtered = useMemo(() => {
    const q = query.trim().toLowerCase();
    return products.filter((p) => {
      if (business !== "All" && p.business !== business) return false;
      if (discipline !== "All" && (p.disciplineId || p.discipline) !== discipline) return false;
      if (group !== "All" && (p.groupId || p.group) !== group) return false;
      if (!q) return true;
      return [p.id, p.name, p.supplier, p.group, p.discipline, p.business, p.about1, p.about2].some((v) => String(v).toLowerCase().includes(q));
    });
  }, [business, discipline, group, query, products]);

  const visibleProducts = useMemo(() => filtered.slice(0, visibleCount), [filtered, visibleCount]);
  const businessLabel = business === "All" ? "Syntec" : business;

  useEffect(() => {
    setVisibleCount(60);
  }, [business, discipline, group, query, lang]);

  useEffect(() => {
    const node = loadMoreRef.current;
    if (!node) return undefined;
    const observer = new IntersectionObserver(
      (entries) => {
        const entry = entries[0];
        if (!entry?.isIntersecting) return;
        setVisibleCount((prev) => Math.min(prev + 60, filtered.length));
      },
      { root: null, rootMargin: "600px 0px", threshold: 0.01 }
    );
    observer.observe(node);
    return () => observer.disconnect();
  }, [filtered.length]);

  const toggleLegacyAccordion = (event) => {
    const source = event.target instanceof Element ? event.target : event.target?.parentElement;
    if (!source) return;
    const trigger = source.closest("[data-toggle='collapse'], .panel-title a, .panel-heading, .panel-title");
    if (!trigger) return;
    event.preventDefault();
    const root = event.currentTarget;
    const panel = trigger.closest(".panel");
    const clickable = panel?.querySelector("[data-toggle='collapse'], .panel-title a") || trigger;
    const targetRef = (
      clickable.getAttribute("data-target") ||
      clickable.getAttribute("href") ||
      clickable.getAttribute("aria-controls") ||
      ""
    ).trim();
    const hashRef = targetRef.includes("#") ? `#${targetRef.split("#").pop()}` : targetRef;

    let target = null;
    if (hashRef.startsWith("#")) {
      try {
        target = root.querySelector(hashRef);
      } catch {
        target = null;
      }
    } else if (hashRef.startsWith(".") || hashRef.startsWith("[")) {
      try {
        target = panel?.querySelector(hashRef) || root.querySelector(hashRef);
      } catch {
        target = null;
      }
    }
    if (!target) {
      target = panel?.querySelector(".panel-collapse") || null;
    }
    if (!target) return;
    const isOpen = target.classList.contains("show") || target.classList.contains("in");
    target.classList.toggle("show", !isOpen);
    target.classList.toggle("in", !isOpen);
    target.style.height = "";
    target.style.display = !isOpen ? "block" : "none";
    target.setAttribute("aria-expanded", String(!isOpen));
    clickable.classList.toggle("collapsed", isOpen);
    clickable.setAttribute("aria-expanded", String(!isOpen));
    const triggerText = (clickable.textContent || trigger.textContent || "").toLowerCase();
    if (!isOpen && triggerText.includes("video")) {
      const panelBody = target.querySelector(".panel-body") || target;
      if (!panelBody.querySelector("video, iframe")) {
        const videos = extractLegacyMediaItems(activeProduct?.aboutHtml || "");
        if (videos.length) {
          const stack = document.createElement("div");
          stack.className = "legacy-video-stack";
          stack.style.display = "grid";
          stack.style.gap = "1rem";
          videos.forEach((media) => {
            if (!media.mp4) return;
            const item = document.createElement("div");
            item.className = "post-item legacy-video-item";
            item.innerHTML = `
              <div class="post-image" style="text-align: center;">
                <video ${media.poster ? `poster="${media.poster}"` : ""} controls style="display: block; width: 100%; max-width: 760px; height: auto; margin: 0 auto; background: #000;">
                  <source src="${media.mp4}" type="video/mp4">
                </video>
              </div>
            `;
            stack.appendChild(item);
          });
          if (stack.children.length) panelBody.appendChild(stack);
        }
      }
    }
  };

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
  const extractLegacyMediaItems = (raw) => {
    const decoded = decodeHtml(raw);
    const normalize = (value) =>
      String(value || "")
        .replace(/^#WORKSPACE_FILES#\/?assets\//i, "/assets/")
        .replace(/^#WORKSPACE_FILES#\/?images\//i, "/assets/images/")
        .replace(/ /g, "%20");
    const sourceMatches = [...decoded.matchAll(/(?:#WORKSPACE_FILES#\/?(?:assets|images)\/|\/assets\/)[^"'>]+?\.mp4/gi)].map((m) => normalize(m[0]));
    const posterMatches = [...decoded.matchAll(/(?:#WORKSPACE_FILES#\/?(?:assets|images)\/|\/assets\/)[^"'>]+?\.(?:jpg|jpeg|png|webp)/gi)].map((m) => normalize(m[0]));
    const seen = new Set();
    return sourceMatches
      .map((mp4, index) => ({
        mp4,
        poster: posterMatches[index] || posterMatches[0] || "",
      }))
      .filter((media) => {
        if (!media.mp4 || seen.has(media.mp4)) return false;
        seen.add(media.mp4);
        return true;
      });
  };
  const extractLegacyMedia = (raw) => {
    const first = extractLegacyMediaItems(raw)[0] || {};
    return {
      mp4: first.mp4 || "",
      poster: first.poster || "",
    };
  };
  const renderRichHtml = (raw) => {
    const decoded = decodeHtml(raw);
    if (typeof DOMParser === "undefined") return decoded;
    const sanitizedHtml = decoded
      .replace(/([a-zA-Z_:][\w:.-]*)\s*=\s*''([^']*?)''/g, '$1="$2"')
      .replace(/\b(src|href|poster)\s*=\s*''([^']*?)''/gi, '$1="$2"')
      .replace(/\b(src|href|poster)\s*=\s*""([^"]*?)""/gi, '$1="$2"');
    const parser = new DOMParser();
    const doc = parser.parseFromString(sanitizedHtml, "text/html");
    const normalizeLegacyAssetPath = (value) => {
      const rawPath = String(value || "")
        .trim()
        .replace(/^['"]+|['"]+$/g, "");
      if (!rawPath) return "";
      const withoutWorkspace = rawPath.replace(/^#WORKSPACE_FILES#\/?/i, "");
      if (withoutWorkspace === rawPath && (rawPath.startsWith("http") || rawPath.startsWith("mailto:") || rawPath.startsWith("#"))) return rawPath;
      const clean = withoutWorkspace.replace(/^\/+/, "");
      const localPath = clean.startsWith("assets/")
        ? `/${clean}`
        : clean.startsWith("images/")
          ? `/assets/${clean}`
          : clean.startsWith("Scientific/") || clean.startsWith("International/") || clean.startsWith("SysLabs/")
            ? `/assets/images/${clean}`
            : clean;
      return localPath.replace(/ /g, "%20");
    };
    doc.querySelectorAll("img[src]").forEach((el) => {
      const normalized = normalizeLegacyAssetPath(el.getAttribute("src"));
      if (normalized) el.setAttribute("src", normalized);
    });
    doc.querySelectorAll("source[src], video[src], iframe[src]").forEach((el) => {
      const normalized = normalizeLegacyAssetPath(el.getAttribute("src"));
      if (normalized) el.setAttribute("src", normalized);
    });
    doc.querySelectorAll("video[poster]").forEach((el) => {
      const normalized = normalizeLegacyAssetPath(el.getAttribute("poster"));
      if (normalized) el.setAttribute("poster", normalized);
    });
    doc.querySelectorAll(".panel-collapse").forEach((el) => {
      el.classList.remove("show", "in", "active");
      el.style.display = "none";
      el.setAttribute("aria-expanded", "false");
    });
    doc.querySelectorAll("[data-toggle='collapse'], .panel-title a").forEach((trigger) => {
      trigger.classList.add("collapsed");
      trigger.setAttribute("aria-expanded", "false");
    });
    Array.from(doc.querySelectorAll(".panel")).forEach((panel) => {
      const title = (panel.querySelector(".panel-title a, .panel-title")?.textContent || "").toLowerCase();
      if (!title.includes("video")) return;
      const label = (panel.querySelector(".panel-title a, .panel-title")?.textContent || "Video").trim();
      const details = doc.createElement("details");
      details.className = "legacy-video-details";
      const summary = doc.createElement("summary");
      summary.className = "legacy-video-summary";
      summary.innerHTML = `${iconSvgForToken("lucide:video") || ""}<span>${label}</span>`;
      const body = doc.createElement("div");
      body.className = "legacy-video-details-body";
      const stack = doc.createElement("div");
      stack.className = "legacy-video-stack";
      extractLegacyMediaItems(decoded).forEach((media) => {
        if (!media.mp4) return;
        const item = doc.createElement("div");
        item.className = "post-item legacy-video-item";
        item.innerHTML = `
          <div class="post-image" style="text-align: center;">
            <video ${media.poster ? `poster="${media.poster}"` : ""} controls style="display: block; width: 100%; max-width: 760px; height: auto; margin: 0 auto; background: #000;">
              <source src="${media.mp4}" type="video/mp4">
            </video>
          </div>
        `;
        stack.appendChild(item);
      });
      if (stack.children.length) {
        const misplaced = Array.from(panel.querySelectorAll("#specs, main-flip"));
        body.appendChild(stack);
        details.appendChild(summary);
        details.appendChild(body);
        panel.replaceWith(details);
        let insertAfter = details;
        misplaced.forEach((node) => {
          const parent = insertAfter.parentNode || doc.body;
          parent.insertBefore(node, insertAfter.nextSibling);
          insertAfter = node;
        });
      } else {
        panel.remove();
      }

      panel.querySelectorAll(".panel-body .panel-body").forEach((nestedBody) => {
        const parent = nestedBody.parentNode;
        if (!parent) return;
        while (nestedBody.firstChild) parent.insertBefore(nestedBody.firstChild, nestedBody);
        nestedBody.remove();
      });

      const accordion = panel.closest(".panel-group, .accordion") || panel;
      const misplaced = Array.from(panel.querySelectorAll("#specs, main-flip"));
      if (!misplaced.length) return;

      let insertAfter = accordion;
      misplaced.forEach((node) => {
        const parent = insertAfter.parentNode || doc.body;
        parent.insertBefore(node, insertAfter.nextSibling);
        insertAfter = node;
      });
    });
    doc.querySelectorAll("a[href]").forEach((el) => {
      const normalized = normalizeLegacyAssetPath(el.getAttribute("href"));
      if (normalized) el.setAttribute("href", normalized);
    });
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
    <section className="relative flex h-[calc(100vh-150px)] min-h-[560px] flex-col overflow-hidden rounded border border-slate-300 bg-white shadow-sm">
      <div className="border-b border-slate-200 bg-gradient-to-r from-[#e9f2fb] to-[#f7fbff] px-6 py-6">
        <p className="text-xs font-bold uppercase tracking-[0.16em] text-[#2e78bc]">{businessLabel}</p>
        <h1 className="mt-2 text-3xl font-black text-[#113255]">Products Catalogue</h1>
        <p className="mt-2 max-w-3xl text-slate-700">Discover premium scientific instruments, products and services organised by discipline and product group.</p>
      </div>

      <div className="relative grid min-h-0 flex-1 gap-0 overflow-hidden lg:grid-cols-[250px_1fr]">
        <aside className="overflow-y-auto border-b border-r border-slate-200 bg-[#f7fbff] p-5 lg:border-b-0">
          <h2 className="text-sm font-extrabold uppercase tracking-[0.1em] text-[#2d4a67]">Filter Products</h2>

          <label className="mt-4 block text-xs font-bold uppercase tracking-[0.08em] text-slate-600">Discipline</label>
          <select
            className="mt-1 h-9 w-full rounded border border-slate-300 bg-white px-2 text-sm"
            value={discipline}
            onChange={(e) => {
              setDiscipline(e.target.value);
              setGroup("All");
              updateProductUrl({ discipline: e.target.value, group: "All" });
            }}
          >
            {disciplines.map((d) => <option key={d.value} value={d.value}>{d.label}</option>)}
          </select>

          <label className="mt-4 block text-xs font-bold uppercase tracking-[0.08em] text-slate-600">Product Group</label>
          <select
            className="mt-1 h-9 w-full rounded border border-slate-300 bg-white px-2 text-sm"
            value={group}
            onChange={(e) => {
              setGroup(e.target.value);
              updateProductUrl({ group: e.target.value });
            }}
          >
            {groups.map((g) => <option key={g.value} value={g.value}>{g.label}</option>)}
          </select>

          <label className="mt-4 block text-xs font-bold uppercase tracking-[0.08em] text-slate-600">Search</label>
          <div className="relative mt-1">
            <LucideIcons.Search className="pointer-events-none absolute left-2 top-1/2 h-4 w-4 -translate-y-1/2 text-slate-400" />
            <input
              className="h-9 w-full rounded border border-slate-300 bg-white px-8 text-sm focus:border-cyan-500 focus:outline-none focus:ring-2 focus:ring-cyan-100"
              placeholder="Name, SKU, supplier..."
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
        </aside>

        <div className="min-h-0 overflow-y-auto p-5">
          <div className="mb-4 flex items-center justify-between">
            <h3 className="text-lg font-bold text-[#173a61]">{business === "All" ? "Syntec Products" : `${business} Products`}</h3>
            <span className="rounded-full bg-[#e8f3ff] px-3 py-1 text-xs font-bold text-[#2e78bc]">{filtered.length} results</span>
          </div>
          {loading ? <p className="mb-4 text-sm text-slate-600">Loading products...</p> : null}
          {error ? <p className="mb-4 text-sm text-rose-700">{error}</p> : null}

          <div className="grid gap-4 sm:grid-cols-2 xl:grid-cols-3">
            {visibleProducts.map((p) => (
              <article key={p.id} className="group flex h-full flex-col overflow-hidden rounded border border-slate-200 bg-white shadow-sm transition hover:-translate-y-0.5 hover:shadow-md">
                <div className="h-56 w-full border-b border-slate-200 bg-[linear-gradient(135deg,#f8fafc_0%,#f8fafc_45%,#eef2f7_100%)] p-3">
                  <img src={p.image} alt={p.name} className="h-full w-full object-contain" />
                </div>
                <div className="flex flex-1 flex-col p-3">
                  <div className="mb-2 flex flex-wrap justify-center gap-2">
                    <span className="rounded bg-[#e8f3ff] px-2.5 py-1 text-xs font-bold uppercase text-[#2e78bc]">{p.discipline}</span>
                    <span className="rounded bg-slate-100 px-2.5 py-1 text-xs font-bold uppercase text-slate-600">{p.group}</span>
                  </div>
                  <h4 className="line-clamp-2 border-l-[6px] border-[#5ca2ea] pl-2 text-base font-bold text-[#173a61]">{p.name}</h4>
                  <div className="mt-2 flex items-center justify-between gap-2">
                    <p className="text-sm font-semibold text-slate-900">{p.supplier}</p>
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
          {visibleCount < filtered.length ? (
            <div ref={loadMoreRef} className="py-6 text-center text-sm font-semibold text-slate-500">
              Loading more products...
            </div>
          ) : null}
          {activeProduct ? (
            <div className="absolute inset-0 z-50 overflow-hidden">
              <button
                type="button"
                aria-label="Close product drawer"
                className="absolute inset-0 bg-slate-900/35"
                onClick={() => setActiveProduct(null)}
              />
              <aside
                className={`absolute bottom-0 right-0 top-0 h-full w-full max-w-[760px] overflow-y-auto border-l border-[#c8d8e8] bg-white shadow-2xl transition-transform duration-300 ease-out ${
                  drawerVisible ? "translate-x-0" : "translate-x-full"
                }`}
              >
                <div className="sticky top-0 z-10 flex items-center justify-between gap-4 border-b border-slate-200 border-t-4 border-t-[#5ca2ea] bg-gradient-to-b from-[#f8fbff] to-[#eef4fa] px-5 py-3 shadow-[inset_0_1px_0_#ffffff]">
                  <div className="min-w-0 flex-1">
                    <h3 className="border-l-[6px] border-[#5ca2ea] pl-3 text-xl font-black leading-tight text-[#173a61]">{activeProduct.name}</h3>
                    <p className="mt-2 text-base font-bold text-slate-900">{activeProduct.supplier}</p>
                  </div>
                  {toSupplierLogoUrl(activeProduct.supplierLogo) ? (
                    <div className="hidden sm:flex h-16 min-w-[150px] items-center justify-center px-4">
                      <img src={toSupplierLogoUrl(activeProduct.supplierLogo)} alt={activeProduct.supplier} className="h-9 w-auto max-w-[130px] object-contain" />
                    </div>
                  ) : null}
                  {/^https?:\/\//i.test(String(activeProduct.productLink || "").trim()) ? (
                    <a
                      href={activeProduct.productLink}
                      target="_blank"
                      rel="noopener noreferrer"
                      title={`Open supplier page for ${activeProduct.name}`}
                      style={{ "--hover-bg": activeProduct.classColour || "#4a92dc" }}
                      className="group shrink-0 rounded-md bg-[#5ca2ea] px-3 py-2 text-sm font-semibold !text-white visited:!text-white shadow-sm transition hover:bg-[var(--hover-bg)]"
                    >
                      <span className="flex items-center gap-2 whitespace-nowrap">
                        <span className="group-hover:hidden">Supplier Info.</span>
                        <span className="hidden group-hover:inline">{activeProduct.name}</span>
                        <LucideIcons.ExternalLink className="h-4 w-4 group-hover:hidden" />
                        <LucideIcons.ArrowUpRight className="hidden h-4 w-4 group-hover:inline" />
                      </span>
                    </a>
                  ) : null}
                  <button
                    type="button"
                    className="shrink-0 rounded-md border border-slate-300 bg-white px-3 py-1.5 text-sm font-semibold text-slate-700 shadow-sm transition hover:border-[#5ca2ea] hover:bg-[#f4f9ff] hover:text-[#173a61]"
                    onClick={() => setActiveProduct(null)}
                  >
                    Close
                  </button>
                </div>
                <div className="space-y-4 p-5">
                  <div className="h-80 w-full rounded border border-slate-200 bg-[linear-gradient(135deg,#f8fafc_0%,#f8fafc_45%,#eef2f7_100%)] p-3">
                    <img src={activeProduct.image} alt={activeProduct.name} className="h-full w-full object-contain" />
                  </div>
                  <div className="flex flex-wrap justify-center gap-2">
                    <span className="rounded bg-[#e8f3ff] px-2.5 py-1 text-xs font-bold uppercase text-[#2e78bc]">{activeProduct.discipline}</span>
                    <span className="rounded bg-slate-100 px-2.5 py-1 text-xs font-bold uppercase text-slate-600">{activeProduct.group}</span>
                  </div>
                  {activeProduct.aboutHtml ? (
                    <>
                      {(() => {
                        const renderedAbout = renderRichHtml(activeProduct.aboutHtml);
                        return (
                          <>
                            <div
                              className="legacy-products-content max-w-none text-slate-700"
                              onClickCapture={toggleLegacyAccordion}
                              dangerouslySetInnerHTML={{ __html: renderedAbout }}
                            />
                          </>
                        );
                      })()}
                    </>
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
            <div className="absolute inset-0 z-[60] flex items-center justify-center p-4">
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
          </div>
      </div>
    </section>
  );
}
