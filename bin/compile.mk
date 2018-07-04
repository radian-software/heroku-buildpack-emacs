# Build minimum Emacs

# Usage:
#   $ make -f compile.mk [PREFIX=/path/to/dir]

PREFIX?=/app/.heroku/vendor

EMACS_NAME=emacs-26.1
EMACS_ARCHIVE=${EMACS_NAME}.tar.xz
EMACS_ARCHIVE_URL=http://ftpmirror.gnu.org/emacs/${EMACS_ARCHIVE}
EMACS_PACKAGE=/app/${EMACS_NAME}-heroku-bin.tar.xz

${EMACS_ARCHIVE}:
	curl -L -O ${EMACS_ARCHIVE_URL}

build: ${EMACS_ARCHIVE}
	tar xf ${EMACS_ARCHIVE}
	cd ${EMACS_NAME} && ./configure --without-all --without-x --with-gnutls=yes --prefix=${PREFIX}
	cd ${EMACS_NAME} && make -j9

install:
	cd ${EMACS_NAME} && make install-strip prefix=${PREFIX}

${EMACS_PACKAGE}:
	${MAKE} build install
	tar cJf ${EMACS_PACKAGE} -C ${PREFIX} .

install_package: ${EMACS_PACKAGE}
	mkdir -p ${PREFIX}
	tar xJf ${EMACS_PACKAGE} -C ${PREFIX}

.PHONY: build install install_package
