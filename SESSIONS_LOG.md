# SESSIONS_LOG.md

## Session Date
- 2026-05-19 (Europe/Dublin)

## Project Context
- Project: `Syntec_ReactPHP`
- Objective: Rebuild `https://www.syntec.ie` (Oracle APEX public site) as a modern React + PHP + MySQL application.
- Oracle APEX is treated as a functional/visual reference only, not architecture to replicate.

## Confirmed Architectural Rules
- Frontend: React (Vite) with JavaScript (not TypeScript).
- Styling: Tailwind CSS v4.
- Routing: React Router.
- Backend: PHP APIs returning JSON only (no server-rendered frontend HTML).
- Database: MySQL is source of truth from day one.
- Assets: Filesystem-based images/docs; DB stores file paths only.
- Avoid JSON as long-term source of truth.
- Keep codebase/elements ecommerce-ready without building ecommerce now.

## Hosting / Environment Model
- Local frontend dev on `http://localhost:5173`.
- Frontend calls hosted PHP APIs + MySQL on Register365.
- Use `.env` placeholder config including `VITE_API_BASE_URL`.
- Temporary shared hosting path pattern expected:
  - `/public_html/syntec-dev/` with isolated folders (`api`, `admin`, `assets`, `uploads`).
- Use Syntec-prefixed tables only (e.g., `syntec_products`, `syntec_suppliers`, etc.).

## What Was Asked and Agreed
- Assistant can see and follow `AGENTS.md` instructions.
- Assistant summarized understanding of:
  - migration scope,
  - architecture,
  - features,
  - constraints,
  - phase-1 build targets.
- User provided initial implementation preferences:
  - JavaScript
  - Tailwind v4
  - `.env` placeholders for API base URL
- Assistant must wait for user to provide legacy directories before scaffolding.

## Legacy Reference Inputs (Planned)
User will provide:
- Legacy CSS directory
- Legacy JS directory
- Logos and image directories

Rules agreed:
- Legacy CSS/JS are reference-only.
- Extract design tokens/patterns (colors, spacing, typography, interaction cues).
- Do not blindly import legacy CSS/JS.
- Copy only required images into new project as needed.
- Keep legacy files separated from new implementation.

## Visual / Functional Reference Sources
- Live site reference confirmed: `https://www.syntec.ie`
- Note from user: site was largely built on the Superfine template.
- Superfine should be treated as visual reference only, not copied architecture/code.

## APEX Export Guidance Agreed
- Full APEX app export is useful and preferred first input.
- Region-by-region details are also valuable, especially:
  - dynamic SQL assembled in PL/SQL,
  - called Oracle procedures/functions/packages,
  - visibility/condition logic.
- Most valuable extraction targets:
  - menu hierarchy/visibility rules,
  - page-region content mapping,
  - lookups (suppliers/categories/applications),
  - business/visibility/filter rules,
  - legacy URL patterns for redirects.

## Initial Starter Scope Agreed
User can provide starter package containing:
- Header region SQL/logic + related procs/functions.
- Footer region SQL/logic + related procs/functions.
- Page 1 (home) regions and SQL/PLSQL sources + conditions.
- Related assets and page-specific CSS/JS.

## Phase 1 Scaffold Target (When User Says Proceed)
- Vite React scaffold
- Tailwind v4 setup
- Routing shell
- API config layer
- Layout structure
- Responsive header
- DB-driven menu API contract
- Mega menu component
- Mobile menu component
- Footer
- Placeholder pages:
  - Home
  - Suppliers
  - Products

## Current Status
- Awaiting user-provided legacy/reference directories and/or APEX export/region content.
- No scaffold implementation started yet per user instruction to wait.
