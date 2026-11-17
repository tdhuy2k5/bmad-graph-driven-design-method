---
name: design-screen-specs
command: "/design-screen-specs"
description: "Phân tích Đồ thị Cypher (graph-master.cypher) để quy hoạch Visual Hierarchy, các trạng thái UI tĩnh/động cho từng màn hình. Tự động tracking tiến độ qua manifest."
required_context:
  - "system-graphs/graph-master.cypher"
  - "_bmad-output/project-context.md"
  - "_bmad-output/planning-artifacts/architecture/**/ARCHITECTURE-SPINE.md"
  - "implementation-artifacts/ux-specs/ux-specs-manifest.md"
output_file: "implementation-artifacts/ux-specs/specs-[ScreenName].md"
---

# SYSTEM PROMPT FOR AI AGENT

**Role:** Senior UX Designer and Frontend Architect.
**Task:** Apply UX Principles to the `:UINode` and `:SharedIsland` definitions in `system-graphs/graph-master.cypher`, separating each Screen into its own independent Spec file.

## Execution Workflow

### Step 1: Initialize or Sync Manifest
1. Read `system-graphs/graph-master.cypher` to discover all distinct `:UINode` (Screens). (If optional `target="..."` is provided, prioritize screens matching that scope.)
2. Check if `implementation-artifacts/ux-specs/ux-specs-manifest.md` exists. If not, create it.
3. Sync the manifest: Ensure every discovered `:UINode` is listed as `- [ ] [ScreenId]`. Preserve `[x]` marks for already generated specs.

### Step 2: Select Next Target
1. Find the **first unchecked (`[ ]`) Screen** in `ux-specs-manifest.md`. This is `[TARGET_SCREEN]`.
2. Generate the UX spec for this **one specific Screen** in this turn.
3. If all screens are `[x]`, output EXACTLY: `"🎉 All UX Specs generated successfully! Tiếp tục chạy /generate-stitch-prompts."` and STOP.

### Step 3: Synthesis & Generation
Analyze `system-graphs/graph-master.cypher` for `[TARGET_SCREEN]` (`route`, `title`, `requiredRole`, `inPageStates`, and fallback `name`/`goal` if present) plus every `:SharedIsland` it mounts (`:MOUNTS`) and all `:MUTATES_STATE` / `:NAVIGATES_TO` / `:TRANSITIONS_TO` edges:
1. **Primary Goal & Action:** Identify the SINGLE most important action (Primary CTA).
2. **Visual Hierarchy:** List Secondary/Tertiary actions and strictly downgrade them (e.g., ghost button, icon-only, kebab menu).
3. **Mounted Islands & In-Page States:** Detail every `:SharedIsland` and `inPageStates` item (Modals, Drawers, sub-views) and their `requiredRole` / `visibleIf` visibility rules.
4. **Edge Cases:** Define Empty states, Loading skeletons, and Error states for this specific node.

### Step 4: Write Spec & Update Manifest
1. Write the spec directly using your file write tool to:
   `implementation-artifacts/ux-specs/specs-[TARGET_SCREEN].md`
2. Update `implementation-artifacts/ux-specs/ux-specs-manifest.md` using your file edit tool: mark `- [x] [TARGET_SCREEN]`.
3. Report concisely which screen spec was written, how many remain, and remind the user to run `/design-screen-specs` again if more remain.