#!/usr/bin/env bash

docker run --rm -it asdf-devcontainer bash -lc "echo 'python 3.10.8' > ~/.tool-versions && /asdf-post-create.sh && asdf reshim && python --version"

docker run --rm -it asdf-devcontainer bash -lc "echo 'php latest' > ~/.tool-versions && /asdf-post-create.sh && php --version"

docker run --rm -it asdf-devcontainer bash -lc "echo 'ruby 3.1.2' > ~/.tool-versions && /asdf-post-create.sh && asdf reshim && ruby --version"

docker run --rm -it asdf-devcontainer bash -lc "echo 'nodejs 18.11.0' > ~/.tool-versions && /asdf-post-create.sh && asdf reshim && node --version"

docker run --rm -it asdf-devcontainer bash -lc "echo 'bun 0.2.1' > ~/.tool-versions && /asdf-post-create.sh && asdf reshim && bun --version"

docker run --rm -it asdf-devcontainer bash -lc "echo 'deno 1.26.2' > ~/.tool-versions && /asdf-post-create.sh && asdf reshim && deno --version"

docker run --rm -it asdf-devcontainer bash -lc "echo -e 'elixir latest\nerlang latest' > ~/.tool-versions && /asdf-post-create.sh && asdf reshim && elixir --version"
