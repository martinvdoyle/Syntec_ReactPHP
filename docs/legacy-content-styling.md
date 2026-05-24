# Legacy Content Styling Strategy

## Purpose
This project stores HTML-rich legacy content in database fields (products now, suppliers later). Those HTML fragments contain historic classes that need styling support without leaking styles into the rest of the app.

## Implemented
- Shared stylesheet created: `src/styles/legacy-content.css`
- Product preview wrapper class: `legacy-products-content`
- Supplier wrapper class reserved: `legacy-suppliers-content`
- `ProductsAdminPage` imports shared stylesheet.

## Scope Rules
All legacy CSS must remain scoped under one of these wrappers:
- `.legacy-products-content ...`
- `.legacy-suppliers-content ...`

Do not add unscoped selectors for legacy classes.

## Current Coverage
The shared stylesheet includes baseline rules for common legacy classes/elements used in product HTML payloads:
- `.heading`
- `.heavy-font`
- `.main-color`
- `.panel-body`
- `.control-label`
- `.font-18`, `.font-20`
- `.center-bullet`
- paragraph spacing and table formatting

## Next Steps
1. Build cleaned class allowlist from DB HTML payloads.
2. Extract only matched selectors from legacy CSS into this scoped file.
3. Add supplier renderer wrapper with `.legacy-suppliers-content` when supplier HTML pages are built.
4. Keep icon rendering token-based (`icon-token lucide:*` / `tabler:*`) in JS, not CSS.
