# Quy trình Phát triển Graph-Driven (Greenfield)
> Từ Ý tưởng → Code chạy được. Áp dụng cho mọi project mới.

---

## Tại sao chọn Graph-Driven? (So sánh phương pháp)

| Tiêu chí | BMad thuần (Text-driven) | Cursor/Copilot (Vibe coding) | **Graph-Driven (Hiện tại)** |
|---|---|---|---|
| Tính nhất quán | Trung bình | Thấp | **Cao (Được quy định cứng bởi Đồ thị)** |
| Phát hiện lỗi sớm | Muộn (ở lúc sinh code) | Rất muộn (lúc chạy runtime) | **Rất sớm (Bắt ngay từ khâu thiết kế Graph)** |
| Khả năng lặp lại | Khó | Không thể | **Hoàn toàn lặp lại (Chạy theo từng module nhỏ)** |
| Phụ thuộc model mạnh | Cao | Rất cao | **Thấp (Gemini 3.1 Pro có thể gánh được hầu hết các bước)** |
| Tỷ lệ Halucinate (Ảo giác) | Trung bình | Cao (Dễ tràn context) | **Cực thấp (Do chia nhỏ file Todo và dùng lệnh MERGE)** |
| Đường cong học tập | Thấp | Rất thấp | **Trung bình - Cao** |
| Phù hợp dự án lớn | Trung bình | Kém | **Rất Tốt** |

### ⚠️ Điểm còn thiếu sót của Workflow này (Cần cải thiện trong tương lai)
Dù đạt 8.5/10 điểm hoàn thiện, hệ thống này vẫn còn một số điểm mù cần lưu ý:
1. **Thiếu Phase Automated Testing:** Pipeline kết thúc ở bước Inject Logic (Code chạy được) nhưng chưa có bước sinh Unit Test hoặc E2E Test tự động từ Đồ thị. Hiện tại phải test tay từng luồng.
2. **Chưa có Rollback/Version Control cho Graph:** Các file `.cypher` đang được ghi nối liên tục. Nếu AI lỡ sinh sai một Node và lưu vào file, hiện chưa có cơ chế tự động snapshot/rollback lại phiên bản Graph trước đó ngoài việc dùng Git thủ công.
3. **Thiếu Cypher Lint (Bắt lỗi cú pháp Cypher):** Nếu AI vô tình quên đóng ngoặc `}` khi viết Cypher, lỗi này sẽ lọt vào file và làm crash quá trình Verify sau đó. Hiện chưa có bước "Linting" tự động chặn lỗi cú pháp này trước khi ghi file.
4. **Cơ chế Error Recovery chưa rõ ràng:** Nếu lệnh `/verify-graph-alignment` báo đỏ (Lỗi), quy trình hiện tại đòi hỏi con người phải tự mở file `.cypher` để sửa tay. AI chưa có khả năng tự động đọc log lỗi và vá Graph.
5. Chưa xây dựng xong cơ chết MCP Local cho Neo4j desktop để kết nối Agent
---

## Ký hiệu
| Ký hiệu | Ý nghĩa |
|---|---|
| 🤖 | AI tự động làm, người dùng chỉ kích hoạt |
| 👤 | **Bắt buộc có Con người can thiệp** |
| 🔁 | Bước cần lặp lại nhiều lần |
| ✅ | Điểm kiểm tra (Checkpoint) — phải pass mới đi tiếp |
| 💬 | Mở khung chat mới |

---

## PHASE 0 — Planning (BMad)
> **Mục tiêu:** Biến ý tưởng thành tài liệu cứng để AI có thể đọc và thực thi.

---

### Bước 0.1 — Product Brief
💬 **Mở chat mới** | Lệnh: `bmad-agent-analyst`

| Ai làm | Việc phải làm |
|---|---|
| 🤖 | Agent Mary (Analyst) đặt câu hỏi khám phá |
| 👤 | Bạn trả lời: Vấn đề là gì? User là ai? Tính năng cốt lõi? Constraint? |
| 🤖 | Gọi `bmad-product-brief` để tổng hợp thành file |
| 👤 | **Đọc kỹ output và sửa những gì sai trước khi confirm** |

**Output:** `docs/product_brief.md`

> ⚠️ Nếu bỏ qua việc đọc và sửa ở đây, mọi bug về yêu cầu sẽ lan ra toàn bộ pipeline sau. Đây là nơi duy nhất bạn có thể sửa "rẻ" nhất.

---

### Bước 0.2 — PRD (Product Requirements Document)
💬 **Mở chat mới** | Lệnh: `bmad-agent-pm`

