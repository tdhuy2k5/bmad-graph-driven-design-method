# Stitch Prompt: Home Screen (/)

**Role:** You are a frontend developer building a UI component using pure HTML, Tailwind CSS, and Vanilla JavaScript. 

**Constraint Checklist & Confidence Score:**
1. Visual Hierarchy & Composition? Yes.
2. State Toggling (Vanilla JS only, no React `useState`)? Yes.
3. No Business Logic (empty `onclick` or `console.log`)? Yes.
4. No React syntax (`className` -> `class`, `onClick` -> `onclick`)? Yes.
5. Mock Data & Edge Cases? Yes.
6. **In-Context Atomic Generation? Yes (CRITICAL).**

Confidence Score: 5/5

**Task:** Build the complete **Home** screen (`/`), including its nested components (`CartDrawerIsland` and `ProductCardIsland`). 

## CRITICAL: In-Context Atomic Generation Strategy
You **MUST NOT** build the entire page immediately in one single HTML block. Doing so causes you to drop critical details like nested forms. 
You MUST use a **Sequential Chain of Generation**. Output your response in the exact following order:
1. **Block 1 (`CartDrawerIsland`):** Output a distinct markdown HTML code block containing *only* the global cart drawer component. Ensure 100% fidelity to the delivery details form requirements below.
2. **Block 2 (`ProductCardIsland`):** Output a distinct markdown HTML code block containing *only* the reusable product snippet card.
3. **Block 3 (`Home Screen Layout`):** Finally, output a third markdown HTML code block containing the main page layout, and assemble/inject the HTML from Block 1 and Block 2 into this final layout.

---

## 1. Island Specification: CartDrawerIsland (Global Cart Drawer)
- **Visuals:** Side-drawer overlay sliding in from the right. **Must be hidden by default (`hidden` class).**
- **Elements & Forms (DO NOT SKIP):** 
  - List of cart items with Quantity controls (+/-) and "Xóa" (Clear item) buttons.
  - **CRITICAL:** You must include a full HTML `<form>` or input group for **Delivery Details (Name, Phone Number, and Address).** Do not skip this!
- **Actions:** 
  - "Đặt hàng ngay qua Zalo" (Solid Zalo blue). `onclick="console.log('checkoutViaZalo')"`
  - "Gửi qua Messenger" (Ghost/Outline). `onclick="console.log('checkoutViaMessenger')"`
- **Edge Case (Empty):** Show "Giỏ hàng của bạn đang trống." and a "Tiếp tục mua sắm" button to close the drawer.
- **Form Error State:** Highlight missing inputs (e.g., missing phone number) in red.

## 2. Island Specification: ProductCardIsland
- **Visuals:** White card (`bg-white rounded-2xl border border-slate-100 shadow-sm hover:shadow-md transition-shadow`). 
- **Thumbnail:** 4:3 image with hover zoom (`group-hover:scale-105`).
- **Badges Overlay:** Top-left absolute positioned badges (e.g., "Nguồn gốc: Việt Nam", "99% Purity").
- **Body:** Product Name (h3, `font-semibold line-clamp-2`), Intended Use/Short Description (`text-sm text-slate-500 line-clamp-2`).
- **Footer/CTA:** Solid primary button ("Thêm vào giỏ", `bg-emerald-600 hover:bg-emerald-700 text-white`). 
- **Action:** Clicking the button triggers `onclick="console.log('addToCart: Update Cart count badge')"`.

## 3. Screen Specification: Home (`/`)
- **Level 1 (Dominant Focus):** Main Hero Banner ("Sản phẩm Nông nghiệp & Dược liệu TruongAnCao").
- **Global Header:** Must include a Cart Icon with a count badge (e.g., '2'). Clicking it opens the `CartDrawerIsland`.
- **Level 2 (Filter Bar):** Sticky top filter bar (below header). Include multi-category dropdown selectors or horizontal scrollable pill chips for: "Nguồn gốc", "Độ tinh khiết", "Mục đích sử dụng". Active filters use `bg-emerald-100 text-emerald-800 border-emerald-500`.
- **Product Grid:** Responsive CSS Grid:
  - Mobile: 1 col (`grid-cols-1 gap-4`)
  - Tablet: 2 cols (`grid-cols-2 gap-6`)
  - Desktop: 3-4 cols (`grid-cols-3 lg:grid-cols-4 gap-6`)
- **Assembly:** Render multiple `ProductCardIsland` components inside the grid. Mount the `CartDrawerIsland` globally as an overlay.
- **Empty State (Grid):** If 0 matching products, display an empty state illustration with title: "Không tìm thấy sản phẩm phù hợp", subtitle: "Thử thay đổi hoặc xóa các tiêu chí bộ lọc hiện tại.", and CTA: "Xóa tất cả bộ lọc".

---

## Strict Implementation Rules (Vanilla JS)
1. **Vanilla JS Only:** Use a `<script>` block at the bottom of the HTML to define simple toggle functions (e.g., `function toggleCart() { document.getElementById('cart-drawer').classList.toggle('hidden'); }`). Do NOT use React, Vue, or `useState`.
2. **Empty Logic / Placeholders:** Do NOT write actual API logic. Use `onclick="toggleCart()"` or `onclick="console.log('Action')"` for standard HTML buttons.
3. **Pure HTML/Tailwind:** Output pure HTML with Tailwind CSS utility classes. Use `class=""` instead of `className=""`.
4. **Mock Data:** Hardcode rich, realistic Vietnamese data to accurately demonstrate the UI states.

Remember to strictly follow the **In-Context Atomic Generation Strategy** by outputting 3 separate HTML blocks.
