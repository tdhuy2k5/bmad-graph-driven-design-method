// ==========================================
// GRAPH MASTER (FRONTEND SYSTEM GRAPH)
// ==========================================

// 1. CREATE NODES
MERGE (home:UINode {id: "Home"})
SET home.name = "/", 
    home.goal = "View SEO-optimized list of products", 
    home.requiredRole = "PUBLIC",
    home.inPageStates = "['ProductGrid', 'FilterOptions']"

MERGE (pdp:UINode {id: "ProductDetail"})
SET pdp.name = "/san-pham/[slug]", 
    pdp.goal = "Display product details and embedded videos", 
    pdp.requiredRole = "PUBLIC",
    pdp.inPageStates = "['VideoPlayer']"

MERGE (adminDash:UINode {id: "AdminDashboard"})
SET adminDash.name = "/admin",
    adminDash.goal = "Moderate comments and manage product catalog",
    adminDash.requiredRole = "ADMIN",
    adminDash.inPageStates = "['LoginGate', 'CommentList', 'ProductForm']"

MERGE (productCard:SharedIsland {id: "ProductCardIsland"})
SET productCard.name = "Reusable Product Card",
    productCard.goal = "Display product snippet and handle quick actions"

MERGE (authModal:SharedIsland {id: "AuthModalIsland"})
SET authModal.name = "Global Auth Modal",
    authModal.goal = "Handle user login via Google/GitHub"

MERGE (cartDrawer:SharedIsland {id: "CartDrawerIsland"})
SET cartDrawer.name = "Global Cart Drawer",
    cartDrawer.goal = "Manage cart items and checkout handoff"

MERGE (zalo:ExternalSystem {id: "ZaloApp"})
SET zalo.name = "Zalo Deep Link"

MERGE (messenger:ExternalSystem {id: "MessengerApp"})
SET messenger.name = "Messenger Deep Link"

// 2. CREATE EDGES - MOUNTS
MERGE (home)-[:MOUNTS]->(productCard)
MERGE (pdp)-[:MOUNTS]->(productCard)
MERGE (pdp)-[:MOUNTS]->(authModal)
MERGE (home)-[:MOUNTS]->(cartDrawer)
MERGE (pdp)-[:MOUNTS]->(cartDrawer)

// 3. CREATE EDGES - MUTATES_STATE
MERGE (home)-[:MUTATES_STATE {
    action: "filterProducts",
    location: "components/features/ProductFilter.tsx",
    trigger: "Select filter option (origin, purity, intended use)",
    logic: "Filter local product data purely on client-side",
    sends: "filterOptions: Object",
    stateMutation: "Update ProductGrid list"
}]->(home)

MERGE (authModal)-[:MUTATES_STATE {
    action: "loginWithOAuth",
    location: "lib/firebase/auth.ts",
    trigger: "Click Google/GitHub login button",
    logic: "Authenticate via Firebase Auth -> Store session locally",
    sends: "provider: string",
    stateMutation: "Close AuthModal, Show User Profile"
}]->(authModal)

MERGE (pdp)-[:MUTATES_STATE {
    action: "subscribeToComments",
    location: "components/features/CommentIsland.tsx",
    trigger: "Scroll to comments section",
    logic: "Read from Firestore -> Catch quota-exceeded errors gracefully",
    sends: "productId: string",
    stateMutation: "Render comments list dynamically"
}]->(pdp)

MERGE (pdp)-[:MUTATES_STATE {
    action: "createComment",
    location: "lib/firebase/comments.ts",
    trigger: "Click submit comment",
    requiredRole: "AUTHENTICATED",
    logic: "Validate auth (request.auth != null) -> Write to Firestore",
    sends: "productId: string, content: string, userId: string",
    stateMutation: "Append new comment to UI via real-time listener"
}]->(pdp)

