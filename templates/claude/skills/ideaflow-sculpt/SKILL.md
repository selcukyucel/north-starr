---
name: ideaflow-sculpt
description: Execute implementation using micro-cycles (PREDICT, CHANGE, OBSERVE, RESULT) with the 20-Minute Rule, mistake-proofing, reuse-first principle, and code sandwich awareness. Use during active coding for any complexity level. Trigger phrases: "start coding", "begin implementation", "execute the plan", "start sculpting".
---

# SCULPT -- Idea Flow Agentic Workflow v2.0

Execute implementation with disciplined micro-cycle methodology. Language-agnostic.

---

## Step 1: Load Context

- Review implementation plan (if Medium/Complex)
- Check relevant `.ai/patterns/` for guidance
- Review `.ai/landmines/` for warnings
- Note relevant `.ai/checklists/`

---

## Step 2: Execute Micro-Cycles

For each change:

### PREDICT

State what you expect will happen:

- "I expect the build to succeed"
- "I expect this test to pass"
- "I expect this function to return X"

### CHANGE

Make the smallest possible change:

- 1-5 lines for properties/fields
- 5-15 lines for method bodies
- 10-30 lines for tests
- NEVER > 50 lines without validation

### OBSERVE

Validate immediately:

- Build/compile
- Run relevant tests
- Check IDE diagnostics
- Manual verification if UI

### RESULT

- **CONFIRM:** prediction matched -> continue to next micro-cycle
- **CONFLICT:** prediction did not match -> apply 20-Minute Rule protocol

---

## Step 3: The 20-Minute Rule (Active Brake)

If stuck > 20 minutes on any problem:

1. **STOP** coding immediately
2. **DOCUMENT** what was tried:
   - What you were trying to do
   - What happened instead
   - What you have attempted
   - For Complex tasks: write to `.ai/tasks/YYYY-MM-DD-name/LEARNINGS.md`
3. **CHECK** `.ai/landmines/` for similar issues
4. **DECOMPOSE** into smaller micro-cycles
5. **ASK** for help if still stuck

---

## Step 4: Mistake-Proofing (Active During All Coding)

- **Scanning:** explicitly note critical details that could be missed on quick scan
- **Copy-edit:** when duplicating patterns, diff to verify all changes made
- **Transposition:** after writing conditionals, re-read to verify branches are not swapped
- **Stale memory:** re-read actual code before relying on assumptions
- **Semantic:** verify terms mean what you think in this codebase's vocabulary

---

## Step 5: Code Sandwich Awareness

For every piece of code written, evaluate:

- **Observability:** Can someone see what is happening when things go wrong? Meaningful error messages. No silent failures.
- **Behavior Complexity:** Is cause-effect traceable? Prefer explicit over magical.
- **Ease of Manipulation:** Can this be tested in isolation?

---

## Step 6: Safety-First Decision Gate

At every decision point: "Am I gambling?"

High-risk signals:

- Many changes before running tests
- Skipping validation to "save time"
- Modifying unfamiliar code without reading it
- Clever abstractions that sacrifice observability

If high-risk: stop, flag it, find a safer path.

---

## Step 7: Track Progress

- Count CONFIRM vs CONFLICT ratio (target: 70-90% CONFIRM)
- Note significant conflicts for LEARN phase
- For Complex tasks: update `LEARNINGS.md` with conflicts
