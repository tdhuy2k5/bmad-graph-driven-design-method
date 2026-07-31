---
stepsCompleted: ["step-01-validate-prerequisites.md", "step-02-design-epics.md", "step-03-create-stories.md", "step-04-final-validation.md"]
inputDocuments: ["d:\\Documents\\TruongAnCao\\_bmad-output\\planning-artifacts\\prds\\prd-TruongAnCao-2026-07-23\\prd.md", "d:\\Documents\\TruongAnCao\\_bmad-output\\planning-artifacts\\architecture\\custom-architecture-spine\\ARCHITECTURE-SPINE.md"]
---

# TruongAnCao - Epic Breakdown

## Overview

This document provides the complete epic and story breakdown for TruongAnCao, decomposing the requirements from the PRD, UX Design if it exists, and Architecture requirements into implementable stories.

## Requirements Inventory

### Functional Requirements

FR1.1: Users can view the catalog with filtering capabilities (by product origin, purity, and intended use).
FR1.2: Product pages must be Server-Side Rendered (SSR) or Statically Generated (SSG) for Google indexing.
FR1.3: PDPs must support embedded video players for product demonstrations.
FR2.1: Comments load dynamically on the PDP.
FR2.2: Users can submit a comment. The UI updates instantly via Firestore real-time listeners. Comments are post-only (no edit or delete capabilities for users).
FR2.3: Users must log in via Google/GitHub to comment to prevent spam.
FR3.1: Users can add multiple products to a Cart Drawer and fill in their delivery details. Clicking "Đặt hàng ngay qua Zalo" (or Messenger) generates a deep link to the business's Zalo account (or Messenger fallback) with a pre-filled message containing the delivery info and the list of items with quantities.
FR4.1: Products are managed directly in the codebase (e.g., local JSON or config files) rather than a database. Updates to products are made via code commits and deployed through Vercel CI/CD, accepting the build latency.

### NonFunctional Requirements

NFR1: The frontend must load instantly and feel premium (React/Tailwind).
NFR2: Use Firebase for backend-as-a-service. The project MUST remain strictly on the free Spark plan (no credit card registration). The frontend UI must gracefully catch and handle quota-exceeded errors.
NFR3: NO integrated payment gateways (Stripe, VNPay). NO real-time in-app order status tracking. NO automated inventory deduction mapping.

### Additional Requirements

- AD-1: Strict SSG Catalog - All product and catalog routes MUST use `dynamicParams = false` and be Statically Generated (SSG) at build time. SSR is strictly forbidden.
- AD-2: BaaS Client Islands - Dynamic features must be implemented strictly as Client Components. Server components must NEVER import or invoke the Firebase SDK.
- AD-3: Client-Only Checkout State - The Cart must rely purely on client-side state and `localStorage`. Handoff computed synchronously in browser.
- AD-4: Static Data Boundary - Product data must be managed exclusively within the codebase. Firestore must NOT be used to store or fetch product catalog data.
- AD-5: Trusted Security Boundary - Firestore Security Rules (`request.auth != null`) are the sole enforcement layer for write operations.

### UX Design Requirements

No UX design documents provided.

### FR Coverage Map

FR1.1: Epic 1 - Catalog browsing and filtering
FR1.2: Epic 1 - SSG and SEO optimization
FR1.3: Epic 1 - Embedded video previews
FR2.1: Epic 2 - Viewing dynamic comments
FR2.2: Epic 2 - Posting comments via Firestore
FR2.3: Epic 2 - Google/GitHub Authentication
FR3.1: Epic 3 - Cart and Zalo/Messenger handoff
FR4.1: Epic 1 - Codebase static catalog management

## Epic List

### Epic 1: Product Catalog & Discovery
Users can browse the storefront, view product details (including videos), use filters to find the right products, and experience lightning-fast load times with full SEO indexing. The business owner can manage this catalog purely via codebase commits.
**FRs covered:** FR1.1, FR1.2, FR1.3, FR4.1

