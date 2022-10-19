#!/usr/bin/env bash

cd "${0%/*}/.."

# when running in a codespace, this should always be set
if [ -z "$CODESPACE_VSCODE_FOLDER" ]; then
  echo "CODESPACE_VSCODE_FOLDER is not defined, defaulting to $HOME"
  CODESPACE_VSCODE_FOLDER="$HOME"
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
  docker compose up -d
fi