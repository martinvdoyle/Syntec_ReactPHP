# AGENTS.md — Syntec.ie Rebuild Project

## Project Objective

Rebuild the current **Syntec.ie Oracle APEX public website** as a modern **React + PHP + MySQL** web application.

This is a complete rebuild of the public website, not a migration of Oracle APEX implementation patterns.

The Oracle APEX site should be treated as the **functional specification only**.

Primary goals:

- Remove dependency on Oracle APEX / OCI for public website hosting
- Reduce hosting/platform cost
- Improve developer productivity
- Enable proper VS Code + GitHub + ChatGPT Codex workflow
- Build a maintainable modern web architecture
- Allow future ecommerce expansion if required

---

# Existing Site

Current live site:

```text
https://www.syntec.ie
```

Current platform:

- Oracle APEX
- Oracle database
- PL/SQL functions/procedures generating HTML
- APEX-managed CSS/JS
- OCI/APEX hosting

Current issues:

- Approximate cost: **€140/month**
- ORDS / OCI routing complexity
- SSL / domain management complexity
- SQL Developer / wallet restrictions depending on OCI tier
- Frontend changes are slow and difficult
- CSS / JS tightly coupled inside APEX builder
- Menus and layout logic are difficult to maintain
- Poor fit for VS Code + GitHub + Codex workflow

---

# Current Site Features

The new site must eventually support:

- public brochure pages
- supplier catalogue
- product catalogue
- product search
- faceted filters
- product detail drawers
- contact drawers
- enquiry forms
- mega menus
- mobile menus
- header/footer
- brochures / PDF links
- supplier external links
- responsive layouts
- SEO-friendly URLs

Approximate data scale:

- 5,000–10,000 products
- ~20 suppliers
- low traffic
- occasional users
- no ecommerce currently
- possible ecommerce later

---

# Core Architecture

Use:

```text
React frontend
PHP API backend
MySQL database
Filesystem assets
```

MySQL is the **source of truth** from day one.

Do **not** use JSON as the long-term source of truth.

JSON may be used later only as generated cache/index output if useful.

---

# Development Workflow

The developer already successfully uses this pattern on the Luttrellstown React/PHP/MySQL project.

Default workflow:

```text
Local machine:
- VS Code
- React dev server
- localhost hot reload

Calls live APIs on:

Register365 hosting:
- PHP APIs
- MySQL database
```

Example:

```text
http://localhost:5173
      ↓
https://existing-hosting-domain.com/syntec-dev/api/products.php
      ↓
MySQL
```

This is the expected development pattern.

---

# Temporary Hosting Strategy

Initial Syntec development will piggyback on the existing Register365 hosting used for the Luttrellstown website.

This is temporary until a dedicated Syntec hosting package is purchased.

Syntec must be fully isolated.

Suggested folder:

```text
/public_html/syntec-dev/
```

Suggested backend structure:

```text
/public_html/syntec-dev/
    /api/
    /admin/
    /assets/
    /uploads/
```

Use Syntec-prefixed tables only:

```text
syntec_products
syntec_suppliers
syntec_categories
syntec_product_categories
syntec_applications
syntec_product_applications
syntec_product_images
syntec_product_documents
syntec_menu_items
syntec_pages
syntec_enquiries
```

Do not reuse Luttrellstown tables.

Do not mix configs.

Do not couple the codebases.

---

# Future Hosting Strategy

When ready:

1. Purchase dedicated Syntec hosting.
2. Export Syntec MySQL tables.
3. Copy Syntec PHP APIs.
4. Copy Syntec assets.
5. Deploy React build.
6. Change API base URL.
7. Point domain.
8. Retire APEX/OCI for the public site.

---

# Frontend Stack

Use:

- React
- Vite
- React Router
- Tailwind CSS
- shadcn/ui or Radix UI
- Floating UI where useful
- fetch or Axios

Icon libraries used for menu/navigation icons:

- Lucide gallery: https://lucide.dev/icons/
- Lucide React package: https://www.npmjs.com/package/lucide-react
- Tabler Icons gallery: https://tabler.io/icons
- Tabler React package: https://www.npmjs.com/package/@tabler/icons-react

Frontend responsibilities:

- public pages
- header
- footer
- mega menu
- mobile menu
- supplier listing
- supplier detail pages
- product listing
- product cards
- product detail drawer
- faceted search
- contact drawer
- enquiry forms
- responsive design

