import { buildApiUrl } from "./config";

const fallbackMenu = [
  { id: 1, title: "Home", route: "/", menuType: "standard", sortOrder: 10, visible: true },
  { id: 2, title: "Suppliers", route: "/suppliers", menuType: "mega", sortOrder: 20, visible: true },
  { id: 3, title: "Products", route: "/products", menuType: "mega", sortOrder: 30, visible: true },
  { id: 4, title: "Contact", route: "/contact", menuType: "standard", sortOrder: 40, visible: true },
];

export async function fetchMenu(menuKey = "main") {
  try {
    const response = await fetch(buildApiUrl(`menu.php?menu_key=${encodeURIComponent(menuKey)}`));
    if (!response.ok) {
      throw new Error(`Menu API failed with ${response.status}`);
    }

    const payload = await response.json();
    if (!payload?.ok || !Array.isArray(payload.items)) {
      throw new Error("Invalid menu payload");
    }

    return payload.items;
  } catch (error) {
    console.warn("Using fallback menu data:", error);
    return fallbackMenu;
  }
}
