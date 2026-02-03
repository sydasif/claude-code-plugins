# Full-Review Sync Plan

## Primary Objective

Make `full-review` command consistent with the existing `/review` command architecture.

## Issues to Fix

### 1. Agent Name Mismatch (Critical)

- **Current**: `full-review.md` references `automatic-code-reviewer`
- **Actual agent**: `agents/code-reviewer.md` (exists)
- **Fix**: Change reference to `code-reviewer` ✓

### 2. TypeScript Hardcoding (Critical)

- **Current**: Hardcoded glob `**/*.{ts,tsx}` ignores Python/JS projects
- **Fix**: Read `fileExtensions` from `.claude/settings.json` dynamically ✓

### 3. Rules File Path Inconsistency (High)

- **Current**: 3 different paths mentioned across files
- **Fix**: Use `${CLAUDE_PLUGIN_ROOT}/rules.md` consistently ✓

### 4. Missing Argument Implementation (Medium)

- **Current**: Placeholder logic for `--report`, `--issue`, `--scope`
- **Fix**: Add actual bash implementation and report generation ✓

### 5. Missing Settings Reading (Medium)

- **Current**: No reading of `.claude/settings.json`
- **Fix**: Add logic to read config like main `/review` command does ✓

## Changes Applied

| File | Lines | Action | Status |
|------|-------|--------|--------|
| `plugins/code-review/commands/full-review.md` | 3, 9 | Fixed description and rules path | ✓ Complete |
| `plugins/code-review/commands/full-review.md` | 21-70 | Implemented bash argument parsing | ✓ Complete |
| `plugins/code-review/commands/full-review.md` | 71-82 | Added Step 2: Read settings.json | ✓ Complete |
| `plugins/code-review/commands/full-review.md` | 83-110 | Replaced TS glob with dynamic extensions | ✓ Complete |
| `plugins/code-review/commands/full-review.md` | 113, 134, 153 | Fixed agent name to `code-reviewer` | ✓ Complete |
| `plugins/code-review/commands/full-review.md` | 141, 196 | Fixed rules path variable | ✓ Complete |
| `plugins/code-review/commands/full-review.md` | 178, 267 | Fixed variable names (GENERATE_REPORT, CREATE_ISSUE) | ✓ Complete |
| `plugins/code-review/commands/full-review.md` | 112-274 | Updated step numbering (1-9) | ✓ Complete |
| `plugins/code-review/commands/full-review.md` | 303-318 | Updated error handling and notes | ✓ Complete |

## Implementation Complete ✓

All changes have been applied to `plugins/code-review/commands/full-review.md`:

1. ✓ Fixed agent name from `automatic-code-reviewer` to `code-reviewer`
2. ✓ Added Step 2 to read `.claude/settings.json` for fileExtensions
3. ✓ Replaced hardcoded TypeScript glob with dynamic pattern based on extensions
4. ✓ Fixed rules file path to `${CLAUDE_PLUGIN_ROOT}/rules.md`
5. ✓ Implemented bash argument parsing for `--report`, `--issue`, `--scope`
6. ✓ Fixed step numbering (now Steps 1-9)
7. ✓ Updated error handling and notes sections
8. ✓ Fixed variable names (generate_report → GENERATE_REPORT, etc.)

## Success Criteria

- [x] Agent name matches existing `code-reviewer`
- [x] Respects `fileExtensions` from settings.json
- [x] Rules path is consistent
- [x] `--report` generates markdown report
- [x] `--scope` limits review to specific path
- [x] Works for Python, JS, TS files (not just TS)

## Verification Steps

After changes:
1. Test `/full-review` with Python files
2. Verify it uses correct agent
3. Check report generation with `--report`
4. Confirm scope limiting with `--scope`

## Non-Goals (Unchanged)

- Won't create `automatic-code-reviewer` agent (unnecessary duplication)
- Won't modify main `/review` command (already works)
- Won't change shell script (`code-review-plugin.sh` - no changes needed)
- Won't modify `rules.md` content

---
*Implementation completed successfully*
