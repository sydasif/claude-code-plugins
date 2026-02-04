---
name: codebase-review
description: Run codebase review with project-specific skills
---

# Full Codebase Review

Review the entire codebase against `${CLAUDE_PLUGIN_ROOT}/skills/` using the `code-reviewer` subagent.

## Procedure

### Step 1: Read Configuration

Read `.claude/settings.json` to get configured file extensions:

```text
Use Read tool on: .claude/settings.json
```

Extract `fileExtensions` array from `.codeReview` section. If not found or settings file doesn't exist, use defaults: `["py", "js", "go", "rs", "cs"]`.

### Step 2: Discover Files

Build glob pattern from configured extensions:

```text
Pattern: **/*.{ext1,ext2,ext3,...}
```

Example: If extensions are `["py", "js", "go", "rs", "cs"]`, use pattern `**/*.{py,js,go,rs,cs}`

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

### Step 3: Chunk Files

Split file list into chunks of ~30 files each.

Chunking logic:

- If total files <= 30: single chunk
- Otherwise: split evenly into chunks of ~30 files

Report: "Split into X chunks of ~Y files each"

### Step 4: Review Each Chunk

For each chunk, spawn the `code-reviewer` subagent:

```text
Use Task tool with:
- subagent_type: "code-reviewer"
- prompt: "Review these files: [file1, file2, ...]"
```

**Important:** The code-reviewer will:

1. Read `.claude/settings.json` to get the configuration
2. For each file, determine the appropriate skill based on the file extension and language-specific configuration
3. Apply the appropriate language-specific skill to each file
4. Return findings in structured format

Collect ALL findings from each chunk.

### Step 5: Aggregate Results

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

### Step 6: Display Summary

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

## Error Handling

- If no files found: Report "No matching files found for extensions [ext1, ext2, ...]" and exit
- If skill not found: Warn but continue with basic review (code-reviewer agent handles this)
- If chunk review fails: Log error, continue with remaining chunks
- If `gh` not installed: Warn and skip issue creation
- If `.claude/settings.json` not found: Use default extensions ["py", "js", "go", "rs", "cs"]

## Notes

- This reuses the existing `code-reviewer` agent from this plugin
- Uses language-specific skills based on file extensions and configuration in `.claude/settings.json`.
- Ensuring appropriate skills are applied to each file type
- Respects `fileExtensions` configuration from `.claude/settings.json`
- Supports any programming language configured in `fileExtensions` (Python, JavaScript, Go, Rust, C#)
