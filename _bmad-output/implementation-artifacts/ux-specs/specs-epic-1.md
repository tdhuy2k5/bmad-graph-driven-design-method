# UX Screen Specifications: Epic 1 - Product Catalog & Static Showcase

## Executive Summary
This document specifies the Visual Hierarchy, In-Page States, Component Composition, and Edge Cases for **Epic 1: Product Catalog & Static Showcase**, derived directly from the system graph definition in `system-graphs/graph-epic-1.cypher` and architectural rules in `_bmad-output/project-context.md`.

---

## 1. Screen: Home Page (`/`)

### Node Metadata
- **Graph Node ID:** `Home` (`:UINode`)
- **Route Path:** `/`
- **Primary Business Goal:** View SEO-optimized list of products and allow instant client-side filtering.
- **SSG Requirement:** Strictly pre-rendered at build time via Next.js App Router (`dynamicParams = false`).

### Primary Goal & Action
- **Single Primary Action:** Navigate to product detail page (`/san-pham/[slug]`) via product cards.
- **Primary CTA Visual:** Solid primary button on product card ("Xem chi tiết" / "Tư vấn ngay") styled with brand primary color (`bg-emerald-600 hover:bg-emerald-700 text-white`).

### Visual Hierarchy & Component Breakdown
1. **Level 1 (Primary - Dominant Focus):**
   - Main Hero Banner welcoming visitors ("Sản phẩm Nông nghiệp & Dược liệu TruongAnCao").
   - Product Cards within the grid, highlighting product title, featured image, and primary CTA button.
2. **Level 2 (Secondary - High Prominence):**
   - `ProductFilter` bar (`components/features/ProductFilter.tsx`) featuring filter option pills/chips:
     - Nguồn gốc (Origin)
     - Độ tinh khiết (Purity)
     - Mục đích sử dụng (Intended Use)
   - Filter chips use active state highlighting (`bg-emerald-100 text-emerald-800 border-emerald-500` vs `bg-slate-50 text-slate-700 border-slate-200`).
3. **Level 3 (Tertiary - Supporting Actions):**
   - "Xóa bộ lọc" (Clear filters) button when filters are active (`variant="ghost"` icon button with reset tag).
   - Results count display ("Hiển thị X sản phẩm").
4. **Level 4 (Quaternary - Peripheral Context):**
   - Category description texts, breadcrumb/footer navigation, contact info headers.

### In-Page States Management (`inPageStates: ['ProductGrid', 'FilterOptions']`)

#### 1. State: `FilterOptions` (`components/features/ProductFilter.tsx`)
- **Visual Presentation:**
  - **Desktop:** Sticky top filter bar below navigation header with multi-category dropdown selectors / horizontal scrollable pill chips.
  - **Mobile:** Horizontal scroll pill container with a "Bộ lọc" trigger button opening a bottom drawer (`shadcn/ui Sheet`).
- **Behavior & State Mutation (`:MUTATES_STATE`):**
  - **Trigger:** User selects or toggles filter options (Nguồn gốc, Độ tinh khiết, Mục đích sử dụng).
  - **Logic:** Pure client-side filtering over the in-memory static array injected from `data/products.json`. No network request or server trip.
  - **State Mutation:** Updates active product array state driving the `ProductGrid` list.

#### 2. State: `ProductGrid`
- **Visual Presentation:**
  - Responsive CSS Grid layout:
    - Mobile (`< 640px`): 1 column (`grid-cols-1 gap-4`)
    - Tablet (`640px - 1024px`): 2 columns (`grid-cols-2 gap-6`)
    - Desktop (`>= 1024px`): 3 to 4 columns (`grid-cols-3 lg:grid-cols-4 gap-6`)
- **Behavior:**
  - Micro-animations (fade & scale transition `transition-all duration-300 ease-in-out`) when grid elements re-order or filter out.

### Edge Cases & Resiliency

| State | Trigger / Condition | Visual Representation & User Recovery |
| :--- | :--- | :--- |
| **Loading State** | Initial page hydrated / Client filter application | Render 6 x `ProductCardSkeleton` pulse boxes matching exact grid geometry to eliminate Cumulative Layout Shift (CLS). |
| **Empty State** | Filter criteria returns 0 matching products | Display centered empty state illustration/icon.<br>- **Title:** "Không tìm thấy sản phẩm phù hợp"<br>- **Subtitle:** "Thử thay đổi hoặc xóa các tiêu chí bộ lọc hiện tại."<br>- **CTA:** "Xóa tất cả bộ lọc" (Solid secondary button resetting filter state). |
| **Error State** | Filter state corruption / Script error | Boundary fallback container.<br>- **Title:** "Đã có lỗi xảy ra khi tải danh sách sản phẩm"<br>- **CTA:** "Tải lại trang" (`window.location.reload()`). |

---

## 2. Screen: Product Detail Page (`/san-pham/[slug]`)

### Node Metadata
- **Graph Node ID:** `ProductDetail` (`:UINode`)
- **Route Path:** `/san-pham/[slug]`
- **Primary Business Goal:** Display detailed specifications, embedded product media/videos, and direct customer to Zalo/Messenger consultation.
- **SSG Requirement:** Strictly pre-rendered at build time using `generateStaticParams()` from `data/products.json` (`dynamicParams = false`).

### Primary Goal & Action
- **Single Primary Action:** Initiate Zalo / Messenger consultation handoff.
- **Primary CTA Visual:** Prominent sticky contact bar at screen bottom on mobile, and sticky right-hand box on desktop:
  - **Zalo CTA:** Solid Zalo Blue/Green button ("Tư vấn & Báo giá qua Zalo") with official Zalo icon.
  - Pure function URL generator (`lib/zalo`) with `encodeURIComponent()` for safe Vietnamese text handoff.