### Epic 2: Trust & Community Feedback (Comments)
Users can read public product comments to build trust, securely log in via Google/GitHub, and leave their own real-time feedback.
**FRs covered:** FR2.1, FR2.2, FR2.3

### Epic 3: Cart & Direct Checkout Handoff
Users can gather multiple products in a cart, input delivery details, and seamlessly hand off their order directly to the business owner via Zalo or Messenger without dealing with a payment gateway.
**FRs covered:** FR3.1

## Epic 1: Product Catalog & Discovery

Users can browse the storefront, view product details (including videos), use filters to find the right products, and experience lightning-fast load times with full SEO indexing. The business owner can manage this catalog purely via codebase commits.

### Story 1.1: Static Catalog Data Foundation

As a Business Owner,
I want to manage product data directly in a local codebase file,
So that I can easily update my catalog without needing a backend database or CMS.

**Acceptance Criteria:**

**Given** the developer has access to the codebase
**When** they populate `data/products.json` (or `.ts`) with product details (id, name, price in VND integers, description, images, origin, purity, intended use)
**Then** the application can successfully read and parse this static data via utility functions
**And** any changes committed to this file will trigger a new Vercel build to update the static catalog.

### Story 1.2: Product Listing Page with SSG

As a Health Buyer,
I want to view a fast, SEO-optimized list of natural products,
So that I can quickly see what the store offers.

**Acceptance Criteria:**

**Given** the static list of products exists
**When** the user visits the home page (`/`)
**Then** they see a grid of all available products with images, names, and prices
**And** the page must be statically generated (SSG) at build time with `dynamicParams = false` (no SSR).

### Story 1.3: Product Filtering

As a Health Buyer,
I want to filter the product list by origin, purity, and intended use,
So that I can easily find the specific natural health products I need.

**Acceptance Criteria:**

**Given** the user is on the product listing page
**When** the user selects a filter option (e.g., origin: nature, purity: 100%)
**Then** the product grid immediately updates to show only matching products
**And** this filtering happens entirely on the client side without triggering a page reload or database query.

### Story 1.4: Product Detail Page with Video Previews

As a Health Buyer,
I want to view detailed product information and watch demonstration videos,
So that I can make an informed purchasing decision.

**Acceptance Criteria:**

**Given** the user clicks on a product from the listing
**When** they navigate to `/san-pham/[slug]`
**Then** they see the full product description, high-quality images, and an embedded video player (YouTube/Firebase Storage)
**And** the page is statically generated (SSG) at build time using `generateStaticParams`.

## Epic 2: Trust & Community Feedback (Comments)

Users can read public product comments to build trust, securely log in via Google/GitHub, and leave their own real-time feedback.

### Story 2.1: Google/GitHub Authentication

As a Health Buyer,
I want to securely log in using my existing Google or GitHub account,
So that I can leave verified comments without creating a new password.

**Acceptance Criteria:**

**Given** the user is viewing the comments section on a product page
**When** they click "Log in to comment"
**Then** they are presented with options to sign in via Google or GitHub using Firebase Authentication
**And** upon successful login, their user profile (name, avatar) is securely stored in the client session.

### Story 2.2: Dynamic Comments Display

As a Health Buyer,
I want to read comments left by other users on a product,
So that I can see real reviews and build trust in the product.

**Acceptance Criteria:**

**Given** the user is viewing a product detail page
**When** they scroll to the comments section
**Then** a Client Component fetches and displays all comments for this specific product ID from Firestore
**And** the UI gracefully handles any Firebase quota-exceeded errors by showing a "Comments temporarily unavailable" message instead of crashing the page.

### Story 2.3: Post Comment and Security Rules

As a Logged-in Buyer,
I want to submit my own comment on a product,
So that I can share my experience with the community.

**Acceptance Criteria:**

