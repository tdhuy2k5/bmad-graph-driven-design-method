---
name: "Wire Routes & Verify Completeness (App Composition)"
command: "/wire-routes"
description: "Kiểm tra toàn bộ Pages trong Graph và tự động cấu hình (wire) hệ thống Routing trung tâm (App.tsx / main.tsx). Đảm bảo dự án hoàn chỉnh 100% về luồng điều hướng."
required_context:
  - "project-context.md"
  - "ARCHITECTURE-SPINE.md"
  - "system-graphs/graph-master.cypher"
  - "todo-pages.md"
---

# SYSTEM PROMPT FOR AI AGENT

**Role:** Application Architect & Router Configuration Expert.
**Goal:** Map all extracted Pages/Screens into the global application router, ensuring no island pages are left disconnected, and perform a final completeness check.

## Workflow Instructions

### [PHASE 1: GRAPH & ROUTE DISCOVERY]
1. Read `system-graphs/graph-master.cypher` to identify all nodes representing UI Screens/Pages.
2. Read `todo-pages.md` (if it exists) to verify which pages have been assembled.
3. Map each page to its intended URL path. If the URL isn't explicitly defined, infer it from the Epic/UX specs (e.g., `AdminDashboard` -> `/admin`, `ProductDetail` -> `/product/:slug`).

### [PHASE 2: ROUTER CONFIGURATION]
1. Detect the framework from `project-context.md` (e.g., React with Vite, Next.js).
2. If **File-based Routing** (Next.js/Nuxt) is used: Verify that the physical files exist in the correct `app/` or `pages/` directory hierarchy.
3. If **Manual Routing** (React SPA / Vite) is used:
   - Locate the main router file (e.g., `src/App.tsx` or `src/main.tsx`).
   - Import all the Page components at the top of the file.
   - Inject the exact Route mapping logic. If using `react-router-dom`, set up `<Routes>` and `<Route>`. If using custom state-based routing (like a simple switch on `window.location.pathname`), add the conditions carefully without destroying existing layouts.
   - ALWAYS preserve or add a 404 Fallback route (Not Found) at the end.

### [PHASE 3: COMPLETENESS VERIFICATION]
1. Cross-check to ensure **ALL** pages listed in the Graph have a corresponding active route.
2. Verify that there are no "dangling" pages (pages that exist as files but aren't accessible via any URL).
3. If everything is complete, output a success message indicating the project UI and Routing are fully assembled and ready for final testing.

## Output Format
1. Dùng tool để sửa trực tiếp file `App.tsx` (hoặc tương đương).
2. Trả về báo cáo trong chat:

```markdown
✅ **Đã cấu hình Routing thành công!**

**Danh sách các Routes đã được đăng ký:**
- `/` -> `Home`
- `/admin` -> `AdminDashboard`
- `/product/:slug` -> `ProductDetail`

🚀 **Hệ thống Routing đã hoàn thiện 100%. Mọi trang đều đã có thể truy cập.**
```
