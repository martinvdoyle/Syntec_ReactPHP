import { buildApiUrl } from "./config";

export async function fetchSuppliersAdmin(lang) {
  const url = new URL(buildApiUrl("suppliers-admin.php"));
  if (lang) url.searchParams.set("lang", lang);
  const res = await fetch(url);
  if (!res.ok) throw new Error("Failed to load suppliers");
  return res.json();
}

export async function createSupplier(payload, lang) {
  const url = new URL(buildApiUrl("suppliers-admin.php"));
  if (lang) url.searchParams.set("lang", lang);
  const res = await fetch(url, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify(payload),
  });
  const json = await res.json().catch(() => ({}));
  if (!res.ok || json?.ok === false) throw new Error(json?.error || "Failed to create supplier");
  return json;
}

export async function updateSupplier(payload, lang) {
  const url = new URL(buildApiUrl("suppliers-admin.php"));
  if (lang) url.searchParams.set("lang", lang);
  const res = await fetch(url, {
    method: "PUT",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify(payload),
  });
  const json = await res.json().catch(() => ({}));
  if (!res.ok || json?.ok === false) throw new Error(json?.error || "Failed to update supplier");
  return json;
}

export async function fetchSupplierFlagImpact({ supplier_id, active, deleted }) {
  const url = `${buildApiUrl("suppliers-admin.php")}?mode=impact&supplier_id=${encodeURIComponent(
    supplier_id
  )}&active=${encodeURIComponent(active ?? "Y")}&deleted=${encodeURIComponent(deleted ?? "N")}`;
  const res = await fetch(url);
  const json = await res.json().catch(() => ({}));
  if (!res.ok || json?.ok === false) throw new Error(json?.error || "Failed to load impact");
  return json?.impact || { total_products: 0, products_to_change: 0 };
}

export async function fetchSupplierImpact(payload) {
  const res = await fetch(buildApiUrl("suppliers-admin.php"), {
    method: "PUT",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ ...payload, impact_only: 1 }),
  });
  const json = await res.json().catch(() => ({}));
  if (!res.ok || json?.ok === false) throw new Error(json?.error || "Failed to get supplier impact");
  return json?.impact || { products_total: 0, products_changed: 0 };
}

export async function deleteSupplier(supplierId) {
  const res = await fetch(`${buildApiUrl("suppliers-admin.php")}?supplier_id=${encodeURIComponent(supplierId)}`, {
    method: "DELETE",
  });
  const json = await res.json().catch(() => ({}));
  if (!res.ok || json?.ok === false) throw new Error(json?.error || "Failed to delete supplier");
  return json;
}
