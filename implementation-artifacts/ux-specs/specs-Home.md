# UX Specification: Home Screen (`/`)

## 1. Overview & Primary Goal
- **Screen ID:** `Home`
- **Route:** `/`
- **Required Role:** `PUBLIC`
- **Goal:** View SEO-optimized list of products with quick filtering and one-click cart additions.
- **Primary Goal & Action:** Discover products easily and trigger quick purchases or navigate to Product Details.
  - **Primary Action (CTA):** "Thêm vào giỏ" (Add to Cart) on product cards & "Chi tiết sản phẩm" (View Details).
  - **Primary Style:** High-contrast filled primary button (Vibrant primary color, clear visual weight).

---

## 2. Visual Hierarchy & Action Downgrading

| Priority | Action | UI Element / Location | Visual Style |
| :--- | :--- | :--- | :--- |
| **Primary** | Add to Cart | `ProductCardIsland` CTA Button | Solid Primary Button with Cart Icon |
| **Primary** | View Product Detail | `ProductCard` Card Click / Title Link | Direct navigation link with hover elevation |
| **Secondary** | Filter Products (Origin, Purity, Intended Use) | `FilterOptions` / `ProductFilter` bar | Chip selectors / Dropdown selects with subtle border |
| **Secondary** | View Cart Drawer | Floating Header Cart Icon | Badge icon button with counter overlay |
| **Tertiary** | Clear Filters / Reset Search | Filter bar right side | Ghost button / Text-only link ("Xóa lọc") |

---

## 3. In-Page States & Mounted Components Management

### Mounted Islands
1. **`ProductCardIsland` (Reusable Product Card)**
   - **Goal:** Display product image, title, price, origin tag, purity percentage, and action triggers.
   - **Interactions:**
     - Click Card Body / Image / Title -> Navigates to PDP (`/san-pham/[slug]`).
     - Click "Thêm vào giỏ" button -> Mutates `addToCart` in Cart State + updates Cart Badge + opens subtle notification toast.

2. **`CartDrawerIsland` (Global Cart Drawer)**
   - **Goal:** Manage cart items and checkout handoff to Zalo / Messenger.
   - **Trigger:** Click Cart Header Icon or Add to Cart callback.

### In-Page States (`inPageStates`: `ProductGrid`, `FilterOptions`)
- **`FilterOptions` (Sticky / Floating Filter Bar):**
  - Instant client-side filtering by Origin (Nguồn gốc), Purity (Độ tinh khiết), and Intended Use (Nhu cầu sử dụng).
  - Active filters display active highlight color + removable badge pill.
- **`ProductGrid` (Dynamic Responsive Grid):**
  - 4-column layout on Desktop, 2-column on Tablet, 1-column on Mobile.
  - Smooth animation/fade when filter state updates.

---

## 4. Edge Cases & UX Micro-States

### A. Empty State (No products match filter)
- **Visual:** Clean illustration of search icon with subtle magnifying glass.
- **Text:** "Không tìm thấy sản phẩm phù hợp với bộ lọc hiện tại."
- **Action CTA:** Secondary Ghost Button "Xóa bộ lọc" to reset filter options immediately.

### B. Loading State (Initial Load / Dynamic Fetch)
- **Visual:** Skeleton Loader cards (pulse animation matching product card aspect ratio, gray placeholder image box, 2 line shimmer text).
- **Count:** Render 8 skeleton cards during initial loading.

### C. Error State (Failed data fetch / local store sync error)
- **Visual:** Alert toast / banner top of grid with inline retry button.
- **Text:** "Không thể tải danh sách sản phẩm. Vui lòng thử lại."
- **Action CTA:** Primary outline button "Tải lại trang".
