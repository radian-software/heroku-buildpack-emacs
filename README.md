Heroku buildpack: Emacs
=======================

This is a [Heroku buildpack](http://devcenter.heroku.com/articles/buildpacks)
for [GNU Emacs](https://www.gnu.org/software/emacs/) apps.

[Cask](https://github.com/cask/cask) (project management tool) is
also installed.

Usage
-----

Example usage:

    $ ls
    Cask
    init.el
    ...

    $ heroku create myapp --buildpack https://github.com/kosh04/heroku-buildpack-emacs

    $ git push heroku master
    ...
    -----> Heroku receiving push
    -----> Fetching custom git buildpack... done
    -----> Emacs Lisp app detected
    -----> Install Emacs
    ...

OK. your apps can execute `emacs` or `cask exec emacs`.


How to compile the buildpack Emacs
----------------------------------

[Emacs binary package](https://github.com/kosh04/heroku-buildpack-emacs/releases/tag/v1.0-beta)
is made with the following command. (See detail `bin/compile.mk`)

    ./configure --without-all --without-x --prefix=/app/.heroku/vendor

Executable full path name depends on `--prefix`
This case `emacs` is `/app/.heroku/bin/emacs`.
