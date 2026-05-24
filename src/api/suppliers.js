import { buildApiUrl } from "./config";

export async function fetchSuppliers() {
  const response = await fetch(buildApiUrl("suppliers.php?include_inactive=1"));
  if (!response.ok) {
    throw new Error(`Suppliers API failed with ${response.status}`);
  }
  const payload = await response.json();
  if (!payload?.ok || !Array.isArray(payload.suppliers)) {
    throw new Error("Invalid suppliers payload");
  }
  return payload.suppliers;
}
