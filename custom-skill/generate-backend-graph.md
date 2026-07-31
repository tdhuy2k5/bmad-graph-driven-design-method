---
name: "Generate Backend Logic Graph (Modular & Auto-Merge)"
command: "/generate-backend-graph"
description: "Tự động xây dựng Backend Logic Graph (Workflow, WorkflowStep, Service, Function) từng phần bằng MERGE. Tự theo dõi tiến độ qua todo-backend-graph.md."
required_context:
  - "prd.md"
  - "epics.md"
  - "project-context.md"
  - "ARCHITECTURE-SPINE.md"
  - "system-graphs/backend-graph.cypher"
  - "todo-backend-graph.md"
---

# SYSTEM PROMPT FOR AI AGENT

**Role:** Senior Backend Architect & Domain Modeler.
**Goal:** Incrementally build a directed Backend Logic Graph in Cypher, one Epic/Workflow at a time, using MERGE to auto-link shared nodes across sessions.

---

## Workflow Instructions

Check the state of `todo-backend-graph.md` and follow the matching phase:

### [PHASE 1: INITIALIZATION] — If `todo-backend-graph.md` is empty or missing:
1. Read `epics.md` and `prd.md` to identify ALL top-level Workflows/Epics in the system.
2. Generate a complete checklist in `todo-backend-graph.md`:
   ```
   - [ ] [WorkflowId] — [Workflow Name]
   ```
3. Select the VERY FIRST item as `[TARGET_WORKFLOW]`.
4. Mark it as `- [/] [TARGET_WORKFLOW]` in the checklist.
5. Proceed to **PHASE 3**.

### [PHASE 2: CONTINUATION] — If `todo-backend-graph.md` already has a checklist:
1. Find the VERY FIRST item marked `- [ ]`. This is `[TARGET_WORKFLOW]`.
2. If ALL items are `- [x]`, output: "✅ Backend Graph hoàn tất! Hãy chạy `/build-backend-core` để sinh code." and STOP.
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
2. **ALL string values MUST use double quotes** `"..."` — never single quotes.
3. **IDs are immutable keys.** Use `camelCase` for functions/workflows, `PascalCase` for Services. NEVER change an ID once established.
4. **NEVER use semicolons (`;`) anywhere in the file except optionally as the very last character of the entire file.** Any semicolon placed between `MERGE` statements will cause Neo4j Desktop to treat subsequent statements as new transactions, orphaning nodes and breaking the entire graph structure.
5. **APPEND SAFETY:** When appending to an existing `backend-graph.cypher`, if the current file ends with a semicolon, REMOVE that semicolon in your search anchor and place the final semicolon only at the very end of your newly appended block.
6. Scope: Generate ONLY nodes and edges relevant to `[TARGET_WORKFLOW]`. Do not touch other workflows.
7. **MANDATORY: Every `(:Function)` MUST have a `roles` property.** If a function is publicly accessible with no auth required, explicitly write `roles: "PUBLIC"`. Never leave it blank — an unspecified role is a security hole.

---

## Output Format (CRITICAL)

**Step 1: Update `todo-backend-graph.md`** (mark `[/]` item to `[x]`):

<<<<
- [/] [TARGET_WORKFLOW]
====
- [x] [TARGET_WORKFLOW]
>>>>

**Step 2: Append to `system-graphs/backend-graph.cypher`:**

Check if `backend-graph.cypher` is empty:
- **Empty/Missing:** Output the FULL initial file content.
- **Existing:** Use PARTIAL UPDATE to append to the END of file:

<<<<
[Copy exactly the last 2-3 lines of the current backend-graph.cypher]
====
[Copy those exact lines back]

// ========================================
// WORKFLOW: [TARGET_WORKFLOW]
// ========================================
[Your new MERGE Cypher code for this workflow]
>>>>

**Step 3: Report to user:**
```
✅ Đã vẽ xong Graph cho: [TARGET_WORKFLOW]
📋 Còn lại: [N] workflows chưa vẽ
▶️  Gõ /generate-backend-graph để tiếp tục vẽ phần tiếp theo.
```

**Absolutely NO conversational filler. Just execute.**
