import { useEffect, useMemo, useState } from "react";
import { createLanguage, deleteLanguage, fetchLanguageImpact, fetchLanguages } from "../api/languagesAdmin";

const empty = { lang_code: "", lang_name: "", flag_path: "", is_active: "Y", sort_order: 100 };

export default function LanguagesAdminPage() {
  const [items, setItems] = useState([]);
  const [form, setForm] = useState(empty);
  const [selected, setSelected] = useState(null);
  const [isNew, setIsNew] = useState(true);
  const [error, setError] = useState("");

  const load = async () => {
    const r = await fetchLanguages();
    setItems(r?.items || []);
  };
  useEffect(() => { load().catch((e) => setError(e?.message || "Failed to load languages.")); }, []);

  const sorted = useMemo(() => [...items].sort((a, b) => (a.sort_order - b.sort_order) || String(a.lang_code).localeCompare(String(b.lang_code))), [items]);

  const onSelect = (row) => { setSelected(row.lang_code); setForm({ ...row }); setIsNew(false); };

  const onSave = async () => {
    try {
      setError("");
      const payload = {
        lang_code: String(form.lang_code || "").trim().toLowerCase(),
        lang_name: String(form.lang_name || "").trim(),
        flag_path: String(form.flag_path || "").trim(),
        is_active: String(form.is_active || "Y").toUpperCase() === "N" ? "N" : "Y",
        sort_order: Number(form.sort_order || 100),
      };
      if (!payload.lang_code) {
        setError("lang_code is required.");
        return;
      }
      if (!payload.lang_name) {
        setError("lang_name is required.");
        return;
      }
      const impact = await fetchLanguageImpact(payload.lang_code).catch(() => ({ impact: { i18n_rows: 0, by_table: {} } }));
      const lines = Object.entries(impact?.impact?.by_table || {}).map(([t, n]) => `${t}: ${n}`).join("\n");
      const ok = window.confirm(
        `Add/Update language ${payload.lang_code} (${payload.lang_name}).\n\n` +
        `Rows that may be seeded for this language:\nTotal: ${impact?.impact?.i18n_rows ?? 0}\n${lines}\n\nContinue?`
      );
      if (!ok) return;
      await createLanguage(payload);
      await load();
      setIsNew(false);
      setSelected(payload.lang_code);
    } catch (e) {
      setError(e?.message || "Save failed.");
    }
  };

  const onDelete = async () => {
    try {
      setError("");
      if (!form.lang_code) return;
      const pre = await deleteLanguage(form.lang_code, false);
      const lines = Object.entries(pre?.impact?.by_table || {}).map(([t, n]) => `${t}: ${n}`).join("\n");
      const ok = window.confirm(
        `Delete language ${form.lang_code}.\n\n` +
        `Impacted i18n rows:\nTotal: ${pre?.impact?.i18n_rows ?? 0}\n${lines}\n\nContinue?`
      );
      if (!ok) return;
      await deleteLanguage(form.lang_code, true);
      await load();
      setForm(empty);
      setSelected(null);
      setIsNew(true);
    } catch (e) {
      setError(e?.message || "Delete failed.");
    }
  };

  return (
    <main className="mx-auto max-w-[1780px] bg-slate-50 p-4">
      <h1 className="mb-1 text-3xl font-black tracking-tight text-slate-900">Admin: Languages</h1>
      <p className="mb-4 text-sm text-slate-700">Manage language codes and i18n propagation.</p>
      {error ? <div className="mb-3 rounded-lg border border-rose-300 bg-rose-50 px-3 py-2 text-sm text-rose-800">{error}</div> : null}
      <div className="mb-4 flex flex-wrap gap-2 rounded-xl border border-[#70A9E0] bg-[#5B9BE0] p-3 shadow-sm">
        <a className="rounded-lg border border-white/45 bg-[#4E8FD8] px-3 py-1 text-sm font-medium !text-white" href="/admin/menu">Menu</a>
        <a className="rounded-lg border border-white/45 bg-[#4E8FD8] px-3 py-1 text-sm font-medium !text-white" href="/admin/products">Products</a>
        <a className="rounded-lg border border-white/45 bg-[#4E8FD8] px-3 py-1 text-sm font-medium !text-white" href="/admin/suppliers">Suppliers</a>
        <a className="rounded-lg border border-white/45 bg-[#4E8FD8] px-3 py-1 text-sm font-medium !text-white" href="/admin/discipline">Discipline</a>
        <a className="rounded-lg border border-white/45 bg-[#4E8FD8] px-3 py-1 text-sm font-medium !text-white" href="/admin/product_group">Product Group</a>
        <a className="rounded-lg border border-white/45 bg-[#4E8FD8] px-3 py-1 text-sm font-medium !text-white" href="/admin/product_type">Product Type</a>
        <a className="rounded-lg border border-white/45 bg-[#4E8FD8] px-3 py-1 text-sm font-medium !text-white" href="/admin/divisions">Divisions</a>
        <a className="rounded-lg border border-white/45 bg-[#4E8FD8] px-3 py-1 text-sm font-medium !text-white" href="/admin/job_titles">Job Titles</a>
        <a className="rounded-lg border border-white/45 bg-[#4E8FD8] px-3 py-1 text-sm font-medium !text-white" href="/admin/message_enquiry_type">Enquiry Types</a>
        <a className="rounded-lg border border-white/45 bg-[#4E8FD8] px-3 py-1 text-sm font-medium !text-white" href="/admin/message_types">Message Types</a>
        <a className="rounded-lg border border-white/45 bg-[#4E8FD8] px-3 py-1 text-sm font-medium !text-white" href="/admin/sources">Sources</a>
        <a className="rounded-lg border border-white/45 bg-[#4E8FD8] px-3 py-1 text-sm font-medium !text-white" href="/admin/users">Users</a>
        <a className="rounded-lg border border-white/45 bg-[#4E8FD8] px-3 py-1 text-sm font-medium !text-white" href="/admin/messages">Messages</a>
        <a className="rounded-lg border border-white bg-white px-3 py-1 text-sm font-semibold text-black shadow" href="/admin/languages">Languages</a>
      </div>
      <div className="grid grid-cols-1 gap-4 xl:grid-cols-[320px_1.2fr]">
        <section className="rounded-xl border border-slate-200 bg-white p-3 shadow-sm">
          <button className="mb-2 rounded-lg bg-cyan-600 px-3 py-1 font-semibold text-white" onClick={() => { setError(""); setForm({ ...empty }); setSelected(null); setIsNew(true); }}>New</button>
          <ul className="max-h-[70vh] space-y-1 overflow-auto rounded-lg border border-slate-200 bg-slate-50 p-1.5 pr-1">
            {sorted.map((r) => (
              <li key={r.lang_code}>
                <button onClick={() => onSelect(r)} className={`w-full rounded-lg border-l-4 px-2 py-1.5 text-left ${selected === r.lang_code ? "border-l-cyan-700 bg-cyan-100" : "border-l-transparent hover:bg-slate-100"}`}>
                  <div className="font-semibold">{r.lang_name} ({r.lang_code})</div>
                </button>
              </li>
            ))}
          </ul>
        </section>
        <section className="rounded-xl border border-slate-200 bg-white p-4 shadow-sm">
          <div className="grid grid-cols-1 gap-2 md:grid-cols-2 text-sm">
            {["lang_code", "lang_name", "flag_path", "sort_order"].map((k) => (
              <label key={k} className="flex flex-col gap-1">
                <span className="text-[11px] font-bold uppercase tracking-[0.06em] text-slate-600">{k}</span>
                <input disabled={!isNew && k === "lang_code"} className="rounded-lg border border-slate-400 bg-slate-50 px-2 py-1.5" value={form[k] ?? ""} onChange={(e) => setForm((p) => ({ ...p, [k]: e.target.value }))} />
              </label>
            ))}
            <label className="flex flex-col gap-1">
              <span className="text-[11px] font-bold uppercase tracking-[0.06em] text-slate-600">is_active</span>
              <label className="inline-flex items-center gap-2"><input type="checkbox" checked={String(form.is_active ?? "Y").toUpperCase() === "Y"} onChange={(e) => setForm((p) => ({ ...p, is_active: e.target.checked ? "Y" : "N" }))} /><span>{String(form.is_active ?? "Y").toUpperCase()}</span></label>
            </label>
          </div>
          <div className="mt-4 flex gap-2">
            <button className="rounded-lg bg-emerald-600 px-4 py-2 text-sm font-semibold text-white" onClick={onSave}>Save</button>
            {!isNew ? <button className="rounded-lg bg-rose-600 px-4 py-2 text-sm font-semibold text-white" onClick={onDelete}>Delete</button> : null}
          </div>
        </section>
      </div>
    </main>
  );
}
