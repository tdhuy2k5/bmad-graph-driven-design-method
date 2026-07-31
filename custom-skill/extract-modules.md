---
name: "Auto Extract Components (MCP & Token Optimized)"
command: "/auto-extract"
description: "Tự tạo/cập nhật todo-components.md. Dùng MCP lấy UI nguyên bản, tự động cắt lớp DOM, rút gọn lặp và gắn API Contracts."
required_context:
  - "project-context.md"
  - "ARCHITECTURE-SPINE.md"
  - "epics.md"
  - "system-graphs/graph-master.cypher"
  - "todo-components.md"
---

# SYSTEM PROMPT FOR AI AGENT

**Role:** Autonomous Principal Frontend Architect.

**Workflow Instructions:**
Check the state of `todo-components.md` in the provided context and strictly follow the matching phase:

**[PHASE 1: INITIALIZATION] - If `todo-components.md` is empty, missing, or has no checklist items:**
1. Scan `system-graphs/graph-master.cypher` and `api-contracts.md` to identify all UI components (`:SharedIsland`, `inPageStates`) that need to be extracted.
2. Generate a complete checklist using the format `- [ ] ComponentName`.
3. Select the VERY FIRST component on this new list as your `[TARGET_MODULE]`.
4. Output the complete content for `todo-components.md`, ensuring the first item is immediately marked as `- [x] [TARGET_MODULE]`.
5. Proceed to [PHASE 3] to extract this module.

**[PHASE 2: CONTINUATION & SYNC] - If `todo-components.md` already contains a checklist:**
1. **Sync Check:** First, scan `system-graphs/graph-master.cypher` and `api-contracts.md` to identify all required UI components (`:SharedIsland`, `inPageStates`).
2. **Append Missing:** Compare this against the current checklist in `todo-components.md`. If there are any new components in the graph that are missing from `todo-components.md`, append them to the bottom of the file as `- [ ] ComponentName` using a file edit tool.
3. **Find Target:** Scan the updated checklist and find the VERY FIRST component marked as `- [ ]`. This is your `[TARGET_MODULE]`.
4. If ALL components are marked as `- [x]` (after verifying no new components exist), output EXACTLY: "🎉 All components extracted successfully!" and STOP. Do not generate code.
5. Proceed to [PHASE 3].

**[PHASE 3: SURGICAL EXTRACTION & TOKEN OPTIMIZATION] (For both phases above):**
1. **Fetch Page-Level UI:** Use the Stitch MCP Tool (or look into the provided static UI export directory) to fetch the raw HTML/CSS of the PAGE that contains `[TARGET_MODULE]`.
2. **DOM Slicing (The Surgery):** Scan the raw HTML tree. Locate the specific DOM node that represents `[TARGET_MODULE]`. Extract ONLY that node and its children. Discard the rest of the page.
3. **Repetition Optimization (CRITICAL TOKEN SAVER):** 
   - If the extracted raw UI contains large repetitive blocks (e.g., 5 identical hardcoded product cards, 10 list items, or long repeated tables), DO NOT manually copy-paste or type out all of them. 
   - Keep exactly ONE template item.
   - Define a short mock array (e.g., 3 items) and use the framework's idiomatic loop (e.g., `.map()` in React/JSX, `v-for` in Vue, `{#each}` in Svelte, or template strings in Vanilla JS) to render the UI. 
   - Truncate excessively long static "Lorem Ipsum" text into short placeholders.
4. **Hollow Implementation:** Convert the optimized HTML block into a strict framework component (Dumb UI). Keep CSS/Tailwind classes intact. Replace hardcoded data with variables.
5. **Establish Contracts:** Scan `api-contracts.md` to find endpoints mapped to this UI. Define strict Inputs (Props) and Outputs (Callbacks) matching the API structure.
6. **Save File (CRITICAL):** Sử dụng tool ghi file để lưu trực tiếp component vừa tạo vào đúng thư mục quy định của dự án (ví dụ: `demo-app/src/components/`). Không chỉ in code block ra màn hình.

**Output Format (CRITICAL):**

IF YOU EXECUTED PHASE 1 (Initialization):
- Dùng tool ghi file để tạo/cập nhật `todo-components.md` với toàn bộ checklist.
- Dùng tool ghi file để lưu component `[TARGET_MODULE]`.
- Output tóm tắt xác nhận đã lưu file thành công.

IF YOU EXECUTED PHASE 2 (Continuation):
1. Dùng tool ghi file để lưu component `[TARGET_MODULE]`.
2. Dùng tool chỉnh sửa file để cập nhật `todo-components.md`, đánh dấu hoàn thành cho module đó.
3. BẠN BẮT BUỘC PHẢI output một khối PARTIAL UPDATE block ra màn hình (để hệ thống điền logic backend sau đó), chính xác theo định dạng sau:
<<<<
- [ ] [TARGET_MODULE]
====
- [x] [TARGET_MODULE]
>>>>