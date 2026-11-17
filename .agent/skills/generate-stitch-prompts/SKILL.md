---
name: generate-stitch-prompts
command: "/generate-stitch-prompts"
description: "Tổng hợp UX Specs & Neo4j Graph để tạo prompt riêng biệt cho từng màn hình (Screen). Chỉ xử lý các màn hình đã có UX Spec."
required_context:
  - "implementation-artifacts/ux-specs/ux-specs-manifest.md"
  - "implementation-artifacts/ux-specs/specs-*.md"
  - "system-graphs/graph-master.cypher"
  - "_bmad-output/planning-artifacts/architecture/**/ARCHITECTURE-SPINE.md"
  - "implementation-artifacts/stitch-prompts/stitch-prompts-manifest.md"
output_file: "implementation-artifacts/stitch-prompts/screens/[ScreenName].md"
---

# SYSTEM PROMPT FOR AI AGENT

**Role:** UI Prompt Engineer and System Architect.
**Task:** Translate completed UX Screen Specs into highly precise, actionable prompts for Google Stitch (Stitch MCP).

**CRITICAL METHODOLOGY (PIPELINE DEPENDENCY):**
You MUST ONLY generate prompts for Screens marked `[x]` in `implementation-artifacts/ux-specs/ux-specs-manifest.md`.

## Execution Workflow

### Step 1: Initialize or Sync Manifest
1. Read `implementation-artifacts/ux-specs/ux-specs-manifest.md` to discover all Screens marked COMPLETED (`- [x] [ScreenName]`). Skip screens still `[ ]`.
2. Check if `implementation-artifacts/stitch-prompts/stitch-prompts-manifest.md` exists. If not, create it.
3. Sync the manifest: Ensure every completed screen from `ux-specs-manifest.md` is listed in `implementation-artifacts/stitch-prompts/stitch-prompts-manifest.md` as `- [ ] [ScreenName]`. Preserve `[x]` marks for already generated prompts.

### Step 2: Select Next Target
1. Find the **first unchecked (`[ ]`) Screen** in `stitch-prompts-manifest.md`. This is `[TARGET_SCREEN]`.
2. Generate the Stitch prompt for this **one specific Screen** in this turn.
3. If all screens are `[x]`, output EXACTLY: `"🎉 All available Stitch Prompts generated successfully!"` and STOP.

### Step 3: Synthesis & Prompt Generation
1. Read `implementation-artifacts/ux-specs/specs-[TARGET_SCREEN].md`.
2. Read `system-graphs/graph-master.cypher` to cross-reference `:SharedIsland` mounts, `inPageStates`, `requiredRole`/`visibleIf`, and action triggers.
3. Synthesize ONE comprehensive prompt instructing Stitch to build all Islands first, then assemble the Screen layout.

### Step 4: Write Prompt & Update Manifest
1. Write the prompt directly using your file write tool to:
   `implementation-artifacts/stitch-prompts/screens/[TARGET_SCREEN].md`
2. Update `implementation-artifacts/stitch-prompts/stitch-prompts-manifest.md` using your file edit tool: mark `- [x] [TARGET_SCREEN]`.
3. Report concisely which prompt was generated, how many remain, and remind the user to run `/generate-stitch-prompts` again if more remain.

---

## Prompt Generation Constraints (For Google Stitch)

1. **In-Context Atomic Generation (CRITICAL):**
   - Instruct Stitch NOT to build the entire page in one single HTML block immediately (prevents dropping form inputs and nested details).
   - Instruct Stitch to use a **Sequential Chain of Generation**: output separate HTML blocks for each complex Island *first* (e.g., Block 1: `CartDrawerIsland` HTML, Block 2: `AuthModalIsland` HTML), then output the final Screen HTML block assembling them.
2. **State Toggling (Vanilla JS):**
   - Instruct Stitch to use plain Vanilla JavaScript (`document.getElementById` and `classList.toggle('hidden')`) to manage modal/drawer visibility.
   - Modals/drawers MUST default to hidden via CSS (`hidden` class).
   - **CRITICAL:** Explicitly forbid React `useState` in the Stitch HTML prototype.
3. **No Business Logic:**
   - Explicitly forbid Stitch from writing API calls, Firebase queries, or complex data manipulation.
   - Leave standard HTML `onclick=""` handlers empty or `console.log(...)` placeholders.
   - **CRITICAL:** Explicitly forbid React syntax (`className`, `onClick={}`).
4. **Mock Data & Edge Cases:**
   - Instruct Stitch to use realistic domain mock data in the project's UI language (`_bmad-output/project-context.md`) to demonstrate Empty, Error, and Loading states.