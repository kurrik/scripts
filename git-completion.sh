#!/bin/zsh

# This script provides zsh completion for the git scripts in this repo.
#
# Usage:
# 1. Source this file in your shell configuration file (.bashrc, .bash_profile, etc.):
#
#   if [[ -f "$PATH_TO_SCRIPTS_PROJECT/git-completion.sh" ]]; then
#     source "$PATH_TO_SCRIPTS_PROJECT/git-completion.sh"
#   fi
#
# After installation, tab completion will work with the git scripts in this repo.
# For example:
#    git llm-c <TAB>

# Function to handle completion for our custom git subcommands
_git_llm_commit() {
  local cur
  cur="${words[CURRENT]}"

  # Define options for llm-commit subcommand
  compadd -- --show_prompt --model
}

# Register our custom subcommand with git's completion system
zstyle ':completion:*:*:git:*' user-commands llm-commit:'generate commit message using LLM'
