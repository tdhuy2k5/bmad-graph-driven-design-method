// CommentService.ts
// Firestore Comments Service

export interface Comment {
  id: string;
  productId: string;
  userId: string;
  content: string;
  createdAt: string;
}

export class CommentService {
  /**
   * Real-time listener for product comments
   * Roles: PUBLIC
   * @param productId string
   * @returns Comment[]
   */
  public async subscribeToComments(productId: string): Promise<Comment[]> {
    // TODO: Implement Firestore real-time listener for comments by productId
    // e.g., onSnapshot(collection(db, "comments"), where("productId", "==", productId), ...)
    console.log(`Subscribing to comments for product ${productId}`);
    return [];
  }

  /**
   * Create a new comment
   * Roles: AUTHENTICATED (guard: request.auth != null)
   * @param productId string
   * @param content string
   * @param userId string
   * @returns Comment
   */
  public async createComment(productId: string, content: string, userId: string): Promise<Comment> {
    // TODO: Implement Firestore document creation
    // e.g., addDoc(collection(db, "comments"), { productId, content, userId, createdAt: new Date() })
    console.log(`Creating comment for product ${productId} by user ${userId}`);
    
    return {
      id: "generated-id",
      productId,
      userId,
      content,
      createdAt: new Date().toISOString()
    };
  }

  /**
   * Delete spam/negative comment
   * Roles: ADMIN (guard: currentUser.email == ADMIN_EMAIL)
   * @param commentId string
   * @returns void
   */
  public async deleteComment(commentId: string): Promise<void> {
    // TODO: Implement Firestore document deletion
    // e.g., deleteDoc(doc(db, "comments", commentId))
    console.log(`Deleting comment ${commentId}`);
  }
}