---

# Backend Stack

Use PHP APIs.

PHP responsibilities:

- product APIs
- supplier APIs
- category APIs
- application/filter APIs
- menu APIs
- page/content APIs
- contact/enquiry APIs
- mail integration
- reCAPTCHA validation
- future admin CRUD APIs
- future ecommerce APIs

PHP should return data.

PHP should not generate frontend HTML.

---

# MySQL Database

MySQL is the source of truth.

Initial schema should include:

```text
syntec_suppliers
syntec_categories
syntec_products
syntec_product_categories
syntec_applications
syntec_product_applications
syntec_product_images
syntec_product_documents
syntec_menu_items
syntec_pages
syntec_enquiries
```

Future ecommerce extension may include:

```text
syntec_customers
syntec_carts
syntec_cart_items
syntec_orders
syntec_order_items
syntec_payments
syntec_shipping_methods
syntec_tax_rates
```

Use stable product IDs/SKUs from day one.

---

# Asset Storage

Use filesystem assets only.

Do not store images or documents as database blobs.

Suggested structure:

```text
/assets/images/products/
/assets/images/suppliers/
/assets/images/logos/
/assets/images/banners/
/assets/docs/brochures/
/assets/docs/datasheets/
```

Database stores file paths only.

Example:

```text
/assets/images/products/cell-marque/cd3.webp
```

External supplier URLs and PDF links are acceptable.

---

# Existing Local Assets

The developer has a local directory containing current Syntec:

- CSS
- JavaScript
- images
- logos
- supplier assets
- banner assets
- static files

These assets may be used as reference material and migration input.

Important rules:

- Do not blindly import all old CSS.
- Do not blindly import all old JavaScript.
- Old CSS/JS may contain APEX/theme-specific rules.
- Extract useful colours, spacing, fonts, images, logos, and layout ideas.
- Rebuild interactions as React components.
- Keep legacy assets clearly separated.

Suggested structure:

```text
/public/assets/
   images/
      products/
      suppliers/
      logos/
      banners/
   docs/
      brochures/
      datasheets/
   legacy/
      reference-css/
      reference-js/
```

Use `/legacy/` as reference only unless explicitly approved.

---

# Oracle Export Source

All Oracle object exports for this project are stored in:

```text
C:\Websites\Syntec_ReactPHP\Oracle_Exports
```

Rules:

- Treat this folder as the default source for Oracle table data, constraints, DDL, and PL/SQL references.
- Before asking for export files, first check this folder for matching `*_DATA_TABLE.sql`, table DDL, and related constraint/index scripts.
- Use these files to generate MySQL staging import scripts and migration scripts.

---

# Oracle Header/Footer Functions

Current Syntec headers and footers are generated by Oracle PL/SQL functions.

Use these functions as visual/content reference only.

Do not convert them into PHP functions that generate HTML.

Old:

```text
Oracle function → generated header/footer HTML
```

New:

```text
MySQL/menu/content data → PHP API → React Header/Footer components
```

Create React components such as:

```text
src/components/layout/Header.jsx
src/components/layout/Footer.jsx
src/components/layout/MegaMenu.jsx
src/components/layout/MobileMenu.jsx
```

If Oracle functions contain useful logic, extract only data rules such as:

- menu hierarchy
- logo selection
- business unit selection
- contact details
- footer link groups
- social links
- supplier/category grouping
- active/visible flags

Do not preserve old generated HTML unless it is still desirable visually.

---

# Menu Architecture

Menus should be database-driven from day one.

Use:

```text
syntec_menu_items
```

Suggested fields:

```text
id
parent_id
title
url
route
icon
menu_type
description
image_path
sort_order
visible
target
css_class
created_at
updated_at
```

React should render menus recursively.

Menu types may include:

```text
standard
dropdown
mega
external
separator
heading
```

Must support:

- desktop mega menu
- dropdown menu
- mobile accordion menu
- nested menu levels
- supplier/category links
- visible/hidden flags
- sort order

Do not migrate old Oracle menu implementation directly.

Use old menu as reference only.

---

# Product Catalogue

Product catalogue should be database-driven.

Suggested product fields:

```text
id
supplier_id
product_code
sku
name
slug
short_description
long_description
category_summary
primary_image_path
external_url
active_flag
featured_flag
sort_order
created_at
updated_at
```