**Given** the user is authenticated via Firebase Auth
**When** they type a comment and click submit
**Then** the comment is saved to Firestore under the product's sub-collection and appears instantly in the UI via a real-time listener
**And** Firestore Security Rules strictly enforce that only authenticated users can create comments (`request.auth != null`) and no user can edit or delete comments.

## Epic 3: Cart & Direct Checkout Handoff

Users can gather multiple products in a cart, input delivery details, and seamlessly hand off their order directly to the business owner via Zalo or Messenger without dealing with a payment gateway.

### Story 3.1: Client-Side Cart State Management

As a Health Buyer,
I want my selected products to be saved in a cart even if I refresh the page,
So that I don't lose my potential order while browsing.

**Acceptance Criteria:**

**Given** the user adds an item to the cart
**When** they refresh the browser or navigate between static pages
**Then** the cart items and quantities are preserved
**And** the state management relies purely on client-side memory and `localStorage` without any database queries.

### Story 3.2: Cart Drawer UI

As a Health Buyer,
I want to easily review what's in my cart and the total cost,
So that I can confirm my order before checkout.

**Acceptance Criteria:**

**Given** the user has items in their cart
**When** they click the cart icon in the navigation
**Then** a side drawer opens showing all items, individual prices, adjustable quantities, and the calculated total (in VND integers)
**And** users can remove items or clear the entire cart from this UI.

### Story 3.3: Delivery Details Form

As a Health Buyer,
I want to enter my delivery information once and have it remembered,
So that subsequent purchases are faster.

**Acceptance Criteria:**

**Given** the user is in the Cart Drawer ready to check out
**When** they proceed to the delivery details section
**Then** they are presented with a form for Name, Phone Number, and Address
**And** these details are validated (non-empty) and saved to `localStorage` for future visits.

### Story 3.4: Zalo/Messenger Checkout Handoff

As a Health Buyer,
I want to instantly send my compiled order to the business owner via chat,
So that I can finalize payment and shipping securely with a real person.

**Acceptance Criteria:**

**Given** the cart has items and the delivery form is valid
**When** the user clicks "Đặt hàng ngay qua Zalo" (or Messenger)
**And** the browser opens a deep link (`zalo://` or web fallback) to the business's account with the message pre-filled and fully URL-encoded (`encodeURIComponent()`).

## Epic 4: Admin & Moderation (Zero-Backend)

Cung cấp giao diện cho Admin để kiểm duyệt bình luận (Firestore) và cập nhật sản phẩm (Git Commit) mà không phá vỡ kiến trúc Zero-Backend.

### Story 4.1: Admin Authentication (Whitelist)

**User:** Chủ cửa hàng (Admin).
**Hành động:** Truy cập route `/admin`, yêu cầu đăng nhập bằng Google/GitHub.
**Điều kiện (Guard):** Email đăng nhập phải nằm trong danh sách Whitelist (kiểm tra qua biến môi trường `ADMIN_EMAIL`). Nếu không khớp, UI báo lỗi và từ chối truy cập.

### Story 4.2: Comment Moderation (Kiểm duyệt Bình luận)

**User:** Admin.
**Hành động:** Xem danh sách toàn bộ bình luận của khách hàng trên tất cả sản phẩm. Có thể bấm nút "Xóa" đối với các bình luận spam/tiêu cực.
**Điều kiện (Guard):** Hàm xóa bình luận trên Firestore yêu cầu quyền ADMIN (`currentUser.email == ADMIN_EMAIL`).

### Story 4.3: Git-Based Product Management (Tùy chọn)

**User:** Admin.
**Hành động:** Xem danh sách sản phẩm (đọc từ file JSON tĩnh). Khi nhấn "Sửa" hoặc "Thêm mới", điền form và nhấn "Lưu".
**Luồng xử lý (Quan trọng):** Thay vì lưu vào Database, hàm này sẽ gọi **GitHub API** (hoặc tạo file JSON tải về) để commit trực tiếp vào source code, kích hoạt Vercel tự động deploy lại toàn bộ trang web (chấp nhận độ trễ vài phút để build SSG).