| Ai làm | Việc phải làm |
|---|---|
| 🤖 | Agent John (PM) đọc `product_brief.md` và bắt đầu hỏi |
| 👤 | Trả lời từng phần: Goals, User Stories, FR, NFR, Out-of-scope |
| 🤖 | Gọi `bmad-create-prd` để sinh file PRD chuẩn |
| 👤 | **Đọc kỹ từng dòng. Bất kỳ requirement mơ hồ nào ở đây = bug ở bước code** |
| 🤖 | Gọi `bmad-validate-prd` để kiểm tra chất lượng |
| 👤 | Nếu có phát hiện mới, gọi `bmad-edit-prd` để sửa |

**Output:** `_bmad-output/planning-artifacts/prds/prd-[tên]-[ngày]/prd.md`

---

### Bước 0.3 — Architecture
💬 **Mở chat mới** | Lệnh: `custom-agent-architect`

| Ai làm | Việc phải làm |
|---|---|
| 🤖 | Winston (Architect) đọc PRD và đặt câu hỏi về tech stack, deployment |
| 👤 | Quyết định: Frontend framework, Backend/BaaS, Database, Auth, Hosting |
| 🤖 | Sinh `ARCHITECTURE-SPINE.md` với ERD (Mermaid), ADR và Security Model |
| 👤 | **Review kỹ phần Constraints — đây là "Luật Pháp" của toàn dự án** |

**Output:** `_bmad-output/planning-artifacts/architecture/ARCHITECTURE-SPINE.md`

> 📝 `custom-agent-architect` KHÔNG tự đặt URL hay tên trang cụ thể — đó là việc của UI/UX ở Phase sau. Kiến trúc chỉ định nghĩa "Vật lý" (State management, Rendering strategy, Security rules).

---

### Bước 0.4 — Epics & Stories
💬 **Mở chat mới** | Lệnh: `bmad-create-epics-and-stories`

| Ai làm | Việc phải làm |
|---|---|
| 🤖 | Đọc PRD + Architecture, tự phân tách thành Epic và Story theo chuẩn BDD |
| 👤 | Review danh sách Story. Kiểm tra xem có Story nào bị thiếu hoặc thừa không |
| 👤 | **Nếu có tính năng bị Defer (hoãn): ghi rõ vào file để xử lý sau** |

**Output:** `_bmad-output/planning-artifacts/epics_logic.md`

> 📝 Khi muốn khôi phục tính năng bị Defer: Thêm Epic mới vào `epics_logic.md` thủ công hoặc nhờ Agent PM tạo Story. Sau đó chạy lại `/generate-backend-graph` — nó sẽ tự detect Epic mới.

✅ **CHECKPOINT 0:** Bạn phải có đủ 4 file trên trước khi đi tiếp. Thiếu bất kỳ file nào, Phase 1 sẽ thất bại vì AI không có context đủ để làm việc.

---

## PHASE 1 — Backend Design (Đồ thị Logic)
> **Mục tiêu:** Vẽ toàn bộ luồng dữ liệu Backend dưới dạng Cypher Graph.

---

### Bước 1.1 — Khởi tạo & Vẽ Backend Graph 🔁
💬 **Mở chat mới** | Lệnh: `/generate-backend-graph`

**Lần đầu tiên chạy (PHASE 1: INITIALIZATION):**

| Ai làm | Việc phải làm |
|---|---|
| 🤖 | Phát hiện `todo-backend-graph.md` chưa tồn tại → đọc `epics_logic.md` |
| 🤖 | Tự tạo checklist đầy đủ tất cả Epics vào `todo-backend-graph.md` |
| 🤖 | Vẽ Graph cho Epic đầu tiên, MERGE vào `backend-graph.cypher` |
| 👤 | **Đọc output Cypher. Kiểm tra: `roles` có gán đúng không? Tên Function có đúng nghiệp vụ không?** |

🔁 **Các lần tiếp theo (PHASE 2: CONTINUATION) — lặp đến khi hết Epic:**

| Ai làm | Việc phải làm |
|---|---|
| 🤖 | Đọc `todo-backend-graph.md`, tìm Epic `[ ]` đầu tiên → vẽ và MERGE tiếp |
| 👤 | Review output. **Chú ý kiểm tra `[:DEPENDS_ON]` edge — hay bị sót** |
| 👤 | Nếu thiếu Function/Step, ghi chú vào Cypher file để nhớ sửa |

**Điều kiện dừng:** `todo-backend-graph.md` hiển thị tất cả `[x]`

**Output:** `system-graphs/backend-graph.cypher`

