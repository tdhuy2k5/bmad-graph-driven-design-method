# UX Specification: Admin Dashboard Screen (`/admin`)

## 1. Overview & Primary Goal
- **Screen ID:** `AdminDashboard`
- **Route:** `/admin`
- **Required Role:** `ADMIN` (Email Whitelist Guard)
- **Goal:** Moderate comments and manage product catalog directly without a traditional backend service (Zero-Backend architecture via GitHub API & Firestore).
- **Primary Goal & Action:** Ensure catalog integrity and community comment quality securely.
  - **Primary Action (CTA):** "Đăng nhập Admin" (OAuth Login Gate) & "Lưu thay đổi sản phẩm" (Submit Product Form to GitHub).
  - **Primary Style:** Solid brand primary button with high visual weight, secure lock icon / save icon, and distinct loading states.

---

## 2. Visual Hierarchy & Action Downgrading

| Priority | Action | UI Element / Location | Visual Style |
| :--- | :--- | :--- | :--- |
| **Primary** | Admin Login Authentication | `LoginGate` component | High-contrast OAuth button (Google/GitHub) with shield icon |
| **Primary** | Save / Publish Product Edits | `ProductForm` component | Solid Primary CTA button ("Lưu & Deploy qua GitHub") |
| **Secondary** | Delete / Moderate Comment | `CommentList` table/cards | Danger Outline / Soft Red Button with Trash Icon ("Xóa bình luận") |
| **Secondary** | Switch Admin Tabs (Catalog vs Comments) | Header/Sidebar Navigation | Segmented Tab Control / Active highlight pills |
| **Tertiary** | Cancel Form Edit / Reset Fields | `ProductForm` actions | Ghost Button / Neutral border ("Hủy bỏ") |
| **Tertiary** | View Live Product Site Link | Header top-right | External link icon button ("Xem trang sản phẩm") |

---

## 3. In-Page States & Mounted Components Management

### Mounted Islands
- *No global mounted islands directly attached to AdminDashboard node (Admin operates isolated moderation workflows).*

### In-Page States (`inPageStates`: `LoginGate`, `CommentList`, `ProductForm`)

1. **`LoginGate` (Authentication & Access Barrier):**
   - **Goal:** Block unauthorized users before rendering dashboard content.
   - **Interactions & Guard:**
     - User clicks "Đăng nhập Admin" -> Triggers OAuth (Google/GitHub via `loginAdmin`).
     - Check email against `ADMIN_EMAIL` whitelist.
     - **Success:** Dismisses `LoginGate` overlay and displays full Admin Dashboard tabs.
     - **Access Denied Failure:** Displays warning alert: "Tài khoản của bạn không có quyền truy cập trang Admin."

2. **`CommentList` (Moderation Control Panel Tab):**
   - **Goal:** Display real-time list of all product comments with one-click deletion.
   - **Interactions:**
     - Real-time listener (`subscribeToComments`).
     - Click "Xóa bình luận" -> Confirmation modal -> Executes `deleteComment` in Firestore -> Instantly removes comment row with fade animation.

3. **`ProductForm` (Git-based CMS Catalog Manager Tab):**
   - **Goal:** Create or update static product data stored in JSON via GitHub API.
   - **Fields:** Product Title, Slug, Price, Origin, Purity, Video Embed URL, Description, Images.
   - **Interactions:**
     - Submit form -> Triggers `updateProductGit` -> Generates commit to GitHub repository -> Triggers Vercel Build.
     - Displays notification banner: "Đã lưu thay đổi! Hệ thống đang tự động rebuild trang (Vercel Build)."

---

## 4. Edge Cases & UX Micro-States

### A. Non-Whitelisted Account Access Attempt
- **Visual:** Warning Card with red accent border and Lock icon inside `LoginGate`.
- **Text:** "Truy cập bị từ chối: Email của bạn không nằm trong danh sách Quản trị viên."
- **Action CTA:** Secondary Outline Button "Đăng xuất & Thử tài khoản khác".

### B. GitHub API Rate Limit / Network Error (Product Update Failure)
- **Visual:** Danger alert modal top of `ProductForm`.
- **Text:** "Không thể cập nhật dữ liệu qua GitHub API. Vui lòng kiểm tra lại kết nối hoặc Token."
- **Action CTA:** Primary Outline Button "Thử lại" and copy unsaved draft button.

### C. Empty Comment List
- **Visual:** Clean neutral card with chat bubble icon.
- **Text:** "Chưa có bình luận nào cần quản lý."

### D. Loading States (Auth Verification & Git Commit Pending)
- **Visual:**
  - Auth checking: Centered loading spinner with text "Đang kiểm tra quyền truy cập...".
  - Git commit in progress: Primary button turns into spinner state with label "Đang commit & trigger build...".
