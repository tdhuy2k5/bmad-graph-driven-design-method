### Product Catalog (Static Data Build-Time)
- Endpoint: GET data/products.json
- Target UI Nodes: Home, ProductDetail
- Request Payload (Body/Query):
  - productId: string (optional, for specific product fetch)
- Response (2xx Success):
  - id: string
  - slug: string
  - name: string
  - description: string
  - price: integer
  - stockStatus: string
  - youtubeVideoId: string
  - origin: string
  - purity: string
  - intendedUse: string
  - imageUrls: array of strings
- Response (Error 4xx/5xx):
  - error: string (Build-time error)

### Authentication (Firebase Auth)
- Endpoint: POST firebase/auth/signInWithPopup
- Target UI Nodes: AuthModalIsland
- Request Payload (Body/Query):
  - provider: string (required, "Google" | "GitHub")
- Response (2xx Success):
  - uid: string
  - displayName: string
  - email: string
  - photoURL: string
- Response (Error 4xx/5xx):
  - code: string
  - message: string

### Fetch Comments (Firestore)
- Endpoint: GET comments/{productId}/entries (onSnapshot listener)
- Target UI Nodes: ProductDetail
- Request Payload (Body/Query):
  - productId: string (required)
- Response (2xx Success):
  - id: string
  - authorUid: string
  - authorDisplayName: string
  - body: string
  - createdAt: timestamp
- Response (Error 4xx/5xx):
  - code: string (e.g., 'resource-exhausted')
  - message: string (Handled gracefully per quota constraints)

### Submit Comment (Firestore)
- Endpoint: POST comments/{productId}/entries
- Target UI Nodes: ProductDetail
- Request Payload (Body/Query):
  - productId: string (required)
  - body: string (required)
  - authorUid: string (required)
  - authorDisplayName: string (required)
- Response (2xx Success):
  - id: string
  - createdAt: timestamp
- Response (Error 4xx/5xx):
  - code: string (e.g., 'permission-denied')
  - message: string (e.g., 'request.auth != null required')

### Checkout Handoff Metrics (Firestore)
- Endpoint: PATCH metrics/clicks/{productId} (Firestore Increment)
- Target UI Nodes: CartDrawerIsland
- Request Payload (Body/Query):
  - productId: string (required)
  - clickCount: integer (required, increment by 1)
- Response (2xx Success):
  - success: boolean
- Response (Error 4xx/5xx):
  - code: string
  - message: string

### Zalo / Messenger Handoff (Pure Client URL Encoding)
- Endpoint: GET https://zalo.me/{OA_ID} or https://m.me/{PAGE_ID}
- Target UI Nodes: CartDrawerIsland
- Request Payload (Body/Query):
  - text: string (required, URI-encoded cart summary and delivery details)
- Response (2xx Success):
  - redirect: string (External App)
- Response (Error 4xx/5xx):
  - error: string (Client validation failure on delivery details)
