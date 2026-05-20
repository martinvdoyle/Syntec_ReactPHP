import { buildApiUrl } from "./config";

const fallbackSuppliers = [
  {
    id: 1,
    name: "Syntec Scientific",
    slug: "syntec-scientific",
    shortDescription: "Scientific diagnostic suppliers and brands.",
    websiteUrl: "https://www.syntec.ie",
    logoPath: "/assets/images/Syntec_Scientific_Logo_Small.png",
    businessUnit: "Scientific",
    active: true,
  },
  {
    id: 2,
    name: "Syntec International",
    slug: "syntec-international",
    shortDescription: "International diagnostic and laboratory solutions.",
    websiteUrl: "https://www.syntec.ie",
    logoPath: "/assets/images/Syntec_International_Logo_Small.png",
    businessUnit: "International",
    active: true,
  },
  {
    id: 3,
    name: "SyS Laboratories",
    slug: "sys-laboratories",
    shortDescription: "Surgery and specialist laboratory product suppliers.",
    websiteUrl: "https://www.syntec.ie",
    logoPath: "/assets/images/Syntec_SysLabs_Logo_Small.png",
    businessUnit: "SysLabs",
    active: true,
  },
];

export async function fetchSuppliers() {
  try {
    const response = await fetch(buildApiUrl("suppliers.php"));
    if (!response.ok) {
      throw new Error(`Suppliers API failed with ${response.status}`);
    }

    const payload = await response.json();
    if (!payload?.ok || !Array.isArray(payload.suppliers)) {
      throw new Error("Invalid suppliers payload");
    }

    return payload.suppliers;
  } catch (error) {
    console.warn("Using fallback suppliers data:", error);
    return fallbackSuppliers;
  }
}
