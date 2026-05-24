import { buildApiUrl } from './config';

export async function fetchProductsAdmin(lang) {
  const url = new URL(buildApiUrl('products-admin.php'));
  if (lang) url.searchParams.set('lang', lang);
  const res = await fetch(url);
  if (!res.ok) throw new Error('Failed to load products');
  return res.json();
}

export async function createProduct(payload, lang) {
  const url = new URL(buildApiUrl('products-admin.php'));
  if (lang) url.searchParams.set('lang', lang);
  const res = await fetch(url, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(payload),
  });
  if (!res.ok) throw new Error('Failed to create product');
  return res.json();
}

export async function updateProduct(payload, lang) {
  const url = new URL(buildApiUrl('products-admin.php'));
  if (lang) url.searchParams.set('lang', lang);
  const res = await fetch(url, {
    method: 'PUT',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(payload),
  });
  if (!res.ok) throw new Error('Failed to update product');
  return res.json();
}

export async function deleteProduct(productId) {
  const url = new URL(buildApiUrl('products-admin.php'));
  url.searchParams.set('product_id', String(productId));
  const res = await fetch(url, { method: 'DELETE' });
  if (!res.ok) throw new Error('Failed to delete product');
  return res.json();
}