MERGE (productCard)-[:MUTATES_STATE {
    action: "addToCart",
    location: "components/ProductGrid.tsx",
    trigger: "Click Add to Cart on product grid",
    logic: "Add item to purely client-side Cart state and localStorage",
    sends: "product: Product, quantity: number",
    stateMutation: "Update Cart count badge"
}]->(productCard)

MERGE (pdp)-[:MUTATES_STATE {
    action: "addToCart",
    location: "components/features/CartProvider.tsx",
    trigger: "Click Add to Cart on product detail",
    logic: "Add item to purely client-side Cart state and localStorage",
    sends: "product: Product, quantity: number",
    stateMutation: "Update Cart count badge"
}]->(pdp)

MERGE (cartDrawer)-[:MUTATES_STATE {
    action: "updateCartItem",
    location: "components/features/CartDrawer.tsx",
    trigger: "Adjust quantity in cart drawer",
    logic: "Update client-side memory and localStorage without DB queries",
    sends: "productId: string, quantity: number",
    stateMutation: "Update CartDrawer totals and form"
}]->(cartDrawer)

MERGE (cartDrawer)-[:MUTATES_STATE {
    action: "removeCartItem",
    location: "components/features/CartDrawer.tsx",
    trigger: "Click remove item from cart drawer",
    logic: "Remove item from client-side memory and localStorage",
    sends: "productId: string",
    stateMutation: "Update CartDrawer totals and items list"
}]->(cartDrawer)

MERGE (cartDrawer)-[:MUTATES_STATE {
    action: "saveDeliveryInfo",
    location: "components/features/CartDrawer.tsx",
    trigger: "Input delivery details (fullName, phone, address)",
    logic: "Save delivery info to localStorage",
    sends: "info: DeliveryInfo",
    stateMutation: "Update CartDrawer delivery form"
}]->(cartDrawer)

MERGE (adminDash)-[:MUTATES_STATE {
    action: "loginAdmin",
    location: "components/admin/LoginGate.tsx",
    trigger: "Click Login with Google/GitHub",
    logic: "Authenticate via Firebase -> Check whitelist",
    sends: "provider: string",
    stateMutation: "Show dashboard if whitelisted, otherwise show error"
}]->(adminDash)

MERGE (adminDash)-[:MUTATES_STATE {
    action: "deleteComment",
    location: "components/admin/CommentList.tsx",
    trigger: "Click Delete on a comment",
    requiredRole: "ADMIN",
    logic: "Call Firestore delete -> Verify ADMIN role",
    sends: "commentId: string",
    stateMutation: "Remove comment from list"
}]->(adminDash)

MERGE (adminDash)-[:MUTATES_STATE {
    action: "updateProductGit",
    location: "components/admin/ProductForm.tsx",
    trigger: "Submit Product form",
    requiredRole: "ADMIN",
    logic: "Generate JSON -> Commit via GitHub API -> Trigger Vercel Build",
    sends: "product: Product",
    stateMutation: "Show success notification and clear form"
}]->(adminDash)

// 4. CREATE EDGES - NAVIGATES_TO
MERGE (productCard)-[:NAVIGATES_TO {
    action: "getProductBySlug",
    location: "components/ProductGrid.tsx",
    trigger: "Click product card or Xem chi tiết button",
    logic: "Navigate to static PDP route"
}]->(pdp)

MERGE (cartDrawer)-[:NAVIGATES_TO {
    action: "generateCheckoutLink",
    location: "lib/zalo/handoff.ts",
    trigger: "Click Đặt hàng ngay qua Zalo",
    logic: "Compute order summary string -> encodeURIComponent -> Open deep link"
}]->(zalo)

MERGE (cartDrawer)-[:NAVIGATES_TO {
    action: "generateCheckoutLink",
    location: "lib/zalo/handoff.ts",
    trigger: "Click Messenger fallback",
    logic: "Compute order summary string -> encodeURIComponent -> Open deep link"
}]->(messenger);

