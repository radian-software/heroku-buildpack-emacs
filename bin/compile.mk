# Build minimum Emacs

# Usage:
#   $ make -f compile.mk BUILD_DIR=$1

VERSION=24.5
EMACS_SOURCE_URL=http://ftpmirror.gnu.org/emacs/emacs-${VERSION}.tar.xz

VENDOR_DIR=/app/.heroku/vendor

EMACS_PACKAGE=${BUILD_DIR}/emacs-${VERSION}-heroku-bin.tar.xz

default: ${EMACS_PACKAGE}

${EMACS_PACKAGE}:
	curl -L --silent ${EMACS_SOURCE_URL} | tar xJm --strip-components=1
	./configure --without-all --without-x --prefix=${VENDOR_DIR}
	make
	make install-strip
	tar cJf ${EMACS_PACKAGE} -C ${VENDOR_DIR} .

setup: ${EMACS_PACKAGE}
	mkdir -p ${BUILD_DIR}/.heroku/vendor
	tar xJf ${EMACS_PACKAGE} -C ${BUILD_DIR}/.heroku/vendor

.PHONY: setup
