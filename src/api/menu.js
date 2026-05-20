import { buildApiUrl } from "./config";

const fallbackMenu = [
  { id: 1, title: "Home", route: "/", menuType: "standard", sortOrder: 10, visible: true, children: [] },
  { id: 2, title: "Suppliers", route: "/suppliers", menuType: "mega", sortOrder: 20, visible: true, children: [] },
  { id: 3, title: "Products", route: "/products", menuType: "mega", sortOrder: 30, visible: true, children: [] },
  { id: 4, title: "Contact", route: "/contact", menuType: "standard", sortOrder: 40, visible: true, children: [] },
];

export async function fetchMenu({ business = "Ireland", website = "Syntec Scientific" } = {}) {
  try {
    const query = new URLSearchParams({
      business,
      website,
    }).toString();
    const response = await fetch(buildApiUrl(`menu.php?${query}`));
    if (!response.ok) {
      throw new Error(`Menu API failed with ${response.status}`);
    }

    const payload = await response.json();
    if (!payload?.ok || !Array.isArray(payload.tree)) {
      throw new Error("Invalid menu payload");
    }

    return payload.tree;
  } catch (error) {
    console.warn("Using fallback menu data:", error);
    return fallbackMenu;
  }
}
