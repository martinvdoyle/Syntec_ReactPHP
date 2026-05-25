import { buildApiUrl } from "./config";

export async function fetchLanguages() {
  const res = await fetch(buildApiUrl("languages-admin.php"));
  if (!res.ok) throw new Error("Failed to load languages");
  return res.json();
}

export async function fetchLanguageImpact(langCode) {
  const url = new URL(buildApiUrl("languages-admin.php"));
  url.searchParams.set("mode", "impact");
  url.searchParams.set("lang_code", langCode);
  const res = await fetch(url.toString());
  const data = await res.json().catch(() => ({}));
  if (!res.ok || data?.ok === false) throw new Error(data?.error || "Failed to load language impact");
  return data;
}

export async function createLanguage(payload) {
  const res = await fetch(buildApiUrl("languages-admin.php"), {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify(payload),
  });
  const data = await res.json();
  if (!res.ok || data?.ok === false) throw new Error(data?.error || `HTTP ${res.status}`);
  return data;
}

export async function deleteLanguage(langCode, confirm = false) {
  const url = new URL(buildApiUrl("languages-admin.php"));
  url.searchParams.set("lang_code", langCode);
  if (confirm) url.searchParams.set("confirm", "1");
  const res = await fetch(url.toString(), { method: "DELETE" });
  const data = await res.json();
  if (!res.ok || data?.ok === false) throw new Error(data?.error || `HTTP ${res.status}`);
  return data;
}