✅ **CHECKPOINT 1:** Scan nhanh `backend-graph.cypher` — mỗi Epic phải có ít nhất 1 `(:Workflow)` node và tất cả `(:Function)` phải có thuộc tính `roles` (không được để trống).

---

## PHASE 2 — Frontend Design (Đồ thị UI)
> **Mục tiêu:** Vẽ toàn bộ luồng UI, đảm bảo khớp 100% với Backend Graph.

---

### Bước 2.1 — Vẽ Frontend Graph 🔁
💬 **Mở chat mới** | Lệnh: `/generate-graph target="[TÊN_MODULE]"`

🔁 **Lặp lại cho từng Module/Epic:**

| Ai làm | Việc phải làm |
|---|---|
| 🤖 | **Step 0 (Bắt buộc):** Đọc `backend-graph.cypher` trước khi vẽ bất kỳ node UI nào |
| 🤖 | Tạo `(:UINode)` với `requiredRole` và `visibleIf` |
| 🤖 | Tạo Edge `[:NAVIGATES_TO]`, `[:MUTATES_STATE]`, `[:TRANSITIONS_TO { if, animation }]` |
| 🤖 | MERGE vào `graph-master.cypher` |
| 👤 | **Review: `requiredRole` trên UI node có khớp với `roles` của Backend Function nó gọi không?** |

> ⚠️ Không được bỏ qua `target=`. Nếu không có target, AI sẽ cố vẽ toàn bộ dự án trong 1 lần → tràn context → hallucinate node.

**Output:** `system-graphs/graph-master.cypher`

---

## PHASE 3 — Validation Gate (Chốt Chặn)
> **Mục tiêu:** Đảm bảo 100% Frontend và Backend đồng bộ trước khi viết một dòng code nào.

---

### Bước 3.1 — Kiểm tra Chéo 2 Graph
💬 **Mở chat mới** | Lệnh: `/verify-graph-alignment`

| Ai làm | Việc phải làm |
|---|---|
| 🤖 | Quét cả 2 file `.cypher` và chạy 4 bài kiểm tra |
| 🤖 | Sinh Readiness Report: [A] Existence, [B] Role Parity, [C] Input Contract, [D] Orphan |
| 👤 | **Đọc Report. Mọi ô 🔴 là BLOCKER — phải sửa Graph rồi chạy lại trước khi đi tiếp** |
| 👤 | Với mỗi lỗi 🔴: mở file `.cypher`, sửa trực tiếp → chạy lại lệnh này |

**Điều kiện đi tiếp:** Report chỉ còn 🟢 và 🟡, không có 🔴.

✅ **CHECKPOINT 2 — Quan trọng nhất:** Đây là "Hợp đồng bất biến" giữa Frontend và Backend. Sau bước này, **mọi thay đổi yêu cầu (FR mới) phải cập nhật Graph trước, rồi chạy lại Verify, rồi mới chạm vào code.**

---

## PHASE 4 — Backend Code Generation
> **Mục tiêu:** Sinh code Service/Function thật từ Backend Graph.
> **Có thể làm song song với Phase 5.**

---

### Bước 4.1 — Sinh Backend Code 🔁
💬 **Mở chat mới** | Lệnh: `/build-backend-core`

🔁 **Lặp lại theo từng Function/Service:**

| Ai làm | Việc phải làm |
|---|---|
| 🤖 | Đọc `todo-backend-core.md` (tự tạo nếu chưa có), tìm Function chưa xong |
| 🤖 | Đọc node `(:Function)` trong `backend-graph.cypher` |
| 🤖 | Sinh code với đúng `input`, `output`, `roles`, `guard` |
| 👤 | **Review code: Logic có đúng nghiệp vụ không? Error handling có đủ không?** |

> 📝 Nếu Epic cũ đã có code hoạt động tốt: Mở `todo-backend-core.md`, đánh dấu `[x]` thủ công để bỏ qua. Chỉ cần sinh code cho những Function thực sự còn thiếu.

**Output:** `src/services/[ServiceName].ts`

---

## PHASE 5 — Frontend Code Generation
> **Mục tiêu:** Sinh UI đẹp từ Stitch, sau đó cắt thành Component có cấu trúc.
> **Có thể làm song song với Phase 4.**

---

### Bước 5.1 — Design Screen Specs (UX Specs) 🔁
💬 **Mở chat mới** | Lệnh: `/design-screen-specs target="[TÊN_MODULE]"`

🔁 **Lặp lại cho từng Module/Screen:**

