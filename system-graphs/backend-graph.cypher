// ========================================
// BACKEND LOGIC GRAPH
// ========================================

// 1. DOMAINS
MERGE (d1:Domain {id: "productCatalog", name: "Product Catalog"})
MERGE (d2:Domain {id: "trustCommunity", name: "Trust & Community Feedback"})
MERGE (d3:Domain {id: "checkoutAndCart", name: "Cart & Checkout Handoff"})
MERGE (d4:Domain {id: "adminModeration", name: "Admin & Moderation (Zero-Backend)"})

// 2. WORKFLOWS
MERGE (w1:Workflow {id: "epic1Catalog", name: "Product Catalog & Discovery", description: "Browse storefront, view product details, filter, manage static catalog"})
MERGE (w2:Workflow {id: "epic2Comments", name: "Trust & Community Feedback (Comments)", description: "Authenticate, view realtime comments, post comments"})
MERGE (w3:Workflow {id: "epic3Checkout", name: "Cart & Direct Checkout Handoff", description: "Cart state management, delivery info, Zalo/Messenger handoff"})
MERGE (w4:Workflow {id: "epic4Admin", name: "Admin & Moderation (Zero-Backend)", description: "Admin auth whitelist, comment moderation, git-based product updates"})

// 3. WORKFLOW STEPS
MERGE (s1_1:WorkflowStep {id: "epic1Catalog_step_1", name: "Fetch Product List (SSG)", order: 1})
MERGE (s1_2:WorkflowStep {id: "epic1Catalog_step_2", name: "Filter Products (Client)", order: 2})
MERGE (s1_3:WorkflowStep {id: "epic1Catalog_step_3", name: "Fetch Product Details (SSG)", order: 3})

MERGE (s2_1:WorkflowStep {id: "epic2Comments_step_1", name: "Authenticate via OAuth", order: 1})
MERGE (s2_2:WorkflowStep {id: "epic2Comments_step_2", name: "Fetch Product Comments Real-time", order: 2})
MERGE (s2_3:WorkflowStep {id: "epic2Comments_step_3", name: "Post Comment", order: 3})

MERGE (s3_1:WorkflowStep {id: "epic3Checkout_step_1", name: "Manage Cart State (Client)", order: 1})
MERGE (s3_2:WorkflowStep {id: "epic3Checkout_step_2", name: "Save Delivery Info (Client)", order: 2})
MERGE (s3_3:WorkflowStep {id: "epic3Checkout_step_3", name: "Generate Handoff Link", order: 3})

MERGE (s4_1:WorkflowStep {id: "epic4Admin_step_1", name: "Admin Authentication", order: 1})
MERGE (s4_2:WorkflowStep {id: "epic4Admin_step_2", name: "Comment Moderation", order: 2})
MERGE (s4_3:WorkflowStep {id: "epic4Admin_step_3", name: "Git-Based Product Management", order: 3})

// 4. SERVICES
MERGE (svc1:Service {id: "CatalogService", description: "Service to read static product data from JSON"})
MERGE (authSvc:Service {id: "AuthService", description: "Firebase Authentication Service"})
MERGE (commentSvc:Service {id: "CommentService", description: "Firestore Comments Service"})
MERGE (cartSvc:Service {id: "CartService", description: "Client-side cart and checkout handoff service (localStorage)"})
MERGE (gitSvc:Service {id: "GitManagementService", description: "GitHub API for content edits"})

// 5. FUNCTIONS
MERGE (f1_1:Function {id: "getProducts", type: "QUERY", input: "", output: "Product[]", desc: "Read all products from static JSON file for SSG", roles: "PUBLIC"})
MERGE (f1_2:Function {id: "getProductBySlug", type: "QUERY", input: "slug: string", output: "Product", desc: "Read specific product details by slug for SSG", roles: "PUBLIC"})

MERGE (f2_1:Function {id: "loginWithOAuth", type: "MUTATION", input: "provider: string", output: "User", desc: "Login via Google/GitHub", roles: "PUBLIC"})
MERGE (f2_2:Function {id: "subscribeToComments", type: "QUERY", input: "productId: string", output: "Comment[]", desc: "Real-time listener for product comments", roles: "PUBLIC"})
MERGE (f2_3:Function {id: "createComment", type: "MUTATION", input: "productId: string, content: string, userId: string", output: "Comment", desc: "Create a new comment", roles: "AUTHENTICATED", guard: "request.auth != null"})