### Visual Hierarchy & Component Breakdown
1. **Level 1 (Primary - Focal Point):**
   - Product Image Carousel / High-res Hero Image.
   - Product Title (`h1`) and Price / Consultation Banner.
   - Primary Consultation Button ("Tư vấn qua Zalo").
2. **Level 2 (Secondary - Important Details):**
   - Embedded Video Showcase section (`VideoPlayer`).
   - Technical Specifications Table (Mã sản phẩm, Nguồn gốc, Độ tinh khiết, Quy cách đóng gói).
   - Secondary Messenger CTA button ("Gửi tin nhắn Messenger").
3. **Level 3 (Tertiary - Navigation & Extra Media):**
   - Breadcrumb Trail ("Trang chủ > Sản phẩm > [Tên sản phẩm]").
   - Related / Recommended Products Carousel (Mounting `ProductCardIsland`).
4. **Level 4 (Quaternary):**
   - Disclaimer notices, storage instructions, legal compliance metadata.

### In-Page States Management (`inPageStates: ['VideoPlayer']`)

#### 1. State: `VideoPlayer` (Client Component Island)
- **Visual Presentation:**
  - 16:9 Aspect Ratio container (`aspect-video rounded-xl overflow-hidden shadow-md border border-slate-100`).
  - Initial state displays high-resolution poster image overlay with a translucent Play Icon overlay button ("Xem video giới thiệu").
- **Behavior:**
  - **Click Event:** Replaces static poster with interactive YouTube/HTML5 iframe video stream.
  - Ensures non-blocking page render (lazy loading iframe until user interaction or viewport entry).

### Edge Cases & Resiliency

| State | Trigger / Condition | Visual Representation & User Recovery |
| :--- | :--- | :--- |
| **Loading State** | Media assets / Video iframe loading | Poster image skeleton placeholder (`animate-pulse bg-slate-200 aspect-video rounded-xl`). |
| **Missing Media State** | Product has no associated video (`videoUrl` is null) | Seamlessly hide the `VideoPlayer` section without leaving empty space or broken layout gaps. |
| **404 / Invalid Slug** | User navigates to non-existent product slug | Standard Next.js 404 Not Found Page.<br>- **Title:** "Sản phẩm không tồn tại"<br>- **Subtitle:** "Sản phẩm này có thể đã ngưng kinh doanh hoặc đường dẫn không đúng."<br>- **CTA:** "Quay về Danh mục Sản phẩm" (Button linking to `/`). |

---

## 3. Shared Component: Product Card Island (`ProductCardIsland`)

### Node Metadata
- **Graph Node ID:** `ProductCardIsland` (`:SharedIsland`)
- **Component File Location:** `components/ui/ProductCard.tsx`
- **Mounted By:** `Home` (`/`), `ProductDetail` (`/san-pham/[slug]`)
- **Primary Business Goal:** Reusable product snippet card for grids and recommendation bars.

### Visual Hierarchy & Layout Composition
1. **Card Frame:** Clean white card surface with subtle border and shadow (`bg-white rounded-2xl border border-slate-100 shadow-sm hover:shadow-md transition-shadow`).
2. **Top Media Aspect:** 4:3 Product Thumbnail Image with hover zoom effect (`group-hover:scale-105 transition-transform duration-300`).
3. **Badges Overlay:** Absolute positioned origin & purity badges (e.g. "Nguồn gốc: Việt Nam", "99% Purity") at top-left corner.
4. **Card Body:**
   - Product Name (`h3 font-semibold text-slate-900 line-clamp-2`).
   - Short Description / Intended Use snippet (`text-sm text-slate-500 line-clamp-2`).
5. **Card Body Footer:**
   - CTA Action Button ("Xem chi tiết" / "Tư vấn") with right chevron icon.

### Interactivity & Navigation (`:NAVIGATES_TO viewProductDetail`)
- **Trigger:** User clicks on any part of the `ProductCard` component or the CTA button.
- **Logic:** Direct Client/Next.js Router navigation to static PDP route `/san-pham/[slug]`.
- **Feedback:** Pointer cursor (`cursor-pointer`), card elevation effect (`-translate-y-1`).

### Edge Cases & Resiliency

| Edge Case | Failure Scenario | Mitigation / Resilient Pattern |
| :--- | :--- | :--- |
| **Broken Image URL** | `src` fails to load / 404 image link | Render fallback SVG placeholder with brand logo (`/images/placeholder-product.svg`). |
| **Text Overflow** | Product title or summary is excessively long | Enforce strict CSS `line-clamp-2` on title and `line-clamp-2` on description to preserve equal grid heights. |
| **Unpublished Status** | Product marked as out-of-stock / hidden | Display translucent "Hết hàng" overlay banner across card thumbnail and disable CTA click. |

---

## Summary of Verification & Compliance
- **100% Graph Coverage:** Maps every `:UINode` (`Home`, `ProductDetail`), `:SharedIsland` (`ProductCardIsland`), `:MUTATES_STATE` edge (`filterProducts`), and `:NAVIGATES_TO` edge (`viewProductDetail`) from `graph-epic-1.cypher`.
- **Architecture Compliance:** Fully respects Next.js 16 SSG rules, Client Component Islands, zero-I/O pure Zalo handoffs, and Vietnamese UI literal constraints defined in `project-context.md`.
