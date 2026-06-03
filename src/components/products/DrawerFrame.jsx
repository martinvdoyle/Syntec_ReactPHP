import { useEffect, useState } from "react";
import * as LucideIcons from "lucide-react";

function ProductImagePanel({ imageUrl, imageAlt, imageBackgroundColor, name, supplier, supplierLogoUrl, discipline, group }) {
  const [magnifyActive, setMagnifyActive] = useState(false);

  useEffect(() => {
    if (!magnifyActive) return undefined;
    const release = () => setMagnifyActive(false);
    window.addEventListener("pointerup", release);
    window.addEventListener("pointercancel", release);
    return () => {
      window.removeEventListener("pointerup", release);
      window.removeEventListener("pointercancel", release);
    };
  }, [magnifyActive]);

  const handlePointerDown = (event) => {
    event.preventDefault();
    setMagnifyActive(true);
  };

  const handlePointerUp = () => {
    setMagnifyActive(false);
  };

  return (
    <>
      <div className="relative flex h-80 w-full items-center justify-center overflow-hidden rounded border border-slate-200 p-3" style={{ backgroundColor: imageBackgroundColor }}>
        {imageUrl ? (
          <>
            <img src={imageUrl} alt={imageAlt} className="block max-h-full max-w-full object-contain" />
            <button
              type="button"
              aria-label="Hold to magnify image"
              className="absolute bottom-2 right-2 inline-flex h-9 w-9 items-center justify-center rounded-full border border-slate-300 bg-white/95 text-slate-700 shadow-sm transition hover:border-[#5ca2ea] hover:text-[#173a61]"
              onPointerDown={handlePointerDown}
              onPointerUp={handlePointerUp}
              onPointerCancel={handlePointerUp}
            >
              <LucideIcons.Search className="h-4 w-4" />
            </button>
          </>
        ) : (
          <div className="flex h-full w-full items-center justify-center text-sm text-slate-500">No product image</div>
        )}
      </div>
      {imageUrl && magnifyActive ? (
        <div className="fixed inset-0 z-[100] flex items-center justify-center bg-slate-900/35 p-6">
          <div className="flex h-[min(82vh,900px)] w-full max-w-[min(1100px,calc(100vw-3rem))] flex-col overflow-hidden rounded-xl border border-slate-300 bg-white shadow-2xl">
            {supplierLogoUrl ? (
              <div className="flex items-center justify-center px-6 pt-6">
                <img src={supplierLogoUrl} alt={supplier} className="h-10 w-auto max-w-[180px] object-contain" />
              </div>
            ) : null}
            <div className="flex min-h-0 flex-1 items-center justify-center overflow-hidden px-10 pb-8 pt-6">
              <img src={imageUrl} alt={imageAlt} className="block max-h-full max-w-full object-contain" />
            </div>
            <div className="border-t border-slate-200 px-6 py-5 text-center">
              <div className="flex flex-wrap justify-center gap-2">
                <span className="rounded bg-[#e8f3ff] px-2.5 py-1 text-xs font-bold uppercase text-[#2e78bc]">{discipline}</span>
                <span className="rounded bg-slate-100 px-2.5 py-1 text-xs font-bold uppercase text-slate-600">{group}</span>
              </div>
              <h4 className="mt-3 text-xl font-black leading-tight text-[#173a61]">{name}</h4>
              <p className="mt-2 text-base font-bold text-slate-900">{supplier}</p>
            </div>
          </div>
        </div>
      ) : null}
    </>
  );
}

