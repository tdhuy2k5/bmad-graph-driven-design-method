// ==========================================
// EPIC 2: Trust & Community Feedback (Comments & Auth) UI Graph
// ==========================================
MERGE (pdp:UINode {id: "ProductDetail"})
SET pdp.name = "/san-pham/[slug]",
    pdp.goal = "Read and write product comments securely",
    pdp.requiredRole = "PUBLIC",
    pdp.inPageStates = "['CommentIsland']"

MERGE (authModal:SharedIsland {id: "AuthModalIsland"})
SET authModal.name = "Global Auth Modal",
    authModal.goal = "Handle user login via Google/GitHub"

MERGE (pdp)-[:MOUNTS]->(authModal)

MERGE (authModal)-[:MUTATES_STATE {
    action: "loginWithOAuth",
    location: "lib/firebase/auth.ts",
    trigger: "Click Google/GitHub login button",
    logic: "Authenticate via Firebase Auth -> Store session locally",
    stateMutation: "Close AuthModal, Show User Profile"
}]->(authModal)

MERGE (pdp)-[:MUTATES_STATE {
    action: "subscribeToComments",
    location: "components/features/CommentIsland.tsx",
    trigger: "Scroll to comments section",
    logic: "Read from Firestore -> Catch quota-exceeded errors gracefully",
    stateMutation: "Render comments list dynamically"
}]->(pdp)

MERGE (pdp)-[:MUTATES_STATE {
    action: "createComment",
    location: "lib/firebase/comments.ts",
    trigger: "Click submit comment",
    requiredRole: "AUTHENTICATED",
    logic: "Validate auth (request.auth != null) -> Write to Firestore",
    stateMutation: "Append new comment to UI via real-time listener"
}]->(pdp)
