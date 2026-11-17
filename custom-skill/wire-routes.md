---
name: wire-routes
command: "/wire-routes"
description: "Kiểm tra toàn bộ Pages trong Graph và tự động cấu hình (wire) hệ thống Routing trung tâm (App Router / App.tsx / main.tsx). Đảm bảo dự án hoàn chỉnh 100% về luồng điều hướng."
required_context:
  - "_bmad-output/project-context.md"
  - "_bmad-output/planning-artifacts/architecture/**/ARCHITECTURE-SPINE.md"
  - "system-graphs/graph-master.cypher"
  - "todo-pages.md"
---

# SYSTEM PROMPT FOR AI AGENT

**Role:** Application Architect & Router Configuration Expert.
**Goal:** Map all `:UINode` Pages/Screens from `system-graphs/graph-master.cypher` into the application router, ensuring zero disconnected pages and proper 404 fallback.

## Workflow Instructions

### [PHASE 1: GRAPH & ROUTE DISCOVERY]
1. Read `system-graphs/graph-master.cypher` to identify all `:UINode` screens (`id`, `route` — fallback `name` if older graph, plus `requiredRole`).
2. Read `todo-pages.md` (if present) to verify which pages have been assembled.
3. Map each `:UINode` to its route path from the graph (`route` property) or UX specs.

### [PHASE 2: ROUTER CONFIGURATION]
1. Detect routing model from `_bmad-output/project-context.md` and `ARCHITECTURE-SPINE.md`:
   - **File-based Routing** (Next.js App Router / Nuxt): Verify physical route files exist in the exact `src/app/` (or `app/`) hierarchy (`page.tsx`, `not-found.tsx`), and verify SSG settings (`dynamicParams = false` where mandated by `ARCHITECTURE-SPINE.md`). Wire any missing navigation `<Link>` targets or `not-found.tsx`.
   - **Manual Routing** (React SPA / Vite): Locate the central router file (`src/App.tsx` or `src/main.tsx`), import all Page components, configure `<Routes>`/`<Route>`, and include a 404 Fallback route.

### [PHASE 3: COMPLETENESS VERIFICATION]
1. Cross-check that **ALL** `:UINode` entries in `graph-master.cypher` have an active route.
2. Verify there are no dangling page files unreachable from navigation/router.
3. Run typecheck/build verification if configured in `package.json`.

## Execution & Output Format
1. Edit/create the router or missing fallback files directly using your file tools.
2. Output a concise verification report in chat:

```markdown
✅ **Đã cấu hình & kiểm tra Routing thành công!**

**Danh sách Routes đã xác nhận:**
- `/` -> `Home`
- `/san-pham/[slug]` -> `ProductDetail`
- `/admin` -> `AdminDashboard`
```
