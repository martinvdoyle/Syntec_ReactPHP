import { buildApiUrl } from './config';

export async function fetchProductsAdmin() {
  const res = await fetch(buildApiUrl('products-admin.php'));
  if (!res.ok) throw new Error('Failed to load products');
  return res.json();
}

export async function createProduct(payload) {
  const res = await fetch(buildApiUrl('products-admin.php'), {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(payload),
  });
  if (!res.ok) throw new Error('Failed to create product');
  return res.json();
}

export async function updateProduct(payload) {
  const res = await fetch(buildApiUrl('products-admin.php'), {
    method: 'PUT',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(payload),
  });
  if (!res.ok) throw new Error('Failed to update product');
  return res.json();
}

export async function deleteProduct(id) {
  const url = new URL(buildApiUrl('products-admin.php'));
  url.searchParams.set('id', String(id));
  const res = await fetch(url, { method: 'DELETE' });
  if (!res.ok) throw new Error('Failed to delete product');
  return res.json();
}