| Ai làm | Việc phải làm |
|---|---|
| 🤖 | Đọc `graph-master.cypher`, phân tích từng `:UINode` và các Edge của nó |
| 🤖 | Xác định Visual Hierarchy: Primary Action, Secondary/Tertiary Actions |
| 🤖 | Định nghĩa In-Page States: Modal, Drawer, Loading skeleton, Empty state, Error state |
| 🤖 | Sinh file UX Spec chi tiết cho từng màn hình |
| 👤 | **Review: Hành động chính (Primary Button) có đúng không? Trạng thái lỗi/rỗng đã đủ chưa?** |

**Output:** `implementation-artifacts/ux-specs/specs-[module].md`

> 📝 Đây là bước **bắt buộc** trước khi sinh Stitch Prompts. Nếu bỏ qua, Stitch sẽ không biết nút nào là chính, nút nào là phụ, và không có Edge Case UI nào được xử lý.

---

### Bước 5.2 — Sinh Stitch Prompts 🔁
💬 **Mở chat mới** | Lệnh: `/generate-stitch-prompts`

🔁 **Lặp lại cho từng màn hình:**

| Ai làm | Việc phải làm |
|---|---|
| 🤖 | Đọc `graph-master.cypher` + **UX Specs từ Bước 5.1** |
| 🤖 | Sinh prompt tối ưu cho Stitch MCP (có đầy đủ hierarchy, states, edge cases) |
| 👤 | **Review prompt: Có đủ thông tin về màu sắc, typography, layout, animation không?** |

**Output:** `implementation-artifacts/stitch-prompts/[screen-name].md`

---

### Bước 5.3 — Sinh UI bằng Stitch MCP 🔁
💬 **Cùng chat hoặc mở chat mới** | Tool: **Stitch MCP**

🔁 **Lặp lại cho từng màn hình:**

| Ai làm | Việc phải làm |
|---|---|
| 👤 | Đưa prompt từ `stitch-prompts/*.md` vào Stitch |
| 🤖 | Stitch sinh ra HTML/CSS hoàn chỉnh |
| 👤 | **Mở preview trong browser. Nếu design chưa đạt: chỉnh prompt và gọi lại** |
| 👤 | Khi hài lòng: lưu HTML vào `implementation-artifacts/html-screens/[screen].html` |

> ⚠️ Đây là điểm **duy nhất** bạn nên dừng để đánh giá thẩm mỹ. Sau bước này, AI coi HTML là "source of truth" để cắt Component — không tự thêm màu sắc hay animation.

---
Chú ý khi dùng stitch MCP phải lấy về đúng project bạn đang làm để các skill sau đó có đúng nội dung để chạy, và hãy xem hướng dẫn kết nối stitch MCP vào agent của bạn tùy vào công cụ bạn dùng, và kiểm tra thử nội dung xem kết nối thành công chưa, hãy dùng trang web stitch để xem sau khi promt UI đã phù hợp ý bạn chưa để có cách xử lý phù hợp

### Bước 5.4 — Extract Components 🔁
💬 **Mở chat mới** | Lệnh: `/extract-modules`

🔁 **Lặp lại cho từng màn hình:**

| Ai làm | Việc phải làm |
|---|---|
| 🤖 | Đọc file HTML từ `html-screens/` |
| 🤖 | Phân tích DOM, xác định ranh giới Component |
| 🤖 | Sinh ra `*.tsx` (vỏ rỗng, chỉ có HTML/CSS, chưa có logic) |
| 👤 | **Review: Tên Component có khớp với `graph-master.cypher` không?** |

**Output:** `src/components/[FeatureName]/[ComponentName].tsx`

---

### Bước 5.5 — Assemble Pages 🔁
💬 **Mở chat mới** | Lệnh: `/assemble-pages`

🔁 **Lặp lại cho từng Page/Route:**

| Ai làm | Việc phải làm |
|---|---|
| 🤖 | Đọc `graph-master.cypher` để biết Page nào cần Component nào |
| 🤖 | Import và lắp ráp Component vào đúng Page file |
| 🤖 | Giữ nguyên toàn bộ text, layout và mock data từ HTML gốc |
| 👤 | **Chạy `npm run dev` và kiểm tra bằng mắt** |

**Output:** `src/app/[route]/page.tsx`

✅ **CHECKPOINT 3:** Toàn bộ trang phải render được trên browser với UI đầy đủ. Logic chưa hoạt động là bình thường ở bước này.

---

## PHASE 6 — Integration (Nối dây)
> **Mục tiêu:** Nối code Backend (Phase 4) vào UI Component (Phase 5).

---

### Bước 6.1 — Inject Logic 🔁
💬 **Mở chat mới** | Lệnh: `/inject-logic`

🔁 **Lặp lại theo từng Component/Feature:**

