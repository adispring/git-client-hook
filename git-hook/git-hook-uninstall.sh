#!/bin/bash

INSTALL_PATH="$(cd "$(dirname "$0")" && pwd -P)"
GIT_ROOT_DIR="$(git rev-parse --show-toplevel || echo "$INSTALL_PATH/../../..")"
PROJECT_ROOT=${PROJECT_ROOT:-$(cd "$GIT_ROOT_DIR"; pwd -P)}
FROM_HOOK_PATH="$INSTALL_PATH/hooks"
TO_HOOK_PATH="$PROJECT_ROOT/.git/hooks"
HOOK_FILE_NAMES=$(ls ${FROM_HOOK_PATH})

has_git_hooks_path() {
  git_hook_path=$1
  if [ ! -d "$git_hook_path" ]; then
    echo "No $git_hook_path exist!"
    exit 0
  fi
}

hook_check_before_uninstall() {
  for hook_file in ${HOOK_FILE_NAMES}
  do
    ALL_HOOKS+=($hook_file)
    if [ -f "$TO_HOOK_PATH/$hook_file" ]; then
      file_diff=$(diff "$FROM_HOOK_PATH/$hook_file" "$TO_HOOK_PATH/$hook_file")
      
      if [ -z "$file_diff" ]; then
        INSTALLED_HOOKS+=(${hook_file})
      else
        CHANGED_HOOKS+=(${hook_file})
      fi
    else
      NOT_INSTALLED_HOOKS+=(${hook_file})
    fi
  done
}

hook_uninstall() {
  if [ ${#NOT_INSTALLED_HOOKS[@]} -eq ${#ALL_HOOKS[@]} ]; then
    echo "No git hook need to uninstall."
  else
    echo -e "GIT CLIENT HOOK uninstalling...! ⚙ \n"
    if [ ${#CHANGED_HOOKS[@]} -gt 0 ]; then
      for hook_file in ${CHANGED_HOOKS[@]}
      do
        file_diff=$(diff "$FROM_HOOK_PATH/$hook_file" "$TO_HOOK_PATH/$hook_file")
        echo -e "${hook_file} has changed: \n${file_diff}"
        echo "${hook_file} will not uninstall, you can mannually uninstall it.\n"
       done
    fi
    if [ ${#INSTALLED_HOOKS[@]} -gt 0 ]; then
      for hook_file in ${INSTALLED_HOOKS[@]}
      do
        echo "${hook_file} uninstalling..."
        rm "$TO_HOOK_PATH/$hook_file"
        echo -e "${hook_file} uninstalled!\n"
       done
    fi
    echo "GIT CLIENT HOOK uninstall done!  🗑 "
  fi 
}

has_git_hooks_path $TO_HOOK_PATH
hook_check_before_uninstall
hook_uninstall

