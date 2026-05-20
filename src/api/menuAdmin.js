import { buildApiUrl } from './config';

export async function fetchMenuAdmin() {
  const res = await fetch(buildApiUrl('menu-admin.php'));
  if (!res.ok) throw new Error('Failed to load menu admin data');
  return res.json();
}

export async function fetchNextMenuId(parentMenuId) {
  const url = new URL(buildApiUrl('menu-admin.php'));
  url.searchParams.set('next_menu_id', '1');
  if (parentMenuId) url.searchParams.set('parent_menu_id', parentMenuId);
  const res = await fetch(url);
  if (!res.ok) throw new Error('Failed to suggest next menu id');
  return res.json();
}

export async function reorderMenuItem(id, direction) {
  const url = new URL(buildApiUrl("menu-admin.php"));
  url.searchParams.set("reorder", "1");
  url.searchParams.set("id", String(id));
  url.searchParams.set("direction", direction);
  const res = await fetch(url);
  if (!res.ok) throw new Error("Failed to reorder menu item");
  return res.json();
}

export async function createMenuItem(payload) {
  const res = await fetch(buildApiUrl('menu-admin.php'), {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(payload),
  });
  if (!res.ok) throw new Error('Failed to create menu item');
  return res.json();
}

export async function updateMenuItem(payload) {
  const res = await fetch(buildApiUrl('menu-admin.php'), {
    method: 'PUT',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(payload),
  });
  if (!res.ok) throw new Error('Failed to update menu item');
  return res.json();
}

export async function deleteMenuItem(id) {
  const url = new URL(buildApiUrl('menu-admin.php'));
  url.searchParams.set('id', String(id));
  const res = await fetch(url, { method: 'DELETE' });
  if (!res.ok) throw new Error('Failed to delete menu item');
  return res.json();
}