| Ai làm | Việc phải làm |
|---|---|
| 🤖 | Đọc `todo-logic.md` (tự tạo nếu chưa có) |
| 🤖 | Import đúng Service function từ Phase 4 vào Component |
| 🤖 | Bind sự kiện (onClick, onChange...) vào đúng hàm |
| 🤖 | Thêm State management và Error handling theo Architecture |
| 👤 | **Test tay từng luồng: Đăng nhập, thêm giỏ hàng, gửi comment...** |
| 👤 | **Nếu phát hiện bug logic: sửa trong Service file (Phase 4), KHÔNG sửa trong Component** |

> ⚠️ Skill `/inject-logic` chạy ở chế độ **Wire-Only**: Nó chỉ import và nối dây, KHÔNG tự viết thêm business logic mới. Mọi logic phải tồn tại trong Service file từ Phase 4.

---

### Bước 6.2 — Wire Routes (App Composition) ❌
💬 **Mở chat mới** | Lệnh: `/wire-routes`

**Chạy 1 lần duy nhất khi tất cả các trang đã được Assemble:**

| Ai làm | Việc phải làm |
|---|---|
| 🤖 | Đọc Graph và danh sách các trang đã được Assemble |
| 🤖 | Cấu hình Route trong file điều hướng trung tâm (App.tsx / main.tsx) |
| 🤖 | Gắn URL tương ứng và đảm bảo có Fallback (404) |
| 👤 | **Mở trình duyệt, truy cập thử các URL xem đã kết nối thành công chưa** |

---

## Bảng Tổng hợp Nhanh

| Phase | Lệnh | Lặp? | 👤 Can thiệp tại | Output |
|---|---|---|---|---|
| 0.1 Product Brief | `bmad-agent-analyst` | ❌ | Review output | `product_brief.md` |
| 0.2 PRD | `bmad-agent-pm` | ❌ | Review + sửa từng dòng | `prd.md` |
| 0.3 Architecture | `custom-agent-architect` | ❌ | Quyết định tech stack | `ARCHITECTURE-SPINE.md` |
| 0.4 Epics | `bmad-create-epics-and-stories` | ❌ | Review Story list | `epics_logic.md` |
| 1 Backend Graph | `/generate-backend-graph` | 🔁 × N epics | Review `roles` & nodes | `backend-graph.cypher` |
| 2 Frontend Graph | `/generate-graph target=...` | 🔁 × N modules | Review role parity | `graph-master.cypher` |
| 3 Validation | `/verify-graph-alignment` | 🔁 đến khi 🟢 | Sửa lỗi 🔴 trong Graph | Readiness Report |
| 4 Backend Code | `/build-backend-core` | 🔁 × N functions | Review logic + edge case | `src/services/*.ts` |
| 5.1 UX Specs | `/design-screen-specs` | 🔁 × N modules | Review hierarchy & states | `ux-specs/*.md` |
| 5.2 Stitch Prompts | `/generate-stitch-prompts` | 🔁 × N screens | Review prompt | `stitch-prompts/*.md` |
| 5.3 Stitch UI | Stitch MCP | 🔁 × N screens | **Duyệt design bằng mắt** | `html-screens/*.html` |
| 5.4 Extract | `/extract-modules` | 🔁 × N screens | Review tên Component | `components/*.tsx` |
| 5.5 Assemble | `/assemble-pages` | 🔁 × N pages | Kiểm tra render browser | `app/**/page.tsx` |
| 6.1 Inject Logic | `/inject-logic` | 🔁 × N features | **Test tay từng luồng** | Component đã có logic |
| 6.2 Wire Routes | `/wire-routes` | ❌ | Chạy test chuyển trang | `App.tsx` hoặc Router file |

---

## Nguyên tắc Vàng

1. **Không bao giờ bỏ qua Checkpoint.** Mỗi Checkpoint là "Cửa an toàn" — đi qua mà chưa pass là đang nợ kỹ thuật.
2. **Mở chat mới cho mỗi Phase lớn.** Không để Context của Phase 0 lẫn vào Phase 4.
3. **Sửa ở nguồn gốc.** Bug logic → sửa Service (Phase 4). Bug UI → sửa Component (Phase 5). Không vá chéo.
4. **Đồ thị (Graph) là Luật Pháp.** Mọi thay đổi yêu cầu (FR mới) phải cập nhật Graph trước, rồi mới chạy lại Verify và Code.
5. **Khôi phục Deferred Feature:** Thêm Epic mới vào `epics_logic.md` → chạy lại `/generate-backend-graph` → Verify → Code. Không cần làm lại từ đầu.