MERGE (f3_1:Function {id: "addToCart", type: "MUTATION", input: "product: Product, quantity: number", output: "CartItem[]", desc: "Add item to cart and save to localStorage", roles: "PUBLIC"})
MERGE (f3_2:Function {id: "updateCartItem", type: "MUTATION", input: "productId: string, quantity: number", output: "CartItem[]", desc: "Update item quantity in cart", roles: "PUBLIC"})
MERGE (f3_3:Function {id: "removeCartItem", type: "MUTATION", input: "productId: string", output: "CartItem[]", desc: "Remove item from cart", roles: "PUBLIC"})
MERGE (f3_4:Function {id: "saveDeliveryInfo", type: "MUTATION", input: "info: DeliveryInfo", output: "void", desc: "Save delivery details to localStorage", roles: "PUBLIC"})
MERGE (f3_5:Function {id: "generateCheckoutLink", type: "UTILITY", input: "cart: CartItem[], info: DeliveryInfo", output: "string", desc: "Generate deep link for Zalo/Messenger handoff", roles: "PUBLIC"})

MERGE (f4_1:Function {id: "loginAdmin", type: "MUTATION", input: "provider: string", output: "User", desc: "Login via Google/GitHub with email whitelist check", roles: "PUBLIC", guard: "email in ADMIN_EMAIL"})
MERGE (f4_2:Function {id: "deleteComment", type: "MUTATION", input: "commentId: string", output: "void", desc: "Delete spam/negative comment", roles: "ADMIN", guard: "currentUser.email == ADMIN_EMAIL"})
MERGE (f4_3:Function {id: "updateProductGit", type: "MUTATION", input: "product: Product", output: "void", desc: "Commit product update to source code via GitHub API", roles: "ADMIN", guard: "currentUser.email == ADMIN_EMAIL"})

// 6. RELATIONSHIPS
MERGE (d1)-[:CONTAINS]->(w1)
MERGE (d2)-[:CONTAINS]->(w2)
MERGE (d3)-[:CONTAINS]->(w3)
MERGE (d4)-[:CONTAINS]->(w4)

MERGE (w1)-[:HAS_STEP]->(s1_1)
MERGE (w1)-[:HAS_STEP]->(s1_2)
MERGE (w1)-[:HAS_STEP]->(s1_3)
MERGE (s1_1)-[:NEXT_STEP]->(s1_2)
MERGE (s1_2)-[:NEXT_STEP]->(s1_3)

MERGE (w2)-[:HAS_STEP]->(s2_1)
MERGE (w2)-[:HAS_STEP]->(s2_2)
MERGE (w2)-[:HAS_STEP]->(s2_3)
MERGE (s2_1)-[:NEXT_STEP]->(s2_2)
MERGE (s2_2)-[:NEXT_STEP]->(s2_3)

MERGE (w3)-[:HAS_STEP]->(s3_1)
MERGE (w3)-[:HAS_STEP]->(s3_2)
MERGE (w3)-[:HAS_STEP]->(s3_3)
MERGE (s3_1)-[:NEXT_STEP]->(s3_2)
MERGE (s3_2)-[:NEXT_STEP]->(s3_3)

MERGE (w4)-[:HAS_STEP]->(s4_1)
MERGE (w4)-[:HAS_STEP]->(s4_2)
MERGE (w4)-[:HAS_STEP]->(s4_3)
MERGE (s4_1)-[:NEXT_STEP]->(s4_2)
MERGE (s4_2)-[:NEXT_STEP]->(s4_3)

MERGE (svc1)-[:OWNS]->(f1_1)
MERGE (svc1)-[:OWNS]->(f1_2)

MERGE (authSvc)-[:OWNS]->(f2_1)
MERGE (commentSvc)-[:OWNS]->(f2_2)
MERGE (commentSvc)-[:OWNS]->(f2_3)

MERGE (cartSvc)-[:OWNS]->(f3_1)
MERGE (cartSvc)-[:OWNS]->(f3_2)
MERGE (cartSvc)-[:OWNS]->(f3_3)
MERGE (cartSvc)-[:OWNS]->(f3_4)
MERGE (cartSvc)-[:OWNS]->(f3_5)

MERGE (authSvc)-[:OWNS]->(f4_1)
MERGE (commentSvc)-[:OWNS]->(f4_2)
MERGE (gitSvc)-[:OWNS]->(f4_3)

MERGE (s1_1)-[:EXECUTES]->(f1_1)
MERGE (s1_3)-[:EXECUTES]->(f1_2)
MERGE (s2_1)-[:EXECUTES]->(f2_1)
MERGE (s2_2)-[:EXECUTES]->(f2_2)
MERGE (s2_3)-[:EXECUTES]->(f2_3)
MERGE (s3_1)-[:EXECUTES]->(f3_1)
MERGE (s3_1)-[:EXECUTES]->(f3_2)
MERGE (s3_1)-[:EXECUTES]->(f3_3)
MERGE (s3_2)-[:EXECUTES]->(f3_4)
MERGE (s3_3)-[:EXECUTES]->(f3_5)
MERGE (s4_1)-[:EXECUTES]->(f4_1)
MERGE (s4_2)-[:EXECUTES]->(f4_2)
MERGE (s4_3)-[:EXECUTES]->(f4_3);
