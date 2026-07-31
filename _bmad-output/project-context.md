---
project_name: 'TruongAnCao'
user_name: 'tacadmin'
date: '2026-07-23'
sections_completed:
  ['technology_stack', 'language_rules', 'framework_rules', 'testing_rules', 'quality_rules', 'workflow_rules', 'anti_patterns']
status: 'complete'
rule_count: 18
optimized_for_llm: true
---

# Project Context for AI Agents

_This file contains critical rules and patterns that AI agents must follow when implementing code in this project. Focus on unobvious details that agents might otherwise miss._

---

## Technology Stack & Versions

- **Next.js**: 16.2.11 (App Router, strict SSG for public routes)
- **React**: 19.x
- **Firebase JS SDK**: 12.16.0 (Firestore, Auth — no Firebase Storage or Hosting)
- **TypeScript**: 5.x
- **Tailwind CSS**: 4.x (with shadcn/ui)
- **Hosting/CI**: Vercel

## Critical Implementation Rules

### Language-Specific Rules

- **Import/Export Constraints:** Use named exports ONLY in `lib/` (no `default export` outside of Next.js pages/layouts).
- **Module Boundaries:** `app/` directory pages and layouts are terminal endpoints; components must NEVER import from `app/`.
- **Firebase Isolation:** `lib/firebase` is the absolute strict boundary for the Firebase SDK. UI components must NEVER import from `firebase/*` directly.
- **Pure Functions:** Core domain logic, such as the Zalo/Messenger URL handoff logic in `lib/zalo`, must be implemented as pure functions with zero I/O side effects.
- **Data Types:** Use string auto-IDs for all dynamic database records. Financial values (prices) must be stored as integers (VND) with no decimals.

### Framework-Specific Rules

- **SSG Strictness:** Public routes (`/` and `/san-pham/[slug]`) MUST be statically generated (SSG) at build time. Always set `dynamicParams = false`. Server-Side Rendering (SSR) is strictly forbidden for these routes to maximize SEO and caching.
- **Static Catalog Injection:** Product data must ONLY be fetched from the local static file `data/products.json` within `generateStaticParams` and `generateMetadata`. Never use database roundtrips for product catalog data.
- **Client Component Islands:** Dynamic behavior (like real-time comments and click metrics) must be isolated to strictly defined "islands" (Client Components). These components must never be pre-rendered on the server to prevent rebuild coupling.
- **State Mutation Surface:** There is only one valid mutation surface: posting a comment via the typed helper in `lib/firebase/comments.ts`. Do not perform inline mutations directly within UI components.

### Testing Rules

- **Boundary Mocking:** Any unit tests for components MUST completely mock `lib/firebase`. UI components should never attempt to connect to a real Firestore instance or emulator during unit tests.
- **Pure Function Testing:** Logic inside `lib/zalo` must be tested purely on inputs and outputs without any mocking, as they are pure functions.
- **Integration Constraints:** E2E testing (if added later) must be the only testing layer that interacts with the real Firebase Auth/Firestore environment.

### Code Quality & Style Rules

- **Naming Conventions (Files):** Use `kebab-case` for all files and directories (except standard Next.js files like `page.tsx` or `layout.tsx`).
- **Naming Conventions (Firestore):** Use `camelCase` for collection names (e.g., `comments`, `metrics`).
- **Naming Conventions (Env Vars):** Use the `NEXT_PUBLIC_` prefix ONLY for variables explicitly designed to be exposed in the browser.
- **Language/i18n:** No i18n library is used. ALL UI strings must be Vietnamese literals directly in components. Code identifiers (variables, functions, component names) and comments MUST be in English.
- **Styling:** Use Tailwind CSS 4.x utility classes with `shadcn/ui` components. Maintain global tokens in `app/globals.css`.

### Development Workflow Rules

- **Catalog Updates:** There is no backend CMS. Adding or modifying products MUST be done by directly modifying the static `data/products.json` (or `.ts`) file in the codebase.
- **Deployment Triggers:** Any changes to the static catalog require a Git commit, which will trigger Vercel CI/CD to rebuild the SSG cache globally. Do not attempt to build a runtime cache invalidation mechanism for the catalog.

### Critical Don't-Miss Rules

- **Anti-Pattern (SSR):** DO NOT use Server-Side Rendering (SSR) for the product catalog. This bypasses the CDN cache and violates the architecture's core premise. Rely strictly on `generateStaticParams`.
- **Security (Auth):** The client-side auth UI is for UX only. DO NOT assume the client is secure. All real security enforcement for comments must exist in the Firestore Security Rules (`request.auth != null`).
- **Performance (Quotas):** The project operates on the Firebase Spark (free) plan. Unnecessary database reads will exhaust the quota. This is why the catalog is static. Handle quota errors gracefully at the `lib/firebase` boundary to prevent the UI from crashing if limits are reached.
- **Edge Cases (Encoding):** URLs for Zalo and Messenger handoff MUST use `encodeURIComponent()` to avoid breaking when handling Vietnamese characters and special symbols in the product name or message.

---

## Usage Guidelines

**For AI Agents:**

- Read this file before implementing any code
- Follow ALL rules exactly as documented
- When in doubt, prefer the more restrictive option
- Update this file if new patterns emerge

**For Humans:**

- Keep this file lean and focused on agent needs
- Update when technology stack changes
- Review quarterly for outdated rules
- Remove rules that become obvious over time

Last Updated: 2026-07-23
