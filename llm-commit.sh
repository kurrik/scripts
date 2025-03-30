#!/usr/bin/env zsh

set -e

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

CHANGES_PROMPT=$(cat <<'EOF'
Summarize these changes using conventional commits format: `<type>(<scope>): <description>
- Types: feat, fix, docs, style, refactor, perf, test, chore.
- Include lines summarizing specific changes as bullets.
- You MUST only output the text of the git commit message, with no other formatting.
EOF
)

COMMIT_MESSAGE=$(git diff --staged | llm -m qwen2.5-coder:7b-instruct -s $CHANGES_PROMPT)

echo "Proposed commit message:"
echo "----------------------"
echo "$COMMIT_MESSAGE"
echo "----------------------"

read -n 1 -s -r -p "Press 'y' to commit with this message, any other key to abort: " key
echo # Move to a new line after key press

if [[ $key == "y" ]]; then
    git commit -F - <<< "$COMMIT_MESSAGE"
    echo "Changes committed successfully!"
else
    echo "Commit aborted."
    exit 1
fi
