# docker build -t asdf-devcontainer . --build-arg dev-ubuntu

ARG VARIANT="0-ubuntu-22.04"
FROM mcr.microsoft.com/vscode/devcontainers/base:${VARIANT}

# needs to be declared *after* FROM to be available in shell scripts
ARG ASDF_BRANCH="v0.10.2"

LABEL org.opencontainers.image.authors="Michael Bianco <mike@mikebian.co>" \
      org.opencontainers.image.source=https://github.com/iloveitaly/asdf-devcontainer \
      org.opencontainers.image.licenses="MIT" \
      org.opencontainers.image.title="ASDF Devcontainer Image" \
      org.opencontainers.image.description="A Docker image for use with VS Code's Remote Containers extension or GitHub codespaces."

# adding a bunch of packages to avoid warnings and build errors over the main languages I use with asdf
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends \
    autoconf \
    build-essential \
    fop \
    libgl1-mesa-dev \
    libglu1-mesa-dev \
    libncurses-dev \
    libncurses5-dev \
    libpng-dev \
    libssh-dev \
    libxml2-utils \
    m4 \
    openjdk-11-jdk \
    unixodbc-dev \
    xsltproc \
    libbz2-dev \
    libncursesw5 \
    libsqlite3-dev \
    libffi-dev \
    python3-dev \
    libreadline-dev \
    libpq-dev \
    zlib1g-dev \
    postgresql-client \
    lzma-dev \
    liblzma-dev \
    automake \
    # php support: it requires a bunch of different packages to successfully compile
    libbison-dev \
    bison \
    re2c \
    locate \
    # https://stackoverflow.com/questions/37321397/no-package-libxml-2-0-found
    libxml++2.6-dev \
    libonig-dev \
    libzip-dev \
    libgd-dev

COPY ./asdf-post-install.sh /asdf-post-install.sh

# https://github.com/erlang/erlang-org/blob/f5538eea5546884097ef66ef29a6ae7a8d874069/.devcontainer/Dockerfile#L18
USER vscode
RUN git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch ${ASDF_BRANCH}

# including the asdf source in sh + bash profiles make it easier to run boostrap scripts
# which expect `asdf` to be available
RUN echo "\n. $HOME/.asdf/asdf.sh\n" | tee -a ~/.bashrc ~/.profile