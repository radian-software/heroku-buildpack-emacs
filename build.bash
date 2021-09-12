#!/usr/bin/env bash

set -euxo pipefail

if (( $# != 2 )); then
    echo >&2 "usage: ./build.bash STACK_VERSION EMACS_VERSION"
    echo >&2 "  e.g. ./build.bash 20 27.2"
    exit 1
fi

STACK_VERSION="$1"
EMACS_VERSION="$2"

cwd="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"

image="heroku/heroku:${STACK_VERSION}-build"
container="heroku-buildpack-emacs"
tar="heroku-${STACK_VERSION}-emacs-${EMACS_VERSION}.tar.gz"

function docker {
    if [[ "${OSTYPE:-}" != darwin* ]] && [[ "${EUID}" != 0 ]]; then
        sudo -E docker "$@"
    else
        docker "$@"
    fi
}

docker rm -f "${container}" 2>/dev/null
docker pull "${image}"
docker run --name="${container}" --security-opt seccomp=unconfined -d "${image}" sleep infinity
docker cp "${cwd}/build_internal.bash" "${container}:/tmp/build_internal.bash"
docker exec -it -e VERSION="${EMACS_VERSION}" "${container}" /tmp/build_internal.bash
docker cp "${container}:/tmp/emacs.tar.gz" - | tar -xOf - > "${cwd}/${tar}"
docker rm -f "${container}" 2>/dev/null

echo "==> wrote ${tar}"