Use related tables for:

- categories
- applications
- images
- documents
- supplier links

Do not store multiple categories as delimited text if avoidable.

Use join tables.

---

# Faceted Search

Faceted search must support:

- 5,000–10,000 products
- supplier filters
- category filters
- application filters
- keyword search
- sorting
- pagination
- product cards
- mobile filters
- drawer opening from result cards

Recommended flow:

```text
React sends filters/search/page
        ↓
PHP queries MySQL
        ↓
PHP returns products + total + facets
        ↓
React renders cards
```

Example API:

```text
/api/products.php
```

Example response:

```json
{
  "products": [],
  "total": 2456,
  "page": 1,
  "pageSize": 24,
  "facets": {
    "suppliers": [],
    "categories": [],
    "applications": []
  }
}
```

Do not load all 10,000 products into the browser unnecessarily.

---

# Product Detail Drawer

Use reusable React drawer components.

Recommended:

- Radix UI Dialog
- shadcn/ui Sheet

Component examples:

```text
ProductDrawer
ContactDrawer
SupplierDrawer
```

Product drawer should load detailed product data as needed.

Drawer should support:

- desktop side drawer
- mobile full-screen drawer
- product image
- product metadata
- long description
- supplier URL
- PDF links
- enquiry button
- close button

---

# Contact / Enquiry Forms

Reuse the existing PHP mail engine where practical.

Must support:

- general contact form
- product enquiry form
- supplier enquiry form if needed
- reCAPTCHA
- email notification
- optional enquiry logging to MySQL

Suggested table:

```text
syntec_enquiries
```

Suggested fields:

```text
id
source_type
product_id
supplier_id
name
organisation
email
phone
subject
message
ip_address
user_agent
created_at
status
```

---

# SEO Requirements

Must preserve SEO where possible.

Requirements:

- clean URLs
- page slugs
- product slugs
- supplier slugs
- sitemap.xml
- robots.txt
- meta title
- meta description
- Open Graph tags
- 301 redirect mapping from old APEX URLs where needed

Old APEX URLs should be reviewed and mapped to new routes.

---

# Future Ecommerce Readiness

The site is catalogue/enquiry only at launch.

However, ecommerce may be added later.

Therefore:

- use MySQL from day one
- use stable product IDs/SKUs
- avoid JSON-only architecture
- keep products extensible
- keep PHP APIs clean
- avoid hardcoding “enquiry only” assumptions everywhere

Future ecommerce may require:

```text
customers
carts
orders
order_items
payments
shipping
tax
stock
pricing
discounts
```

Possible integrations:

- Stripe
- PayPal
- external ecommerce platform
- custom PHP checkout

Do not build ecommerce now unless explicitly requested.

Just avoid blocking it.

---

# API Design

Use REST-style PHP endpoints.

Examples:

```text
/api/products.php
/api/product.php?id=123
/api/suppliers.php
/api/supplier.php?slug=cell-marque
/api/categories.php
/api/menu.php
/api/contact.php
```

Future examples:

```text
/api/cart.php
/api/orders.php
/api/payments.php
```

API rules:

- validate input
- sanitize input
- use prepared statements
- return JSON
- return proper error messages
- avoid exposing sensitive config
- support CORS for local React dev

During development, allow:

```text
http://localhost:5173
```

Later lock CORS down.

---

# React Coding Standards

Do:

- use reusable components
- use clean folder structure
- separate layout, pages, components, hooks, API helpers
- keep components small where possible
- keep styling consistent
- use mobile-first design
- use accessibility-friendly components

Do not:

- create giant monolithic components
- duplicate menu logic
- duplicate drawer logic
- hardcode backend URLs everywhere
- mix old legacy JS directly into React components

Suggested structure:

```text
src/
  api/
  components/
    layout/
    menus/
    products/
    suppliers/
    drawers/
    forms/
  pages/
  hooks/
  utils/
  styles/
```

---

# PHP Coding Standards

Do:

- keep APIs modular
- use shared DB connection helper
- use prepared statements
- validate and sanitize input
- return JSON
- keep reusable helper functions
- keep mail logic isolated

Do not:

- generate frontend HTML
- mix unrelated endpoints
- expose database credentials
- rely on Oracle/APEX patterns

Suggested structure:

```text
/api/
  config/
    db.php
    cors.php
  products.php
  product.php
  suppliers.php
  menu.php
  contact.php
  helpers/
```

