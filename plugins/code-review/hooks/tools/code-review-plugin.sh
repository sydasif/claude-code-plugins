#!/usr/bin/env bash
set -euo pipefail

if ! command -v jq >/dev/null 2>&1; then
  echo "ERROR: jq is required but not installed." >&2
  echo "Install with: brew install jq (macOS) or apt-get install jq (Linux)" >&2
  exit 1
fi

COMMAND="${1:-}"

if [[ -z "$COMMAND" ]]; then
  echo "Usage: $0 {log}" >&2
  exit 1
fi

timestamp() {
  date -u +"%Y-%m-%dT%H:%M:%SZ"
}

get_project_root() {
  git rev-parse --show-toplevel 2>/dev/null || pwd
}

log_event() {
  local session_id="$1"
  local event_type="$2"
  shift 2

  local log_dir="$(get_project_root)/.claude/code-review"
  mkdir -p "$log_dir"
  local log_file="${log_dir}/event-log.jsonl"
  touch "$log_file"

  local event_json
  case "$event_type" in
    file_modified)
      local file="$1"
      local tool="$2"
      event_json=$(jq -nc \
        --arg ts "$(timestamp)" \
        --arg event "$event_type" \
        --arg file "$file" \
        --arg tool "$tool" \
        '{timestamp: $ts, event: $event, file: $file, tool: $tool}')
      ;;

    *)
      return 1
      ;;
  esac

  (
    flock -x 200
    echo "$event_json" >> "$log_file"
  ) 200>"${log_file}.lock"
}

get_or_initialize_plugin_settings() {
  local session_id="$1"

  local plugin_root="${CLAUDE_PLUGIN_ROOT:-$(pwd)/plugins/code-review}"
  local settings_file=".claude/settings.json"
  local rules_file="${plugin_root}/rules.md"

  if [[ ! -f "$settings_file" ]] || ! jq -e '.codeReview' "$settings_file" >/dev/null 2>&1; then
    local init_flag="/tmp/code-review-initialized-${session_id}"
    if [[ ! -f "$init_flag" ]]; then
      mkdir -p .claude/code-review

      local existing
      if [[ -f "$settings_file" ]]; then
        existing=$(cat "$settings_file")
      else
        existing="{}"
      fi

      local rules_path="${plugin_root}/rules.md"
      echo "$existing" | jq \
        --arg rp "$rules_path" \
        --arg pypath "${plugin_root}/rules/python-rules.md" \
        --arg jspath "${plugin_root}/rules/javascript-rules.md" \
        --arg tspath "${plugin_root}/rules/typescript-rules.md" \
        --arg javapath "${plugin_root}/rules/java-rules.md" \
        --arg gopath "${plugin_root}/rules/go-rules.md" \
        --arg cpcpath "${plugin_root}/rules/cpp-rules.md" \
        --arg csharppath "${plugin_root}/rules/csharp-rules.md" \
        --arg phppath "${plugin_root}/rules/php-rules.md" \
        --arg rubypath "${plugin_root}/rules/ruby-rules.md" \
        --arg swiftpath "${plugin_root}/rules/swift-rules.md" \
        --arg kotlinpath "${plugin_root}/rules/kotlin-rules.md" \
        --arg rustpath "${plugin_root}/rules/rust-rules.md" \
        --arg dartpath "${plugin_root}/rules/dart-rules.md" \
        '
        .codeReview = {
          "enabled": true,
          "fileExtensions": ["py", "js", "ts", "java", "cpp", "go", "cs", "php", "rb", "swift", "kt", "rs", "dart", "md", "sh"],
          "rulesFile": $rp,
          "languageSpecificRules": {
            "python": $pypath,
            "javascript": $jspath,
            "typescript": $tspath,
            "java": $javapath,
            "go": $gopath,
            "cpp": $cpcpath,
            "csharp": $csharppath,
            "php": $phppath,
            "ruby": $rubypath,
            "swift": $swiftpath,
            "kotlin": $kotlinpath,
            "rust": $rustpath,
            "dart": $dartpath
          }
        }
      ' > "$settings_file"

      if [[ ! -f "$rules_file" ]]; then
        cp "${plugin_root}/rules.md" "$rules_file" 2>/dev/null || true
      fi

      # Create language-specific rules files if they don't exist
      local rules_src_dir="$(dirname "$0")/../rules"
      local rules_dest_dir="${plugin_root}/rules"
      
      for lang_file in "${rules_src_dir}"/*-rules.md; do
        if [[ -f "$lang_file" ]]; then
          local dest_file="${rules_dest_dir}/$(basename "$lang_file")"
          [[ ! -f "$dest_file" ]] && cp "$lang_file" "$dest_file" 2>/dev/null || true
        fi
      done

      echo "✅ code-review plugin initialized!" >&2
      echo "   Updated: .claude/settings.json" >&2
      echo "   Created: ${CLAUDE_PLUGIN_ROOT}/rules.md (default rules)" >&2
      echo "   Created: Language-specific rules in ${CLAUDE_PLUGIN_ROOT}/rules/" >&2
      echo "   Customize the rules files for your project." >&2

      touch "$init_flag"
    fi
  fi

  jq -r '.codeReview // {}' "$settings_file" 2>/dev/null || echo '{}'
}

get_language_from_extension() {
  local file_path="$1"
  local extension="${file_path##*.}"

  case "$extension" in
    py) echo "python" ;;
    js) echo "javascript" ;;
    ts|tsx) echo "typescript" ;;
    java) echo "java" ;;
    cpp|cxx|cc) echo "cpp" ;;
    go) echo "go" ;;
    rs) echo "rust" ;;
    cs) echo "csharp" ;;
    php) echo "php" ;;
    rb) echo "ruby" ;;
    swift) echo "swift" ;;
    kt|kts) echo "kotlin" ;;
    dart) echo "dart" ;;
    *) echo "unknown" ;;
  esac
}

cmd_log() {
  INPUT=$(cat)

  TOOL_NAME=$(echo "$INPUT" | jq -r '.tool_name // ""')
  SESSION_ID=$(echo "$INPUT" | jq -r '.session_id // ""')
  FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // ""')

  if [[ -z "$SESSION_ID" ]]; then
    echo "Warning: No session ID provided for log command, skipping" >&2
    exit 0
  fi

  SETTINGS=$(get_or_initialize_plugin_settings "$SESSION_ID")
  ENABLED=$(echo "$SETTINGS" | jq -r '.enabled // true')

  [[ "$ENABLED" != "true" ]] && exit 0

  case "$TOOL_NAME" in
    Write|Edit|MultiEdit) ;;
    *) exit 0 ;;
  esac

  [[ -z "$FILE_PATH" ]] && exit 0

  EXTENSIONS=$(echo "$SETTINGS" | jq -r '.fileExtensions | join("|")' 2>/dev/null || echo "")
  if [[ -z "$EXTENSIONS" ]]; then
    exit 0
  fi

  FILE_MATCHES=false
  for ext in $(echo "$EXTENSIONS" | tr '|' ' '); do
    if [[ "$FILE_PATH" == *".$ext" ]]; then
      FILE_MATCHES=true
      break
    fi
  done

  [[ "$FILE_MATCHES" = false ]] && exit 0

  log_event "$SESSION_ID" file_modified "$FILE_PATH" "$TOOL_NAME" || true

  exit 0
}

case "$COMMAND" in
  log) cmd_log ;;
  *)
    echo "Error: unknown command: $COMMAND" >&2
    echo "Usage: $0 {log}" >&2
    exit 1
    ;;
esac
