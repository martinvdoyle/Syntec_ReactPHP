import { useEffect, useMemo, useState } from "react";
import { createProduct, deleteProduct, fetchProductsAdmin, updateProduct } from "../api/productsAdmin";

const empty = {
  id: null,
  product_code: "",
  sku: "",
  name: "",
  slug: "",
  supplier_id: "",
  short_description: "",
  long_description: "",
  category_summary: "",
  primary_image_path: "",
  external_url: "",
  active_flag: "1",
  featured_flag: "0",
  sort_order: "0",
};

export default function ProductsAdminPage() {
  const [items, setItems] = useState([]);
  const [selectedId, setSelectedId] = useState(null);
  const [form, setForm] = useState(empty);
  const [isNew, setIsNew] = useState(false);

  const load = async () => {
    const data = await fetchProductsAdmin();
    setItems(data.items || []);
  };

  useEffect(() => { load(); }, []);

  const selected = useMemo(() => items.find((x) => x.id === selectedId) || null, [items, selectedId]);

  useEffect(() => {
    if (!selected) return;
    setForm({ ...empty, ...selected, supplier_id: selected.supplier_id ?? "", active_flag: String(selected.active_flag ?? 1), featured_flag: String(selected.featured_flag ?? 0), sort_order: String(selected.sort_order ?? 0) });
    setIsNew(false);
  }, [selected]);

  const f = (k, v) => setForm((prev) => ({ ...prev, [k]: v }));

  const save = async () => {
    if (isNew) await createProduct(form);
    else await updateProduct(form);
    await load();
  };

  const remove = async () => {
    if (!form.id) return;
    if (!window.confirm("Delete this product?")) return;
    await deleteProduct(form.id);
    setForm(empty);
    setSelectedId(null);
    await load();
  };

  return (
    <main className="mx-auto max-w-[1400px] p-4">
      <h1 className="mb-1 text-2xl font-bold">Admin: Products</h1>
      <p className="mb-4 text-sm text-slate-600">Initial products CRUD. Supplier dropdowns and related-code poplists will be added after parent tables are imported.</p>

      <div className="mb-4 flex flex-wrap gap-2 rounded border bg-white p-3">
        <a className="rounded bg-slate-100 px-3 py-1 text-sm text-slate-600" href="/admin/menu">Menu</a>
        <a className="rounded bg-blue-700 px-3 py-1 text-sm font-semibold text-white" href="/admin/products">Products</a>
        <span className="rounded bg-slate-100 px-3 py-1 text-sm text-slate-500">Suppliers (coming)</span>
      </div>

      <div className="grid grid-cols-1 gap-4 lg:grid-cols-[1fr_1.2fr]">
        <section className="rounded border bg-white p-3">
          <div className="mb-2">
            <button className="rounded bg-blue-600 px-3 py-1 text-white" onClick={() => { setIsNew(true); setSelectedId(null); setForm(empty); }}>New Product</button>
          </div>
          <ul className="space-y-1">
            {items.map((it) => (
              <li key={it.id}>
                <button className={`w-full rounded px-2 py-1 text-left text-sm ${selectedId === it.id ? "bg-blue-100 text-blue-900" : "hover:bg-slate-100"}`} onClick={() => setSelectedId(it.id)}>
                  <span className="font-semibold">{it.product_code || "(no code)"}</span> - {it.name}
                </button>
              </li>
            ))}
          </ul>
        </section>

        <section className="rounded border bg-white p-3">
          <h2 className="mb-3 text-lg font-semibold">{isNew ? "Create Product" : "Edit Product"}</h2>
          <div className="grid grid-cols-2 gap-2 text-sm">
            {[
              ["product_code", "PRODUCT_CODE"], ["sku", "SKU"], ["name", "NAME"], ["slug", "SLUG"],
              ["supplier_id", "SUPPLIER_ID"], ["sort_order", "SORT_ORDER"], ["primary_image_path", "PRIMARY_IMAGE_PATH"], ["external_url", "EXTERNAL_URL"],
              ["category_summary", "CATEGORY_SUMMARY"], ["short_description", "SHORT_DESCRIPTION"], ["long_description", "LONG_DESCRIPTION"],
            ].map(([k, lbl]) => (
              <label key={k} className="flex flex-col gap-1">
                <span className="text-xs font-semibold text-slate-600">{lbl}</span>
                <input className="rounded border px-2 py-1" value={form[k] ?? ""} onChange={(e) => f(k, e.target.value)} />
              </label>
            ))}

            <label className="flex flex-col gap-1">
              <span className="text-xs font-semibold text-slate-600">ACTIVE_FLAG</span>
              <label className="inline-flex items-center gap-2 text-sm"><input type="checkbox" checked={form.active_flag === "1"} onChange={(e) => f("active_flag", e.target.checked ? "1" : "0")} /><span>{form.active_flag === "1" ? "Y" : "N"}</span></label>
            </label>
            <label className="flex flex-col gap-1">
              <span className="text-xs font-semibold text-slate-600">FEATURED_FLAG</span>
              <label className="inline-flex items-center gap-2 text-sm"><input type="checkbox" checked={form.featured_flag === "1"} onChange={(e) => f("featured_flag", e.target.checked ? "1" : "0")} /><span>{form.featured_flag === "1" ? "Y" : "N"}</span></label>
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
