---
title: "Zero-Backend Natural Products Ecommerce"
created: "2026-07-23"
updated: "2026-07-23"
status: "final"
---

# PRD: Zero-Backend Natural Products Ecommerce

## 0. Document Purpose
This PRD defines the requirements for a "zero-backend" e-commerce storefront for natural health products. It builds upon the initial product brief, outlining the core user journeys, features, and technical constraints required for the MVP launch.

## 1. Vision
To provide a fast, SEO-optimized, premium digital catalog for natural health products and bone broths that captures customer intent without the overhead of a traditional e-commerce backend. By funneling all checkouts directly into Zalo or Messenger, the business retains the high-trust, consultative relationship critical for health products, while completely avoiding payment gateway fees and complex order state management.

## 2. Target User

### 2.1 Jobs To Be Done
- **The Health Buyer:** "I want to research natural health products, read reviews to build trust, and easily contact the seller to place an order or ask questions."
- **The Business Owner:** "I want a professional website that attracts Google traffic and showcases my products, but I don't want to pay Shopify fees or manage a complex dashboard."

### 2.2 Key User Journeys

- **UJ-1. Lan discovers bone broth and orders via Zalo.**
  - **Context:** Lan is looking for healthy bone broth for her family and finds the site via Google search. 
  - **Entry state:** Unauthenticated, lands on a Product Detail Page (PDP).
  - **Path:** She reads the description, watches the video, and reads public comments. She clicks "Thêm vào giỏ" (Add to cart). She reviews her cart and clicks "Đặt hàng ngay" (Order now). 
  - **Climax:** She is redirected to Zalo with a pre-filled message detailing her order. She hits send to the business owner.
  - **Resolution:** The business owner replies in Zalo to confirm payment and shipping. The website's job is done.

- **UJ-2. Admin updates a product price.**
  - **Context:** The business owner needs to adjust the price of a popular product.
  - **Entry state:** Authenticated as Admin (via whitelisted email).
  - **Path:** Navigates to the hidden `/admin` route. Selects the product, updates the price field, and clicks save.
  - **Climax:** The Firestore database updates immediately, and Vercel triggers a background rebuild (ISR) to update the public static page.
  - **Resolution:** The new price is live.

## 3. Glossary
- **Zero-Backend:** Architecture where there is no custom server code for order processing; all dynamic state (cart, auth, comments) relies on BaaS (Firebase) and static generation (Vercel/Next.js).
- **Zalo Handoff:** The mechanism of compiling cart data into a deep link (`zalo://` or web URL) to initiate a chat with the owner.
- **BaaS:** Backend-as-a-Service (specifically Firebase for this project).

## 4. Features

### 4.1. Public Storefront (Vietnamese UI)
**Description:** A fully Vietnamese, SEO-optimized catalog presenting the products with high-quality media. Realizes UJ-1.

**Functional Requirements:**
- **FR-1.1 Product Listing:** Users can view the catalog with filtering capabilities (by product origin [nature vs animal], product purity [materials and percentages], and intended use).
- **FR-1.2 SEO Optimization:** Product pages must be Server-Side Rendered (SSR) or Statically Generated (SSG) for Google indexing.
- **FR-1.3 Video Previews:** PDPs must support embedded video players for product demonstrations. [ASSUMPTION: Videos hosted on Firebase Storage or YouTube embeds].

### 4.2. Public Comments (Real-time)
**Description:** Users can leave public comments/reviews on products to build trust. Realizes UJ-1.

**Functional Requirements:**
- **FR-2.1 View Comments:** Comments load dynamically on the PDP.
- **FR-2.2 Post Comment:** Users can submit a comment. The UI updates instantly via Firestore real-time listeners. Comments are post-only (no edit or delete capabilities for users).
- **FR-2.3 Authentication for Comments:** [ASSUMPTION: Users must log in via Google/GitHub to comment to prevent spam].

### 4.3. Cart and Zalo Handoff
**Description:** The checkout process bypassing payment gateways, allowing users to collect multiple items before handoff. Realizes UJ-1.

**Functional Requirements:**
- **FR-3.1 Cart and Order Handoff:** Users can add multiple products to a Cart Drawer and fill in their delivery details. Clicking "Đặt hàng ngay qua Zalo" (or Messenger) generates a deep link to the business's Zalo account (or Messenger fallback) with a pre-filled message containing the delivery info and the list of items with quantities.

### 4.4. Catalog Management
**Description:** Managing the product catalog.

**Functional Requirements:**
- **FR-4.1 Static Catalog:** Products are managed directly in the codebase (e.g., local JSON or config files) rather than a database. Updates to products are made via code commits and deployed through Vercel CI/CD, accepting the build latency.

## 5. Non-Functional Requirements (NFRs)
- **NFR-1 Performance**: The frontend must load instantly and feel premium (React/Tailwind). 
- **NFR-2 BaaS Architecture & Free Tier Constraint**: Use Firebase for backend-as-a-service. The project MUST remain strictly on the free Spark plan (no credit card registration). The frontend UI must gracefully catch and handle quota-exceeded errors (e.g., if Firestore reads exceed 50k/day, the app should show a friendly "Comments temporarily unavailable" message rather than breaking the core storefront or checkout flow).
- **NFR-3 Scope Boundaries**: NO integrated payment gateways (Stripe, VNPay). NO real-time in-app order status tracking. NO automated inventory deduction mapping.

## 6. Non-Goals (Explicit)
- **Payment Processing:** No Stripe, VNPay, or Momo integration.
- **Order State Tracking:** No "shipped", "processing", or "delivered" statuses on the website.
- **Automated Inventory:** No automatic deduction of stock when an order is placed (since sales happen in chat).

## 7. MVP Scope
### 7.1 In Scope
- Next.js storefront (Vietnamese).
- Firebase Authentication (Google/GitHub) for comments.
- Firestore for real-time comments and click metrics.
- Cart Drawer and LocalStorage for saved addresses.
- Zalo/Messenger checkout handoff.
- Static product management via codebase.

### 7.2 Out of Scope for MVP
- Admin Dashboard.
- Custom domain email accounts.
- Loyalty point systems.

## 8. Success Metrics
**Primary**
- **SM-1: Lead Conversion:** % of sessions that result in a "Đặt hàng ngay" click. Validates FR-3.1.
- **SM-2: SEO Traffic:** Organic search volume. Validates FR-1.2.

**Secondary**
- **SM-3: Admin Time:** Time taken to update a product price. Validates FR-4.1.

## 9. Open Questions
1. **Zalo API Limits:** Are there character limits for Zalo pre-filled messages that might truncate large carts?
2. **Comment Moderation:** Does the admin need the ability to delete or hide inappropriate public comments in v1?

## 10. Assumptions Index
- **[ASSUMPTION]** Videos will be hosted on Firebase Storage or embedded via YouTube.
- **[ASSUMPTION]** Users must authenticate (Google/GitHub) to leave a public comment to prevent spam.
- **[ASSUMPTION]** Messenger is offered as a secondary fallback if the user does not use Zalo.
