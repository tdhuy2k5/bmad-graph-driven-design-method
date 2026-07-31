# Stitch Prompt: AdminDashboard Screen (/admin)

**Role:** You are a frontend developer building a UI component using pure HTML, Tailwind CSS, and Vanilla JavaScript. 

**Constraint Checklist & Confidence Score:**
1. Visual Hierarchy & Composition? Yes.
2. State Toggling (Vanilla JS only, no React `useState`)? Yes.
3. No Business Logic (empty `onclick` or `console.log`)? Yes.
4. No React syntax (`className` -> `class`, `onClick` -> `onclick`)? Yes.
5. Mock Data & Edge Cases? Yes.
6. **In-Context Atomic Generation? Yes (CRITICAL).**

Confidence Score: 5/5

**Task:** Build the complete **AdminDashboard** screen (`/admin`), including all its in-page states (`LoginGate`, `CommentList`, `ProductForm`).

## CRITICAL: In-Context Atomic Generation Strategy
You **MUST NOT** build the entire page immediately in one single HTML block. Doing so causes you to drop critical details like nested forms and edge cases. 
You MUST use a **Sequential Chain of Generation**. Output your response in the exact following order:
1. **Block 1 (`LoginGate`):** Output a distinct markdown HTML code block containing *only* the admin authentication barrier overlay (`LoginGate`), including normal login screen, access denied alert card, and auth checking spinner.
2. **Block 2 (`CommentList`):** Output a distinct markdown HTML code block containing *only* the real-time comment moderation panel tab (`CommentList`), including table/card items, deletion confirmation modal, and empty state.
3. **Block 3 (`ProductForm`):** Output a distinct markdown HTML code block containing *only* the Git-based product manager tab (`ProductForm`), including all form input fields, save/cancel buttons, commit loading spinner state, success notification banner, and API rate limit error modal.
4. **Block 4 (`AdminDashboard Layout`):** Finally, output a fourth markdown HTML code block containing the main `/admin` dashboard layout (Header, Admin Info, Tab Navigation Bar), and assemble/inject Blocks 1, 2, and 3 into this final layout.

---

## 1. Island / Component Specification: LoginGate (Auth Guard)
- **Visuals:** High-contrast full-screen overlay or centered modal container blocking access to `/admin` content.
- **Elements:**
  - Header: Security shield icon, Title "Đăng nhập Quản trị viên (Admin Portal)".
  - Primary Action: High-contrast OAuth button ("Đăng nhập bằng Google / GitHub" with shield/lock icon). `onclick="console.log('loginAdmin')"`
- **Access Denied Edge Case State:** Warning Card with red accent border and Lock icon. Text: "Truy cập bị từ chối: Email của bạn không nằm trong danh sách Quản trị viên." CTA button: "Đăng xuất & Thử tài khoản khác".
- **Loading State:** Centered loading spinner with text "Đang kiểm tra quyền truy cập...".

## 2. Island / Component Specification: CommentList (Moderation Panel Tab)
- **Visuals:** Clean moderation table/cards displaying real-time comments.
- **Table / Card Columns:** User avatar/name, Target product slug/title, Comment text content, Timestamp, Action column.
- **Actions:** 
  - "Xóa bình luận" (Danger outline / soft red button with trash icon). `onclick="console.log('deleteComment')"`
  - Deletion Confirmation Modal overlay asking "Bạn có chắc chắn muốn xóa bình luận này không?".
- **Edge Case (Empty):** Neutral card with chat bubble icon, text: "Chưa có bình luận nào cần quản lý."

## 3. Island / Component Specification: ProductForm (Git-based Catalog CMS Tab)
- **Visuals:** Form layout for editing static JSON product catalog stored in GitHub.
- **Form Fields (DO NOT SKIP):**
  - Product Title (`h3` label, text input).
  - Product Slug (`text` input, auto-generated style).
  - Price (`number` input with VNĐ suffix).
  - Origin / Nguồn gốc (`select` dropdown or text input: "Việt Nam", etc.).
  - Purity / Độ tinh khiết (`text` input, e.g. "99% Purity").
  - Video Embed URL (`text` input for YouTube URL).
  - Short Description (`textarea`).
  - Image URLs list/upload placeholder (`text` inputs).
- **Actions:** 
  - Primary CTA: Solid brand primary button ("Lưu & Deploy qua GitHub"). `onclick="console.log('updateProductGit')"`
  - Cancel / Reset: Ghost button ("Hủy bỏ").
  - External link icon: "Xem trang sản phẩm" (opens `/san-pham/[slug]`).
- **In-Progress Loading State:** Primary button turns into spinner state with label "Đang commit & trigger build...".
- **Success State Banner:** Green notification banner top of form: "Đã lưu thay đổi! Hệ thống đang tự động rebuild trang (Vercel Build)."
- **Edge Case (GitHub API Error):** Red alert modal at top of form with text: "Không thể cập nhật dữ liệu qua GitHub API. Vui lòng kiểm tra lại kết nối hoặc Token." and buttons "Thử lại" and "Sao chép bản nháp".

## 4. Screen Specification: AdminDashboard Layout (/admin)
- **Visuals:** Modern admin workspace layout (`bg-slate-50 min-h-screen`).
- **Header Top-Bar:**
  - Brand Logo ("TruongAnCao Admin Portal").
  - Logged-in Admin Profile Pill (Avatar + Email: `admin@truongancao.com`).
  - Button "Xem trang web" (external link) and "Đăng xuất" (Logout).
- **Navigation Bar:** Segmented Tab Control / Active highlight pills for switching between tabs:
  - Tab 1: "Quản lý sản phẩm" (`ProductForm`) - Active state (`bg-white shadow text-slate-900 font-medium`).
  - Tab 2: "Quản lý bình luận" (`CommentList`) - Inactive state (`text-slate-500 hover:text-slate-700`).
- **Assembly:** Inject `ProductForm` into Tab 1 container, `CommentList` into Tab 2 container. Render `LoginGate` as an absolute/fixed overlay conditionally toggleable.

---

## Strict Implementation Rules (Vanilla JS)
1. **Vanilla JS Only:** Use a `<script>` block at the bottom of the HTML to define simple toggle functions (e.g., `function switchTab(tabName) { ... }` or `function toggleLoginGate() { ... }`). Do NOT use React or `useState`.
2. **Empty Logic / Placeholders:** Do NOT write real API/Firebase calls. Use `onclick="console.log('Action')"` or simple JS toggles.
3. **Pure HTML/Tailwind:** Output pure HTML with Tailwind CSS utility classes. Use `class=""` instead of `className=""`.
4. **Mock Data:** Hardcode rich Vietnamese admin mock data (products, user emails, comments) to demonstrate the UI.

Remember to output exactly 4 separate HTML blocks to strictly preserve In-Context Atomic fidelity!
