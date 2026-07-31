// ==========================================
// EPIC 1: Product Catalog & Discovery UI Graph
// ==========================================
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

MERGE (productCard:SharedIsland {id: "ProductCardIsland"})
SET productCard.name = "Reusable Product Card",
    productCard.goal = "Display product snippet and handle quick actions"

MERGE (home)-[:MOUNTS]->(productCard)
MERGE (pdp)-[:MOUNTS]->(productCard)

MERGE (home)-[:MUTATES_STATE {
    action: "filterProducts",
    location: "components/features/ProductFilter.tsx",
    trigger: "Select filter option (origin, purity, intended use)",
    logic: "Filter local product data purely on client-side",
    stateMutation: "Update ProductGrid list"
}]->(home)

MERGE (productCard)-[:NAVIGATES_TO {
    action: "getProductBySlug",
    location: "components/ProductGrid.tsx",
    trigger: "Click product card or Xem chi tiết button",
    logic: "Navigate to static PDP route"
}]->(pdp)