export default function DrawerFrame({
  name,
  supplier,
  supplierLogoUrl,
  productLink,
  hoverColor,
  imageUrl,
  imageBackgroundColor = "#F5F8FB",
  discipline,
  group,
  onClose,
  children,
  maxWidthClass = "max-w-[760px]",
  mode = "drawer",
}) {
  const hasProductLink = /^https?:\/\//i.test(String(productLink || "").trim());
  const body = (
    <div className="space-y-4 p-5">
      <ProductImagePanel imageUrl={imageUrl} imageAlt={name} imageBackgroundColor={imageBackgroundColor} name={name} supplier={supplier} supplierLogoUrl={supplierLogoUrl} discipline={discipline} group={group} />
      <div className="flex flex-wrap justify-center gap-2">
        <span className="rounded bg-[#e8f3ff] px-2.5 py-1 text-xs font-bold uppercase text-[#2e78bc]">{discipline}</span>
        <span className="rounded bg-slate-100 px-2.5 py-1 text-xs font-bold uppercase text-slate-600">{group}</span>
      </div>
      {children}
    </div>
  );

  if (mode === "preview") {
    return (
      <div className={`mx-auto w-full ${maxWidthClass} overflow-hidden rounded-xl border border-[#c8d8e8] bg-white shadow-sm`}>
        <div className="sticky top-0 z-10 flex items-center justify-between gap-4 border-b border-slate-200 border-t-4 border-t-[#5ca2ea] bg-gradient-to-b from-[#f8fbff] to-[#eef4fa] px-5 py-3 shadow-[inset_0_1px_0_#ffffff]">
          <div className="min-w-0 flex-1">
            <h3 className="border-l-[6px] border-[#5ca2ea] pl-3 text-xl font-black leading-tight text-[#173a61]">{name}</h3>
            <p className="mt-2 text-base font-bold text-slate-900">{supplier}</p>
          </div>
          {supplierLogoUrl ? (
            <div className="hidden sm:flex h-16 min-w-[150px] items-center justify-center px-4">
              <img src={supplierLogoUrl} alt={supplier} className="h-9 w-auto max-w-[130px] object-contain" />
            </div>
          ) : null}
          {hasProductLink ? (
            <a
              href={productLink}
              target="_blank"
              rel="noopener noreferrer"
              title={`Open supplier page for ${name}`}
              style={{ "--hover-bg": hoverColor || "#4a92dc" }}
              className="group shrink-0 rounded-md bg-[#5ca2ea] px-3 py-2 text-sm font-semibold !text-white visited:!text-white shadow-sm transition hover:bg-[var(--hover-bg)]"
            >
              <span className="flex items-center gap-2 whitespace-nowrap">
                <span className="group-hover:hidden">Supplier Info.</span>
                <span className="hidden group-hover:inline">{name}</span>
                <LucideIcons.ExternalLink className="h-4 w-4 group-hover:hidden" />
                <LucideIcons.ArrowUpRight className="hidden h-4 w-4 group-hover:inline" />
              </span>
            </a>
          ) : null}
        </div>
        {body}
      </div>
    );
  }

  return (
    <aside className={`absolute bottom-0 right-0 top-0 h-full w-full ${maxWidthClass} overflow-y-auto border-l border-[#c8d8e8] bg-white shadow-2xl`}>
      <div className="sticky top-0 z-10 flex items-center justify-between gap-4 border-b border-slate-200 border-t-4 border-t-[#5ca2ea] bg-gradient-to-b from-[#f8fbff] to-[#eef4fa] px-5 py-3 shadow-[inset_0_1px_0_#ffffff]">
        <div className="min-w-0 flex-1">
          <h3 className="border-l-[6px] border-[#5ca2ea] pl-3 text-xl font-black leading-tight text-[#173a61]">{name}</h3>
          <p className="mt-2 text-base font-bold text-slate-900">{supplier}</p>
        </div>
        {supplierLogoUrl ? (
          <div className="hidden sm:flex h-16 min-w-[150px] items-center justify-center px-4">
            <img src={supplierLogoUrl} alt={supplier} className="h-9 w-auto max-w-[130px] object-contain" />
          </div>
        ) : null}
        {hasProductLink ? (
          <a
            href={productLink}
            target="_blank"
            rel="noopener noreferrer"
            title={`Open supplier page for ${name}`}
            style={{ "--hover-bg": hoverColor || "#4a92dc" }}
            className="group shrink-0 rounded-md bg-[#5ca2ea] px-3 py-2 text-sm font-semibold !text-white visited:!text-white shadow-sm transition hover:bg-[var(--hover-bg)]"
          >
            <span className="flex items-center gap-2 whitespace-nowrap">
              <span className="group-hover:hidden">Supplier Info.</span>
              <span className="hidden group-hover:inline">{name}</span>
              <LucideIcons.ExternalLink className="h-4 w-4 group-hover:hidden" />
              <LucideIcons.ArrowUpRight className="hidden h-4 w-4 group-hover:inline" />
            </span>
          </a>
        ) : null}
        <button
          type="button"
          className="shrink-0 rounded-md border border-slate-300 bg-white px-3 py-1.5 text-sm font-semibold text-slate-700 shadow-sm transition hover:border-[#5ca2ea] hover:bg-[#f4f9ff] hover:text-[#173a61]"
          onClick={onClose}
        >
          Close
        </button>
      </div>
      {body}
    </aside>
  );
}
