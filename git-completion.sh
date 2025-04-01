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

_git_scripts_completion() {
  local cur
  cur="${words[CURRENT]}"

  # Define the subcommand.
  # Add more subcommands as needed.
  local subcommands="llm-commit"

  # Complete subcommands.
  COMPREPLY=($(compgen -W "${subcommands}" -- "$cur"))
}

# Register the completion function for the git command
complete -F _git_scripts_completion git
