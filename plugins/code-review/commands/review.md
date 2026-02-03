# /review

Description: Trigger a semantic code review on the codebase for modified files.

---

When this command is run, you should:

1. **Identify Changes**: Execute the review script to find files modified since the last review. You must provide the session context via stdin:
   `echo "{\"session_id\": \"$CLAUDE_SESSION_ID\"}" | ${CLAUDE_PLUGIN_ROOT}/hooks/tools/code-review-plugin.sh review`

2. **Handle Output**:
   - If the output indicates no files were modified (exits 0), inform the user: "No files have been modified since the last review."
   - If the output lists files and displays "📋 CODE REVIEW REQUIRED", proceed to the next step.

3. **Initiate Review**: Use the `Task` tool with `subagent_type: "code-reviewer"`. Pass the list of modified files as the prompt.
   The agent will follow the project-specific rules defined in your configuration.

4. **Summarize Results**: After the agent completes, show the findings to the user and follow the instructions provided in the script's output regarding which feedback to address.
