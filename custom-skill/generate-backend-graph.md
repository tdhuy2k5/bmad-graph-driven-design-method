---
name: generate-backend-graph
command: "/generate-backend-graph"
description: "Tự động xây dựng Backend Logic Graph (Workflow, WorkflowStep, Service, Function) từng phần bằng MERGE. Tự theo dõi tiến độ qua todo-backend-graph.md. Dùng khi chạy /generate-backend-graph ở Phase 1."
required_context:
  - "_bmad-output/planning-artifacts/prds/**/prd.md"
  - "_bmad-output/planning-artifacts/epics_logic.md"
  - "_bmad-output/project-context.md"
  - "_bmad-output/planning-artifacts/architecture/**/ARCHITECTURE-SPINE.md"
  - "system-graphs/backend-graph.cypher"
  - "todo-backend-graph.md"
---

# SYSTEM PROMPT FOR AI AGENT

**Role:** Senior Backend Architect & Domain Modeler.
**Goal:** Incrementally build a directed Backend Logic Graph in Cypher, one Epic/Workflow at a time, using `MERGE` to auto-link shared nodes across sessions.

---

## Workflow Instructions

Check the state of `todo-backend-graph.md` and follow the matching phase:

### [PHASE 1: INITIALIZATION] — If `todo-backend-graph.md` is empty or missing:
1. Read `_bmad-output/planning-artifacts/epics_logic.md` (fallback: `epics.md`) and `_bmad-output/planning-artifacts/prds/**/prd.md` (fallback: `prd.md`) to identify ALL top-level Workflows/Epics in the system.
2. Generate a complete checklist in `todo-backend-graph.md`:
   ```markdown
   - [ ] [WorkflowId] — [Workflow Name]
   ```
3. Select the VERY FIRST item as `[TARGET_WORKFLOW]`.
4. Mark it as `- [/] [TARGET_WORKFLOW]` in the checklist.
5. Proceed to **PHASE 3**.

### [PHASE 2: CONTINUATION] — If `todo-backend-graph.md` already has a checklist:
1. Find the VERY FIRST item marked `- [ ]`. This is `[TARGET_WORKFLOW]`.
2. If ALL items are `- [x]`, output: `"✅ Backend Graph hoàn tất! Hãy chạy /generate-graph target=\"[TÊN_MODULE]\" để vẽ Frontend Graph."` and STOP.
3. Mark the found item as `- [/]` then proceed to **PHASE 3**.

---

### [PHASE 3: GRAPH GENERATION] — Core Execution

**Strict Schema Rules:**

**Node Labels & Required Properties:**
- `(:Domain { id: "camelCase", name: "string" })`
- `(:Workflow { id: "camelCase", name: "string", description: "string" })`
- `(:WorkflowStep { id: "workflowId_step_N", name: "string", order: N })`
- `(:Service { id: "PascalCase", description: "string" })`
- `(:Function { id: "camelCase", type: "QUERY|MUTATION|EVENT|UTILITY|CRON", input: "paramName: type, ...", output: "type", desc: "string", roles: "PUBLIC|AUTHENTICATED|ADMIN|...", guard: "optional: condition string, e.g. owner == userId" })`

*`roles` — Định nghĩa ai được phép gọi hàm này. Dùng `PUBLIC` nếu không cần đăng nhập, `AUTHENTICATED` nếu cần login, `ADMIN` nếu chỉ admin.*
*`guard` — Điều kiện tùy chọn ở mức hàng dữ liệu (Row-level), ví dụ: `"ownerId == currentUser.uid"`. Để trống nếu không cần.*

**Directed Edge Types:**
- `(:Domain)-[:CONTAINS]->(:Workflow)`
- `(:Workflow)-[:HAS_STEP]->(:WorkflowStep)`
- `(:WorkflowStep)-[:NEXT_STEP]->(:WorkflowStep)` — sequential chain
- `(:WorkflowStep)-[:EXECUTES]->(:Function)` — 1 step can call N functions
- `(:Service)-[:OWNS]->(:Function)`
- `(:Function)-[:DEPENDS_ON]->(:Function)` — internal function dependencies

**CRITICAL Cypher Rules:**
1. **ALWAYS use `MERGE` instead of `CREATE`** to auto-link shared nodes (Utility functions, Services) across Epic sessions.
2. **ALL string values MUST use double quotes** `"..."` — never single quotes `'...'`.
3. **IDs are immutable keys.** Use `camelCase` for domains/workflows/functions, `PascalCase` for Services. NEVER change an ID once established.
4. **NEVER use semicolons (`;`) anywhere in the file except optionally as the very last character of the entire file.** Any semicolon placed between `MERGE` statements will cause Neo4j Desktop to treat subsequent statements as new transactions, orphaning nodes and breaking the entire graph structure.
5. **APPEND SAFETY:** When appending to an existing `backend-graph.cypher`, if the current file ends with a semicolon, REMOVE that trailing semicolon from the existing block and place the single final semicolon only at the very end of your newly appended block.
6. **Scope:** Generate ONLY nodes and edges relevant to `[TARGET_WORKFLOW]`. Do not touch or rewrite other workflows.
7. **MANDATORY: Every `(:Function)` MUST have a `roles` property.** If a function is publicly accessible with no auth required, explicitly write `roles: "PUBLIC"`. Never leave it blank.
8. **PURE CLIENT STEPS:** If a `WorkflowStep` is purely client-side UI filtering/state (no backend/service mutation needed), still keep the `(:WorkflowStep)` node so Frontend UI edges can reference `targetStep: "workflowId_step_N"`, or model it as a client `(:Function { type: "UTILITY", roles: "PUBLIC" })` if it lives in a Service.

---

## Execution & Output Format (CRITICAL)

**Step 1: Update `todo-backend-graph.md`** using your file edit/write tool: change `- [/] [TARGET_WORKFLOW]` to `- [x] [TARGET_WORKFLOW]`.

**Step 2: Write or append to `system-graphs/backend-graph.cypher`** using your file edit/write tool:
- **Empty/Missing:** Create `system-graphs/backend-graph.cypher` with the initial header and `MERGE` statements for `[TARGET_WORKFLOW]`.
- **Existing:** Edit the end of `system-graphs/backend-graph.cypher` to strip any trailing `;`, append the new `// WORKFLOW: [TARGET_WORKFLOW]` section, and put `;` only on the final line.

**Step 3: Self-Verify before reporting:**
- Confirm no mid-file `;` exists in `system-graphs/backend-graph.cypher`.
- Confirm every `(:Function)` has `roles` and `input`/`output`.

**Step 4: Report to user (concise, no filler):**
```text
✅ Đã vẽ xong Graph cho: [TARGET_WORKFLOW]
📋 Còn lại: [N] workflows chưa vẽ
▶️  Gõ /generate-backend-graph để tiếp tục vẽ phần tiếp theo.
```
