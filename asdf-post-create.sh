#!/usr/bin/env bash

cd "${0%/*}/.."

# this is not set during `postCreateCommand`, it is injected into the environment by extension JS
if [ -z "$CODESPACE_VSCODE_FOLDER" ]; then
  CODESPACE_VSCODE_FOLDER=$(find /workspaces -maxdepth 1 -mindepth 1 -type d -not -path '*/\.*' -print -quit)
  echo "CODESPACE_VSCODE_FOLDER is not defined, using derived folder $CODESPACE_VSCODE_FOLDER"
fi

# find all .tool-versions within the repo, but ignore all hidden directories
/bin/find $CODESPACE_VSCODE_FOLDER -type d -path '*/.*' -prune -o -name '*.tool-version*' -print | while read filePath; do
  echo "asdf setup for $filePath"

  # install all required plugins
  cat $filePath | cut -d' ' -f1 | grep "^[^\#]" | xargs -i asdf plugin add {}

  # install all required versions
  (cd $(dirname $filePath) && asdf install)
done

# automatically startup a docker-compose that exists in the devcontainer folder
if test -f $CODESPACE_VSCODE_FOLDER/.devcontainer/docker-compose.yml; then
  echo "docker-compose found, starting up"
  (cd $CODESPACE_VSCODE_FOLDER/.devcontainer && docker compose up -d)
fi