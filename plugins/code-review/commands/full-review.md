---
argument-hint: [--report] [--issue] [--scope <path>]
description: Run full codebase review using code-reviewer agent with project-specific rules
allowed-tools: Glob, Read, Write, Bash, Task
---

# Full Codebase Review

Review the entire codebase against `${CLAUDE_PLUGIN_ROOT}/rules.md` - the same rules used for automatic code review on modified files, but applied to everything.

## Arguments

- `--report`: Save findings to `docs/reviews/YYYY-MM-DD-full-review.md`
- `--issue`: Create GitHub issue with findings summary
- `--scope <path>`: Limit to specific path (default: entire codebase)

## Procedure

### Step 1: Check Plugin Status and Parse Arguments

First, check if the plugin is enabled before proceeding:

```bash
# Check if plugin is enabled
ENABLED=$(jq -r '.codeReview.enabled // true' .claude/settings.json 2>/dev/null || echo "true")
if [[ "$ENABLED" != "true" ]]; then
  echo "Code review plugin is disabled in settings" >&2
  exit 0
fi
```

Then, parse `$ARGUMENTS` using Bash:

```bash
# Initialize variables
GENERATE_REPORT=false
CREATE_ISSUE=false
SCOPE_PATH="."

# Parse arguments
while [[ $# -gt 0 ]]; do
  case "$1" in
    --report)
      GENERATE_REPORT=true
      shift
      ;;
    --issue)
      CREATE_ISSUE=true
      shift
      ;;
    --scope)
      if [[ -n "$2" && "$2" != --* ]]; then
        SCOPE_PATH="$2"
        shift 2
      else
        echo "Error: --scope requires a path argument" >&2
        exit 1
      fi
      ;;
    *)
      echo "Warning: Unknown argument: $1" >&2
      shift
      ;;
  esac
done

# Validate and sanitize SCOPE_PATH to prevent path traversal
if [[ "$SCOPE_PATH" != /* ]]; then
  # If relative path, convert to absolute and ensure it's within current directory
  SCOPE_PATH_REAL=$(realpath "$SCOPE_PATH" 2>/dev/null || echo ".")
  CURRENT_DIR_REAL=$(realpath . 2>/dev/null || pwd)
  if [[ ! "$SCOPE_PATH_REAL" =~ ^"$CURRENT_DIR_REAL"(/|$) ]]; then
    echo "Error: Scope path must be within current directory" >&2
    exit 1
  fi
else
  # If absolute path, ensure it's within reasonable bounds (implementation-dependent)
  # For security, we may want to restrict absolute paths in certain contexts
  : # Placeholder - implement as needed
fi
```

Variables set:
- `GENERATE_REPORT`: true if `--report` present
- `CREATE_ISSUE`: true if `--issue` present  
- `SCOPE_PATH`: value after `--scope` or defaults to "."

### Step 2: Read Configuration

Read `.claude/settings.json` to get configured file extensions:

```text
Use Read tool on: .claude/settings.json
```

Extract `fileExtensions` array from `.codeReview` section. If not found or settings file doesn't exist, use defaults: `["py", "js", "ts", "md", "sh"]`.

### Step 3: Discover Files

Build glob pattern from configured extensions:

```text
Pattern: **/*.{ext1,ext2,ext3,...}
```

Example: If extensions are `["py", "js", "ts"]`, use pattern `**/*.{py,js,ts}`

Edge case handling:
- If fileExtensions array is empty [], exit gracefully with message "No matching files found for extensions []"
- If fileExtensions has only one element like ["py"], the pattern should be **/*.py (not **/*.{py})

The Glob tool respects `.gitignore`, so `node_modules/`, `dist/`, etc. are automatically excluded.

If `SCOPE_PATH` is set (not "."), use that as the base path for the glob.

**Categorize files:**

- Test files: any file matching `*.spec.*`, `*.test.*`, `*_test.*`, `*_spec.*`
- Production files: all other matching files

**Store the complete file lists** - these will be included in the report appendix.

Report:

```text
Found X files to review:
- Production files: Y
- Test files: Z
- File extensions: [list of extensions used]
```

### Step 4: Chunk Files

Split file list into chunks of ~30 files each.

Chunking logic:

- If total files <= 30: single chunk
- Otherwise: split evenly into chunks of ~30 files

Report: "Split into X chunks of ~Y files each"

### Step 5: Review Each Chunk

For each chunk, spawn the `code-reviewer` subagent:

```text
Use Task tool with:
- subagent_type: "code-reviewer"
- prompt: "Review these files: [file1, file2, ...]"
```

