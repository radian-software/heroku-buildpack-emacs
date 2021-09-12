#!/usr/bin/env bash

set -euxo pipefail
cd /tmp

wget "https://ftpmirror.gnu.org/emacs/emacs-${VERSION}.tar.xz"
tar -xf "emacs-${VERSION}.tar.xz"

cd "emacs-${VERSION}"
./configure --without-all --without-x --with-gnutls=yes --prefix=/app/emacs
make -j"$(nproc)"
make install-strip prefix=/app/emacs

tar -cf /tmp/emacs.tar.gz /app/emacs -P