---

# MySQL Standards

Do:

- use `syntec_` prefix for all tables during shared hosting phase
- use indexes on searchable/filter fields
- normalize product-category/application mappings
- use stable slugs
- keep active flags
- keep created/updated timestamps

Suggested indexes:

```text
products.supplier_id
products.slug
products.name
products.product_code
products.active_flag
categories.slug
suppliers.slug
menu_items.parent_id
menu_items.sort_order
```

---

# Migration Strategy

Use Oracle APEX procedures/functions as reference only.

Old pattern:

```text
Oracle tables + PL/SQL → generated HTML
```

New pattern:

```text
MySQL → PHP API → React UI
```

Migration approach:

1. Review Oracle output.
2. Identify data/content/logic.
3. Design MySQL table if needed.
4. Build PHP API.
5. Build React component.
6. Compare visually with current live site.
7. Improve/simplify where sensible.

Do not copy Oracle complexity for the sake of matching implementation.

---

# Build Order

Recommended build order:

1. Vite React scaffold
2. Tailwind setup
3. API config layer
4. Layout shell
5. Header component
6. Database-driven menu API
7. Mega menu component
8. Mobile menu component
9. Footer component
10. Supplier listing
11. Supplier detail page
12. Product API
13. Product cards
14. Product detail drawer
15. Faceted search
16. Contact drawer
17. Mail integration
18. SEO metadata
19. Deployment build
20. Redirect mapping

---

# Codex Rules

Codex must assume:

- React frontend
- PHP APIs
- MySQL source of truth
- Register365 hosting
- local React dev calling live APIs
- temporary piggyback on Luttrellstown hosting
- future move to dedicated Syntec hosting
- future ecommerce possible
- existing Oracle site is only a reference/spec

Codex must not suggest:

- Oracle APEX
- Oracle dependency
- JSON as source of truth
- PHP-generated frontend HTML
- storing images in database blobs
- copying old CSS/JS wholesale
- recreating APEX architecture

---

# Immediate First Task

Build phase 1 scaffold:

- Vite React project
- Tailwind setup
- routing shell
- API config layer
- layout structure
- responsive header
- database-driven menu API contract
- mega menu component
- mobile menu component
- footer
- placeholder home page
- placeholder supplier page
- placeholder products page

This project prioritizes:

- maintainability
- speed of development
- low cost
- clean architecture
- Codex-friendly workflow
- future ecommerce readiness

---

# Current Handoff (2026-05-23)

Use this section as the first-read context for any new agent session.

## Current Working State

- Admin pages are live and working after several stability fixes.
- Products/Suppliers/Lookup admin pages now share consistent list UX:
  - search with icon + clear `X`
  - keyboard up/down list navigation
  - list counts (`Showing X of Y`)
  - centered save-success dialog
- Suppliers admin now has Products-style 3-panel layout with Live Preview.
- Supplier logo moved to preview panel and resized.

## Data/Parity Status

- Oracle parity effort is in advanced state for Syntec runtime tables.
- Legacy-style `products_view_all` logic was validated in MySQL at expected row count (`685`).
- Join/filter indexing for the view has been added/verified on key tables.

## Important Rules Reconfirmed

- Do not create hybrid columns.
- Keep Oracle column names and semantics unless explicitly instructed otherwise.
- Treat `Oracle_Exports` as canonical source for data/DDL parity work.

## Recent Backend Behavior

- `api/products-admin.php`:
  - list query includes supplier flags (`supplier_active`, `supplier_deleted`)
  - sorted by `supplier_name, product_name, product_id`
  - backend-only flag parity sync enabled:
    - product save propagates `active/deleted` to parent supplier and sibling products for same supplier
- `api/suppliers-admin.php`:
  - backend-only flag parity sync enabled:
    - supplier save propagates `active/deleted` to all child products
  - supports `impact_only=1` on PUT payload to return potential product impact counts

## Frontend Caution

- A previous supplier impact preflight flow caused a blank-screen incident and was rolled back, then reintroduced safely.
- If blank screen recurs, prioritize surgical rollback of newest frontend logic before touching schema/data scripts.

## Current Open Items

1. Verify supplier impact confirm flow works cleanly in deployed environment.
2. Keep admin UX aligned across pages while preserving existing working behavior.
3. Avoid broad refactors while migration hardening is ongoing.
