# Emacs buildpack for Heroku

This is a [Heroku buildpack][buildpacks] which installs [GNU
Emacs][emacs] version 26.1.

## Usage

To install Emacs for your Heroku app called `<myapp>`, run:

    $ heroku buildpacks:add                                 \
        https://github.com/raxod502/heroku-buildpack-emacs  \
        -a <myapp>

After the next time you deploy your app, `emacs` will be available on
the `PATH`.

## How does it work?

Ideally, we could just use [heroku-buildpack-apt] to install Emacs.
Unfortunately, [this doesn't work][apt-emacs-issue], because the
Ubuntu package for Emacs is configured to be installed in `/usr`,
while Heroku apps are run from `/app` (and therefore any packages
accompanying an app must live inside `/app`).

You might think that we could just compile Emacs from source instead.
However, Heroku uses Docker, and [you can't compile Emacs inside a
Docker container][docker-emacs-issue] without changing certain
security options that Heroku doesn't support.

The solution? I compile Emacs myself inside a Docker container based
on the Heroku image, running with the necessary security options on my
own computer, install Emacs to `/app` in the container, and then copy
out the tarball to upload to GitHub releases on this repository. (Why
GitHub Releases? It's an easy way to host a large binary which doesn't
require the cooperation of another service.) At deploy time, the
buildpack just downloads and extracts this tarball. Simple!

Here is how I compile Emacs to obtain the tarball you see on GitHub
Releases:

    $ docker run -it --security-opt seccomp=unconfined heroku/heroku:18-build
    $ cd /tmp
    $ wget https://ftpmirror.gnu.org/emacs/emacs-26.1.tar.xz
    $ tar -xf emacs-26.1.tar.xz
    $ pushd emacs-26.1
    $ ./configure --without-all --without-x --with-gnutls=yes --prefix=/app/emacs
    $ make -j9
    $ make install-strip prefix=/app/emacs
    $ popd
    $ tar -C /app/emacs -cf emacs-for-heroku-26.1.tar.gz .
    $ exit
    $ docker cp <container-id>:/tmp/emacs-for-heroku-26.1.tar.gz <destination>

## Trivia

This repository was originally forked from
[kosh04/heroku-buildpack-emacs][upstream], but since then literally
all of the code and documentation was rewritten, so I marked it as a
source repository and added a license.

[apt-emacs-issue]: https://github.com/heroku/heroku-buildpack-apt/issues/37
[buildpacks]: https://devcenter.heroku.com/articles/buildpacks
[docker-emacs-issue]: https://github.com/moby/moby/issues/22801
[emacs]: https://www.gnu.org/software/emacs/
[heroku-buildpack-apt]: https://github.com/heroku/heroku-buildpack-apt
[upstream]: https://github.com/kosh04/heroku-buildpack-emacs
