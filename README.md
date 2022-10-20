# ASDF Devcontainer for GitHub Codespaces

I've been having fun playing with GitHub codespaces. One of the things that has seemed odd to me is the language-specific
development environments. Most projects—even small side projects—have multiple languages. Composing these images feels
messy. I've always enjoyed `asdf` for managing language versions in a unified fashion.

This project builds a devcontainer image (for use with GitHub Codespace) setup with asdf support. It also includes a nice
utility script for installing all asdf plugins, finding all `.tool-versions` files, installing the versions specified,
and starting up a `docker-compose.yml` if one exists.

Main design goals:

* Include all relevant packages that most popular languages require for install. The `Dockerfile` is very aggressive with
  including many packages so the container can install asdf packages in many languages. I am no sysadmin so there may be
  negative side effects with this approach.
* Fix homebrew not working due to out of date image. This means `apt-get update` in the build, combined with a monthly
  gh actions cron, fixes this.
* Easily install all asdf plugins used in a project. `/asdf-post-create.sh` finds all `.tool-versions` included in the repo
  and installs the relevant asdf plugins.
* Easily start `docker-compose` services. For instance, if your project requires postgres + redis, you can include a `docker-compose.yml`
  file in `.devcontainer/` and it will be started when you run `/asdf-post-create.sh`.

Here are the languages I've confirmed compile and run via asdf on this image:

* Elixir + Erlang
* Python
* Ruby
* NodeJS
* Deno
* Bun
* PHP

## Usage

Check out `devcontainer-example`. Use it in your project with `cp -R ~/Projects/asdf-devcontainer/devcontainer-example your-new-project/.devcontainer`.

Here's what your `devcontainer.json` should look like:

```json
{
	"image": "iloveitaly/asdf-devcontainer:0-ubuntu-22.04",
	"postCreateCommand": "/asdf-post-create.sh && bin/setup",
	"remoteUser": "vscode",
	"features": {
		"homebrew": "latest",
		"ghcr.io/devcontainers/features/sshd:1": {
			"version": "latest"
		},
		"ghcr.io/devcontainers/features/docker-in-docker:1": {
			"version": "latest",
			"dockerDashComposeVersion":"v2"
		}
	}
}
```

## Development

Easiest way to iterate on this image is to setup a codespace and rebuild the Dockerfile. Some tips:

* What base variants exist? `http https://mcr.microsoft.com/v2/vscode/devcontainers/base/tags/list | fzf`
* Build on a different base variant `docker build -t asdf-devcontainer . --build-arg VARIANT=dev-ubuntu`
* Run a shell inside the image `docker run --rm -it asdf-devcontainer bash -lc `
* Get github webhook structure for github actions development `gh api repos/iloveitaly/asdf-devcontainer/events`
* [View all available devcontainer features](https://github.com/devcontainers/features/tree/main/src)
* [Devcontainers open source spec](https://containers.dev/implementors/json_reference/)
