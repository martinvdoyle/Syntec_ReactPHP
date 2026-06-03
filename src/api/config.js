const browserOrigin = typeof window !== "undefined" ? window.location.origin : "";

export const API_BASE_URL =
  import.meta.env.VITE_API_BASE_URL || `${browserOrigin}/api`;

export const ASSET_BASE_URL =
  import.meta.env.VITE_ASSET_BASE_URL || browserOrigin;

export const buildApiUrl = (endpoint) => `${API_BASE_URL}/${endpoint}`;

export const normalizeAssetUrl = (value, options = {}) => {
  const rawValue = String(value || "").trim();
  if (!rawValue) return "";

  const { preserveAbsoluteExternal = false } = options;
  const isAbsoluteHttp = /^https?:\/\//i.test(rawValue);
  if (isAbsoluteHttp && preserveAbsoluteExternal) {
    const currentAssetOrigin = ASSET_BASE_URL ? new URL(ASSET_BASE_URL, browserOrigin || undefined).origin : "";
    const currentBrowserOrigin = browserOrigin || "";
    try {
      const valueOrigin = new URL(rawValue).origin;
      if (valueOrigin !== currentAssetOrigin && valueOrigin !== currentBrowserOrigin) {
        return rawValue;
      }
    } catch {
      return rawValue;
    }
  }

  const absoluteWithoutOrigin = rawValue.replace(/^https?:\/\/[^/]+/i, "");
  const raw = absoluteWithoutOrigin.replace(/^\/+/, "");
  const normalized = raw.startsWith("assets/")
    ? raw
    : raw.startsWith("images/")
      ? `assets/${raw}`
      : raw.startsWith("Scientific/suppliers/") || raw.startsWith("suppliers/")
        ? `assets/images/${raw}`
        : `assets/images/Scientific/suppliers/${raw}`;

  return `${ASSET_BASE_URL.replace(/\/+$/, "")}/${normalized}`;
};
