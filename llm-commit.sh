#!/usr/bin/env zsh

set -e

# Parse command line flags
SHOW_PROMPT=false
while [[ $# -gt 0 ]]; do
  case $1 in
    --show_prompt)
      SHOW_PROMPT=true
      shift
      ;;
    *)
      shift
      ;;
  esac
done

# This script passes the staged git changes to the llm command line tool with a prompt
# instructing it to format the changes into a conventional commit message.  Then it
# prints the commit message to the console and waits for user confirmation via a 'y' key press.
# If any other key is pressed, the script exits.  If 'y' is pressed, the script calls git commit
# with the formatted commit message.

# Setup:
# ```
# ollama pull qwen2.5-coder:7b-instruct
# llm install llm-ollama
# ```

# Check if there are any staged changes
if [[ -z "$(git diff --staged)" ]]; then
    echo "No staged changes to commit."
    exit 0
fi

CHANGES_PROMPT=$(cat <<EOF
Produce a git commit message for the changes listed below after the ===CHANGES=== line.
- You MUST use the conventional commits format.
- The summary line MUST be in the format: \`<type>(<scope>): <description>\`.
- You MUST use one of the following types: feat, fix, docs, style, refactor, perf, test, chore.
- You MAY include additional lines after the summary line explaining specific changes in single sentences.
- You MUST only output the text of the git commit message, with no other formatting.

Example:

  feat(ui): This is a one-line summary of the entire set of changes.

  - This is a one-line summary of a specific change.
  - This is another one-line summary of another part of the changes.

===CHANGES===
$(git diff --staged)
EOF
)

if [[ $SHOW_PROMPT == true ]]; then
  echo "Prompt"
  echo "----------------------"
  echo "$CHANGES_PROMPT"
  echo "----------------------"
  echo
fi

# Works with
# -m gemma3:27b
# -m qwen2.5-coder:7b-instruct
# -m qwen2.5-coder:14b

COMMIT_MESSAGE=$(echo "$CHANGES_PROMPT" | llm -m qwen2.5-coder:7b-instruct)

echo "Proposed commit message:"
echo "----------------------"
echo "$COMMIT_MESSAGE"
echo "----------------------"

echo -n "Press 'y' to commit with this message, any other key to abort: "
read -k 1 key
echo # Move to a new line after key press

if [[ $key == "y" ]]; then
    git commit -F - <<< "$COMMIT_MESSAGE"
    echo "Changes committed successfully!"
else
    echo "Commit aborted."
    exit 1
fi
