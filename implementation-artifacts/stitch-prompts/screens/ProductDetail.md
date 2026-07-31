# Stitch Prompt: ProductDetail Screen (/san-pham/[slug])

**Role:** You are a frontend developer building a UI component using pure HTML, Tailwind CSS, and Vanilla JavaScript. 

**Constraint Checklist & Confidence Score:**
1. Visual Hierarchy & Composition? Yes.
2. State Toggling (Vanilla JS only, no React `useState`)? Yes.
3. No Business Logic (empty `onclick` or `console.log`)? Yes.
4. No React syntax (`className` -> `class`, `onClick` -> `onclick`)? Yes.
5. Mock Data & Edge Cases? Yes.
6. **In-Context Atomic Generation? Yes (CRITICAL).**

Confidence Score: 5/5

**Task:** Build the complete **ProductDetail** screen (`/san-pham/[slug]`), including all its nested components.

## CRITICAL: In-Context Atomic Generation Strategy
You **MUST NOT** build the entire page immediately in one single HTML block. Doing so causes you to drop critical details like nested forms. 
You MUST use a **Sequential Chain of Generation**. Output your response in the exact following order:
1. **Block 1 (`VideoPlayer`):** HTML block for the video player snippet.
2. **Block 2 (`CommentIsland`):** HTML block for the comments section.
3. **Block 3 (`AuthModalIsland`):** HTML block for the global authentication modal (hidden by default).
4. **Block 4 (`CartDrawerIsland`):** HTML block for the cart drawer (hidden by default). Ensure 100% fidelity to the delivery details form!
5. **Block 5 (`ProductCardIsland`):** HTML block for a reusable product snippet card for the Related Products grid.
6. **Block 6 (`ProductDetail Layout`):** Finally, output the main page layout, and assemble/inject all the previously generated Island blocks into this final layout.

---

## 1. Island Specification: VideoPlayer
- **Visuals:** 16:9 Aspect Ratio container (`aspect-video rounded-xl overflow-hidden shadow-md`).
- **Initial State:** High-resolution poster image overlay with a translucent Play Icon overlay button ("Xem video giới thiệu").
- **Behavior:** On click, use Vanilla JS to hide the poster and show an interactive YouTube/HTML5 iframe placeholder.

## 2. Island Specification: CommentIsland
- **Visuals:** Section for user comments at the bottom of the page.
- **Actions:** 
  - "Gửi bình luận" (Solid, brand color) for authenticated users.
  - "Đăng nhập để bình luận" (Ghost/Outline). Clicking this triggers the `AuthModalIsland` (`onclick="toggleAuthModal()"`).
- **Edge Cases:** Render 2-3 hardcoded comments. Render an Empty State: "Hãy là người đầu tiên bình luận!" with an illustration.

## 3. Island Specification: AuthModalIsland
- **Visuals:** Global Auth Modal overlay (centered popup with backdrop). **Must be hidden by default (`hidden` class).**
- **Actions:** Google/GitHub login buttons (Icons + Text). Add a close button.

## 4. Island Specification: CartDrawerIsland (Global Cart Drawer)
- **Visuals:** Side-drawer overlay sliding in from the right. **Must be hidden by default (`hidden` class).**
- **Elements (DO NOT SKIP):** Quantity controls (+/-), "Xóa" (Clear item), and input fields for **Delivery Details (Name, Phone, Address)**.
- **Actions:** "Đặt hàng ngay qua Zalo" (Solid Zalo blue), "Gửi qua Messenger" (Ghost/Outline).

## 5. Island Specification: ProductCardIsland
- **Visuals:** White card (`bg-white rounded-2xl shadow-sm`). 4:3 Thumbnail.
- **Badges:** Top-left origin/purity badges.
- **Body:** Product Name (h3, `line-clamp-2`), Intended Use (`line-clamp-2`).
- **Footer/CTA:** "Thêm vào giỏ" button (`bg-emerald-600 text-white`).

## 6. Screen Specification: ProductDetail (`/san-pham/[slug]`)
- **Level 1 (Focal Point):**
  - Product Image Carousel / High-res Hero Image.
  - Product Title (`h1`), Price, and large "Thêm vào giỏ hàng" (Add to Cart) button.
  - Zalo CTA: Prominent sticky contact bar at bottom (mobile) / sticky right-hand box (desktop) with "Tư vấn & Báo giá qua Zalo" (Solid Zalo Blue).
- **Level 2 (Secondary):**
  - Assemble `VideoPlayer` here.
  - Technical Specifications Table (Mã sản phẩm, Nguồn gốc, Độ tinh khiết, Quy cách đóng gói).
  - Secondary Messenger CTA button.
  - Global header cart icon (triggers `CartDrawerIsland`).
- **Level 3 (Tertiary):**
  - Breadcrumb Trail ("Trang chủ > Sản phẩm > [Tên sản phẩm]").
  - Related Products Carousel/Grid (Mounting multiple `ProductCardIsland`s).
  - Assemble `CommentIsland` here.
- **Level 4:** Disclaimer notices, storage instructions.

---

## Strict Implementation Rules (Vanilla JS)
1. **Vanilla JS Only:** Use a `<script>` block at the bottom to define toggle functions (e.g., `toggleCart`, `toggleAuthModal`, `playVideo`). Do NOT use React `useState`.
2. **Pure HTML/Tailwind:** Output pure HTML with Tailwind CSS. Use `class=""` instead of `className=""`.
3. **Mock Data:** Hardcode rich, realistic Vietnamese data to perfectly demonstrate the UI.

Remember to output exactly 6 separate HTML blocks to preserve In-Context Atomic fidelity!
