import { buildApiUrl } from './config';

function withTable(table, lang) {
  const url = new URL(buildApiUrl('table-admin.php'));
  url.searchParams.set('table', table);
  if (lang) url.searchParams.set('lang', lang);
  return url;
}

export async function fetchTableAdmin(table, lang) {
  const res = await fetch(withTable(table, lang));
  if (!res.ok) throw new Error(`Failed to load ${table}`);
  return res.json();
}

export async function createTableRow(table, payload, lang) {
  const res = await fetch(withTable(table, lang), {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(payload),
  });
  if (!res.ok) throw new Error(`Failed to create row in ${table}`);
  return res.json();
}

export async function updateTableRow(table, payload, lang) {
  const res = await fetch(withTable(table, lang), {
    method: 'PUT',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(payload),
  });
  if (!res.ok) throw new Error(`Failed to update row in ${table}`);
  return res.json();
}

export async function deleteTableRow(table, keyName, keyValue, lang) {
  const url = withTable(table, lang);
  url.searchParams.set(keyName, String(keyValue));
  const res = await fetch(url, { method: 'DELETE' });
  if (!res.ok) throw new Error(`Failed to delete row in ${table}`);
  return res.json();
}
