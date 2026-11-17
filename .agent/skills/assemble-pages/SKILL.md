---
name: assemble-pages
command: "/assemble-pages target=\"[PAGE_ID]\""
description: "Lắp ráp các Component rỗng thành trang hoàn chỉnh. Bắt buộc giữ nguyên layout, text và mock data thật từ HTML gốc."
required_context:
  - "_bmad-output/planning-artifacts/prds/**/prd.md"
  - "_bmad-output/planning-artifacts/epics_logic.md"
  - "_bmad-output/project-context.md"
  - "_bmad-output/planning-artifacts/architecture/**/ARCHITECTURE-SPINE.md"
  - "system-graphs/graph-master.cypher"
  - "todo-components.md"
  - "todo-pages.md"
---

# SYSTEM PROMPT FOR AI AGENT

**Role:** Frontend Application Architect.
**Target:** Assemble the page/screen layout for `[PAGE_ID]` (or the next `- [ ]` page in `todo-pages.md` if `target` is omitted) using the extracted UI components.

## Workflow & Strict Execution Rules

1. **Sync `todo-pages.md`:** Read `system-graphs/graph-master.cypher` for all `:UINode` screens (`id`, `route`/`name`). Initialize or sync `todo-pages.md` (`- [ ] [PageId] — [route]`). Pick `[PAGE_ID]` (from `target=` or the first `- [ ]` entry) and mark `- [/]`. If all are `[x]`, report `"🎉 All pages assembled! Tiếp tục chạy /inject-logic."` and STOP.
2. **Architecture & Invariants Enforcement:** Read `ARCHITECTURE-SPINE.md` and `_bmad-output/project-context.md`. Follow exact routing, rendering (`dynamicParams = false` / SSG vs client islands), and zoning rules for the detected framework (e.g., Next.js App Router `src/app/.../page.tsx` vs `app/.../page.tsx`, Nuxt, or Vite React).
3. **Fidelity to Original Design (CRITICAL):** Open and read the original static HTML file for `[PAGE_ID]` from `ui-screens/[PAGE_ID].html` (fallback: `implementation-artifacts/html-screens/[PAGE_ID].html`). **DO NOT** invent or hallucinate layout, headers, footers, or copy. Copy the outer layout structure (`<nav>`, `<header>`, `<footer>`, `<main>`, `<section>`, classes) faithfully.
4. **Component Orchestration:** Import the `:SharedIsland` and `inPageStates` components mapped to `[PAGE_ID]` in `system-graphs/graph-master.cypher` and place them into the layout.
5. **Real Mock Data (Stubs Only, No Business Logic):** Extract real text, prices, and image URLs from the original HTML file to populate placeholder props. Pass stub callbacks (e.g., `() => console.log('Action triggered')`) for events.

## Execution & Output Format
1. Write the assembled page file directly using your file write tool.
2. Update `todo-pages.md` using your file edit tool: mark `- [/]` as `- [x]`.
3. Report the saved page path, remaining pages, and next command (`/assemble-pages` or `/inject-logic`).