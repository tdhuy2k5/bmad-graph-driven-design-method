# UX Specification: Product Detail Screen (`/san-pham/[slug]`)

## 1. Overview & Primary Goal
- **Screen ID:** `ProductDetail`
- **Route:** `/san-pham/[slug]`
- **Required Role:** `PUBLIC`
- **Goal:** Display comprehensive product details, specifications, embedded videos, customer reviews/comments, and drive conversions via direct cart additions.
- **Primary Goal & Action:** Convert viewer interest into sales through clear pricing, video demonstrations, and seamless cart interaction.
  - **Primary Action (CTA):** "Thêm vào giỏ hàng" (Add to Cart) with Quantity selector.
  - **Primary Style:** High-contrast filled primary button with prominent visual weight, cart icon, and hover elevation.

---

## 2. Visual Hierarchy & Action Downgrading

| Priority | Action | UI Element / Location | Visual Style |
| :--- | :--- | :--- | :--- |
| **Primary** | Add Product to Cart | Main Action Section (Below price & specs) | Solid Primary CTA Button with Cart Icon & Quantity Counter |
| **Secondary** | Submit Product Comment | Comment Section (`CommentIsland`) | Brand Accent Filled Button (Triggers `AuthModal` if not logged in) |
| **Secondary** | Play Demo Video | Media Gallery (`VideoPlayer`) | Overlay Play Button / Interactive Video Container |
| **Secondary** | View Cart Drawer | Header Cart Icon / Toast Banner | Badge icon button with counter overlay |
| **Tertiary** | View Related Product Detail | Recommended Section (`ProductCardIsland`) | Standard Product Card hover state & navigation |
| **Tertiary** | Share Product | Product Header Actions | Ghost button / Icon-only button ("Chia sẻ") |

---

## 3. In-Page States & Mounted Components Management

### Mounted Islands
1. **`ProductCardIsland` (Reusable Product Card)**
   - **Goal:** Render recommended / related product items at the bottom section.
   - **Interactions:** Clicking related product card navigates to target PDP (`/san-pham/[slug]`).

2. **`AuthModalIsland` (Global Auth Modal)**
   - **Goal:** Require user authentication for interactive features (e.g. submitting a comment).
   - **Trigger:** Unauthenticated user clicks "Gửi bình luận" or comment input box.

3. **`CartDrawerIsland` (Global Cart Drawer)**
   - **Goal:** Slide-over cart summary & handoff to Zalo/Messenger order links.
   - **Trigger:** Click "Thêm vào giỏ hàng" CTA or header cart icon button.

### In-Page States (`inPageStates`: `VideoPlayer`)
- **`VideoPlayer` (Embedded Media Container):**
  - Displays product video overview/review embedded smoothly within the product image gallery/tab.
  - Custom poster thumbnail with fallback placeholder if video URL fails to load.
- **Comment Section (`subscribeToComments`, `createComment`):**
  - Displays real-time comment list fetched from Firestore.
  - Automatic quota-exceeded fallback: if Firestore quota limit is reached, shows existing cached comments with a subtle read-only note without breaking the PDP view layout.

---

## 4. Edge Cases & UX Micro-States

### A. Product Not Found (Invalid Slug / 404)
- **Visual:** Clean illustration with "Sản phẩm không tồn tại hoặc đã tạm ngưng kinh doanh." message.
- **Action CTA:** Primary Outline Button "Quay lại danh mục sản phẩm" navigating to `/`.

### B. Loading State (PDP Skeleton Loader)
- **Visual:** Split layout skeleton:
  - Left column: Large square image placeholder shimmer.
  - Right column: Skeleton lines for Product Title, Price tag, Badges, Quantity selector, and CTA buttons.
  - Bottom: Comment section shimmer lines.

### C. Quota Exceeded / Comment Load Failure
- **Visual:** Subtle info banner in Comment section: "Hệ thống bình luận đang quá tải, một số bình luận mới có thể chậm hiển thị."
- **Behavior:** PDP page remains 100% functional for product reading and purchasing actions.

### D. Out of Stock / Unavailability
- **Visual:** Primary CTA button disabled with label "Hết hàng".
- **Action CTA:** Secondary Outline Button "Nhận thông báo khi có hàng" or "Tư vấn qua Zalo".
