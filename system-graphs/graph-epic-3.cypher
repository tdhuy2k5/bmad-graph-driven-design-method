// ==========================================
// EPIC 3: Cart & Direct Checkout Handoff UI Graph
// ==========================================
MERGE (home:UINode {id: "Home"})
MERGE (pdp:UINode {id: "ProductDetail"})

MERGE (cartDrawer:SharedIsland {id: "CartDrawerIsland"})
SET cartDrawer.name = "Global Cart Drawer",
    cartDrawer.goal = "Manage cart items and checkout handoff"

MERGE (productCard:SharedIsland {id: "ProductCardIsland"})

MERGE (zalo:ExternalSystem {id: "ZaloApp"})
SET zalo.name = "Zalo Deep Link"

MERGE (messenger:ExternalSystem {id: "MessengerApp"})
SET messenger.name = "Messenger Deep Link"

MERGE (home)-[:MOUNTS]->(cartDrawer)
MERGE (pdp)-[:MOUNTS]->(cartDrawer)

MERGE (productCard)-[:MUTATES_STATE {
    action: "addToCart",
    location: "components/ProductGrid.tsx",
    trigger: "Click Add to Cart on product grid",
    logic: "Add item to purely client-side Cart state and localStorage",
    stateMutation: "Update Cart count badge"
}]->(productCard)

MERGE (pdp)-[:MUTATES_STATE {
    action: "addToCart",
    location: "components/features/CartProvider.tsx",
    trigger: "Click Add to Cart on product detail",
    logic: "Add item to purely client-side Cart state and localStorage",
    stateMutation: "Update Cart count badge"
}]->(pdp)

MERGE (cartDrawer)-[:MUTATES_STATE {
    action: "updateCartItem",
    location: "components/features/CartDrawer.tsx",
    trigger: "Adjust quantity, clear items, or input delivery details",
    logic: "Update client-side memory and localStorage without DB queries",
    stateMutation: "Update CartDrawer totals and form"
}]->(cartDrawer)

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
}]->(messenger)
