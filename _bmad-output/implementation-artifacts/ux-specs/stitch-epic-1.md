# Google Stitch Prompts: Epic 1 - Product Catalog & Static Showcase

## Overview
This document contains ready-to-copy prompts engineered specifically for **Google Stitch** (or AI UI Generators) to build components for **Epic 1: Product Catalog & Static Showcase**.

Each prompt enforces strict visual hierarchy, React 19 state toggling, mock data isolation, zero backend logic, and adherence to the project's Tailwind CSS 4.x + Next.js App Router design system.

---

## 1. Screen Prompt: Home Page (`/` - `Home`)

**Target File:** `app/page.tsx` & `components/features/HomeProductCatalog.tsx`

```text
Generate a complete, modern, responsive Next.js (App Router, React 19) Home Page component for an agricultural & herbal product store ("TruongAnCao").
Style using Tailwind CSS v4 and shadcn/ui design conventions.

STRICT CONSTRAINTS:
1. Visual Hierarchy:
   - Level 1 (Primary Focal Point): Hero Banner with headline "Nông sản & Dược liệu TruongAnCao" and solid emerald CTA button ("Khám phá sản phẩm"). Product Grid with cards featuring prominent primary CTA ("Xem chi tiết").
   - Level 2 (Secondary): Filter Bar with pill/chip selectors for "Nguồn gốc" (origin), "Độ tinh khiết" (purity), and "Mục đích sử dụng" (intended use).
   - Level 3 (Tertiary): Filter reset button ("Xóa bộ lọc") with ghost styling and product count badge ("Hiển thị X sản phẩm").
2. State Management (CRITICAL):
   - Use React `useState` for mobile filter drawer toggling: `const [isMobileFilterOpen, setIsMobileFilterOpen] = useState(false);` (MUST default to `false`).
   - Use `useState` for selected filter state: `const [selectedCategory, setSelectedCategory] = useState('all');`.
   - Initial UI render MUST be clean with all drawers/modals closed.
3. No Business / Backend Logic:
   - DO NOT make fetch/axios requests or backend database queries.
   - Use a hardcoded mock array of 6 products (id, title, price, origin, purity, image, slug).
   - Leave click handlers for navigation as dummy functions: `onClick={() => console.log('Navigate to PDP', product.slug)}`.
4. Language & Aesthetics:
   - ALL UI strings MUST be in Vietnamese ("Tất cả", "Nguồn gốc", "Độ tinh khiết", "Xem chi tiết", "Tư vấn ngay").
   - Emerald color palette (`bg-emerald-600`, `text-emerald-800`, `hover:bg-emerald-700`).
   - Card hover elevation effects, rounded corners (`rounded-2xl`), clean responsive layout.
```

---

## 2. Screen Prompt: Product Detail Page (`/san-pham/[slug]` - `ProductDetail`)

**Target File:** `app/san-pham/[slug]/page.tsx`

```text
Generate a responsive Next.js 16 Product Detail Page (PDP) component for an agricultural/herbal product in Tailwind CSS v4 and Lucide React icons.

STRICT CONSTRAINTS:
1. Visual Hierarchy:
   - Level 1 (Primary Focal Point): High-res Product Media Gallery and prominent sticky Zalo/Messenger consultation CTA button ("Tư vấn & Báo giá qua Zalo") using brand solid emerald color.
   - Level 2 (Secondary): Embedded Video Player section ("Video giới thiệu / Hướng dẫn sử dụng") and Technical Specifications table (Mã sản phẩm, Nguồn gốc, Độ tinh khiết, Quy cách đóng gói).
   - Level 3 (Tertiary): Breadcrumb navigation ("Trang chủ > Sản phẩm > [Tên sản phẩm]") and secondary Messenger contact CTA.
2. State Management & In-Page State Toggle (CRITICAL):
   - Use React `useState` to toggle Video Player playback state: `const [isPlayingVideo, setIsPlayingVideo] = useState(false);` (MUST default to `false`).
   - When `isPlayingVideo === false`, render video poster image overlay with a centered Play Icon overlay button. Switching to `true` reveals the interactive video frame/iframe.
3. No Business Logic:
   - Hardcode product detail mock data object (name, price, origin, purity, videoUrl, specs).
   - Zalo and Messenger button click handlers must be dummy slots: `onClick={() => console.log('Trigger Zalo handoff')}`.
4. Language & Mobile Design:
   - UI text in Vietnamese ("Tư vấn qua Zalo", "Gửi tin nhắn Messenger", "Thông số kỹ thuật", "Video sản phẩm").
   - Sticky bottom action bar on mobile viewports for quick consultation access.
```

---

## 3. Component Prompt: Product Filter Bar (`ProductFilter`)

**Target File:** `components/features/ProductFilter.tsx`

```text
Generate a reusable Client Component `ProductFilter` for catalog filtering in React 19 + Tailwind CSS 4.

STRICT CONSTRAINTS:
1. Visual Hierarchy:
   - Desktop view: Sticky top horizontal bar featuring category chips and dropdown selectors for "Nguồn gốc" (Origin), "Độ tinh khiết" (Purity), "Mục đích sử dụng" (Use case).
   - Active filter pills highlighted with emerald background (`bg-emerald-100 text-emerald-800 border-emerald-500`).
   - "Xóa bộ lọc" ghost button displayed when any filter is active.
2. State Management (CRITICAL):
   - Use `useState` for active dropdown popovers: `const [openDropdown, setOpenDropdown] = useState<string | null>(null);` (default `null`).
   - Use `useState` for mobile bottom drawer: `const [isDrawerOpen, setIsDrawerOpen] = useState(false);` (default `false`).
3. Pure Presentation:
   - Expose dummy callback prop `onFilterChange?: (filters: any) => void`.
   - Do NOT implement data filtering logic inside this component; leave it as UI state slot.
4. Vietnamese UI Text:
   - Text strings: "Tất cả sản phẩm", "Lọc theo nguồn gốc", "Độ tinh khiết", "Mục đích sử dụng", "Xóa bộ lọc".
```

---

## 4. Component Prompt: Product Card Island (`ProductCardIsland`)

**Target File:** `components/ui/ProductCard.tsx`

```text
Generate a single reusable `ProductCard` component using Tailwind CSS 4 + React 19.

STRICT CONSTRAINTS:
1. Visual Hierarchy & Composition:
   - Card container with smooth hover elevation (`bg-white rounded-2xl border border-slate-100 shadow-sm hover:shadow-md transition-all`).
   - 4:3 Aspect ratio product thumbnail image with hover zoom effect (`group-hover:scale-105 transition-transform duration-300`).
   - Badges overlay on top-left: Origin badge and Purity tag (e.g. "99% Purity").
   - Card Body: Product title (`h3 font-semibold line-clamp-2`), short description (`line-clamp-2`).
   - Card Footer: Primary CTA button ("Xem chi tiết") with right chevron icon.
2. Edge Cases in UI:
   - Render fallback SVG placeholder if product image fails to load.
   - Strict CSS line clamping (`line-clamp-2`) to guarantee identical card heights in grid views.
3. Interactive Slot:
   - Click handler slot: `onClick={() => console.log('Card clicked', product.id)}`.
```

---

## Summary of Prompt Engineering Constraints
- **React 19 Hooks:** All modal/drawer/player state defaults to `false`.
- **Zero Dependencies:** Pure presentation components with dummy slots.
- **Tailwind 4 + Vietnamese:** Ready for direct code generation and integration into Next.js App Router static pages.