**Important:** The code-reviewer will:

1. Read `.claude/settings.json` to find the rules file
2. Read the rules file (`${CLAUDE_PLUGIN_ROOT}/rules.md`)
3. Review each file against ALL rules
4. Return findings in structured format

Collect ALL findings from each chunk.

### Step 6: Aggregate Results

Combine findings from all chunks into categories:

1. **Architecture/Modularity Violations**
2. **Coding Standards Violations**
3. **Testing Standards Violations**
4. **Dangerous Fallback Values**
5. **Anti-Pattern Violations**
6. **Duplicated Code**
7. **Other Findings** (anything that doesn't fit the above)
8. **Suggested Updates**

Deduplicate similar findings.
Sort by severity (Critical > High > Medium > Low).

### Step 7: Display Summary

Always display a summary to the user:

```text
## Full Codebase Review Complete

**Files reviewed:**
- Production files: X
- Test files: Y
- Total: Z

**Chunks processed:** N
**Total violations found:** V

### By Category:
- Architecture/Modularity: N
- Coding Standards: N
- Testing Standards: N
- Dangerous Fallbacks: N
- Anti-Patterns: N
- Duplicated Code: N
- Other: N

### Top Issues:
1. [Most critical finding]
2. [Second most critical]
3. [Third most critical]
```

### Step 8: Generate Report (if --report)

If `GENERATE_REPORT` is true:

1. Create directory: `docs/reviews/` (if doesn't exist)
2. Write report to: `docs/reviews/YYYY-MM-DD-full-review.md`

Report format:

```markdown
# Full Codebase Review - YYYY-MM-DD

## Summary

- **Production files reviewed:** X
- **Test files reviewed:** Y
- **Total files reviewed:** Z
- **Chunks processed:** N
- **Total violations:** V
- **Review rules:** ${CLAUDE_PLUGIN_ROOT}/rules.md

## Architecture/Modularity Violations

[List all findings with file:line, issue, suggested fix]

## Coding Standards Violations

[List all findings]

## Testing Standards Violations

[List all findings]

## Dangerous Fallback Values

[List all findings]

## Anti-Pattern Violations

[List all findings]

## Duplicated Code

[List all findings]

## Other Findings

[Anything that doesn't fit the categories above]

## Suggested Updates to Conventions

Based on patterns found in this review:

1. [Suggestion for updating docs/conventions/]
2. [Another suggestion]

---

## Appendix: Files Reviewed

### Production Files (X)

<details>
<summary>Click to expand full list</summary>

- path/to/file1.ts
- path/to/file2.ts
...
</details>

### Test Files (Y)

<details>
<summary>Click to expand full list</summary>

- path/to/file1.spec.ts
- path/to/file2.test.ts
...
</details>

---

*Generated by full-codebase-review plugin*
```

Report: "Report saved to docs/reviews/YYYY-MM-DD-full-review.md"

### Step 9: Create GitHub Issue (if --issue)

If `CREATE_ISSUE` is true:

Use Bash to create issue via `gh`:

```bash
gh issue create \
  --title "Full Codebase Review - YYYY-MM-DD" \
  --body "$(cat <<'EOF'
## Summary

- Files reviewed: X
- Total violations: Z

## Action Required

### Critical (fix immediately)
- [ ] [Critical finding 1]
- [ ] [Critical finding 2]

### High Priority
- [ ] [High priority finding 1]
- [ ] [High priority finding 2]

## Full Report

See: docs/reviews/YYYY-MM-DD-full-review.md (if --report was used)

---
*Generated by full-codebase-review plugin*
EOF
)" \
  --label "tech-debt" \
  --label "code-review"
```

Report the issue URL.

## Error Handling

- If no files found: Report "No matching files found for extensions [ext1, ext2, ...]" and exit
- If rules file not found: Warn but continue with basic review (code-reviewer agent handles this)
- If chunk review fails: Log error, continue with remaining chunks
- If `gh` not installed: Warn and skip issue creation
- If `.claude/settings.json` not found: Use default extensions ["py", "js", "ts", "md", "sh"]

## Notes

- This reuses the existing `code-reviewer` agent from this plugin
- The same `${CLAUDE_PLUGIN_ROOT}/rules.md` file is used, ensuring consistency between `/review` command and full reviews
- Respects `fileExtensions` configuration from `.claude/settings.json`
- Large codebases may take significant time - consider using `--scope` to limit
- Supports any programming language configured in `fileExtensions` (Python, JavaScript, TypeScript, etc.)
