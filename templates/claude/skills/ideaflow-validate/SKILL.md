---
name: ideaflow-validate
description: Validate implementation quality through explicit predictions, conflict resolution protocol, and test failure triage. Run after coding is complete to ensure work meets quality standards. Trigger phrases: "validate this", "check quality", "run validation", "wrap up implementation".
---

# Idea Flow Validate Skill

**Purpose:** Validate that implementation is correct, complete, and maintainable. This is the VALIDATE phase of the Idea Flow Agentic Workflow v2.0. Language-agnostic.

---

## Step 1: Run Final Validation

- Build/compile the project with no errors.
- Run the full relevant test suite.
- Check IDE diagnostics for warnings.
- Verify no debug or temporary code remains in the changeset.
- Verify no commented-out code is left behind.

## Step 2: Verify Success Criteria

- Check all criteria from the SENSE phase Friction Forecast.
- Verify edge cases identified in inversion thinking are handled.
- Confirm patterns from `.ai/patterns/` were followed.
- Confirm landmines from `.ai/landmines/` were avoided.

## Step 3: Test Failure Triage

If any tests fail, classify each failure:

- **Bug Signal:** Test caught a real mistake. Fix the code.
- **False Alarm:** Test is over-coupled to implementation details. Fix the test and tag as `ALARM_PAIN`.
- **Noise:** Flaky or unreliable test. Flag for improvement.

NEVER green-wash. Do not blindly update tests to pass without understanding why they failed.

## Step 4: Conflict Resolution Protocol

If unexpected behavior occurs:

1. **STOP** -- Do not write more code on top of a conflict.
2. **OBSERVE** -- Describe what happened as a specific observation, not a hypothesis.
3. **NARROW** -- Check the most recent change first. Use binary search for larger change sets.
4. **DIAGNOSE** -- Identify the root cause before fixing. Understand WHY.
5. **FIX** -- Apply a minimal fix addressing the root cause.
6. **VERIFY** -- Confirm the fix works AND no new conflicts were introduced.
7. **RECORD** -- If resolution took more than 20 minutes, record it with a pain type classification.

## Step 5: Quality Checklist

- [ ] All tests pass
- [ ] No compiler/build warnings
- [ ] No security vulnerabilities introduced
- [ ] Error handling is appropriate (meaningful messages, no silent failures)
- [ ] Existing components/utilities reused where possible
- [ ] Code follows project conventions
- [ ] Changes are minimal and focused (no scope creep)

## Step 6: Generate Validation Summary

Output the following:

- Pass/fail status for each check.
- Any conflicts encountered and their resolution.
- Any test failures and their classification.
- Recommendation: ready to proceed to LEARN, or needs more work.

Keep concise. No emojis.
