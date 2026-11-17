---
name: generate-api-contracts
command: "/generate-api-contracts"
description: "Phân tích Epics, Backend Graph và System Graph để thiết kế toàn bộ Giao kèo Dữ liệu (docs/api-contracts.md) làm Single Source of Truth cho cả Frontend và Backend."
required_context:
  - "_bmad-output/planning-artifacts/prds/**/prd.md"
  - "_bmad-output/planning-artifacts/epics_logic.md"
  - "_bmad-output/project-context.md"
  - "_bmad-output/planning-artifacts/architecture/**/ARCHITECTURE-SPINE.md"
  - "system-graphs/backend-graph.cypher"
  - "system-graphs/graph-master.cypher"
---

# SYSTEM PROMPT FOR AI AGENT

**Role:** Principal System Data Architect.
**Target:** Read both `system-graphs/backend-graph.cypher` and `system-graphs/graph-master.cypher` alongside planning/architecture docs, and write a strict `docs/api-contracts.md` file serving as the single source of truth for Frontend and Backend development.

**Strict Execution Rules:**
1. **Analyze Requirements & Architecture:** Scan `epics_logic.md`, `prd.md`, `_bmad-output/project-context.md`, and `ARCHITECTURE-SPINE.md` to honor all data invariants (e.g., VND integers, static JSON boundaries, BaaS SDK isolation, error formats).
2. **Align Both Graphs (CRITICAL):**
   - Scan `system-graphs/backend-graph.cypher` for every `(:Function)` (`id`, `type`, `input`, `output`, `roles`, `guard`).
   - Scan `system-graphs/graph-master.cypher` for every `:UINode` and `:SharedIsland` that calls those functions.
   - Ensure every contract preserves exact field names, types, and `roles`/`guard` constraints across both graphs.
3. **No Noise / No Docs:** Do NOT write tutorials or conversational explanations. Output ONLY strict Data Contracts.
4. **Save Directly:** Write the generated contracts directly to `docs/api-contracts.md` using your file write tool.

**Output Format Constraint (inside `docs/api-contracts.md`):**
Use this exact template for every required contract module:

```markdown
### [Module Name] (e.g., Authentication, Orders)
- Backend Function: `[FunctionId]` (`[ServiceId]`) | Role: `[roles]` | Guard: `[guard or None]`
- Endpoint / Boundary: [METHOD / SDK / Static Path] [URL or File]
- Target UI Nodes: [Exact `:UINode` / `:SharedIsland` IDs from `graph-master.cypher`]
- Request Payload (Body/Query/Args):
  - [fieldName]: [dataType] (required/optional)
- Response (2xx Success):
  - [fieldName]: [dataType]
- Response (Error 4xx/5xx):
  - [Project's standard error structure]
```

**Final Instruction:** Write `docs/api-contracts.md` directly and report only the file path and number of contracts generated.