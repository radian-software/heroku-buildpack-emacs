# Emacs buildpack for Heroku

This is a [Heroku buildpack][buildpack] which installs [GNU
Emacs][emacs].

## Usage

To install Emacs for your Heroku app called `<myapp>`, run:

    $ heroku buildpacks:add                                 \
        https://github.com/raxod502/heroku-buildpack-emacs  \
        -a <myapp>

After the next time you deploy your app, `emacs` will be available on
the `PATH`.

Note that this buildpack compiles Emacs from scratch on every deploy,
which is rather slow. This could be improved in future by utilizing
the cache; pull requests to that effect would be appreciated.

## Trivia

This repository was originally forked from
[kosh04/heroku-buildpack-emacs][upstream], but since then literally
all of the code and documentation was rewritten, so I marked it as a
source repository and added a license.

[buildpack]: https://devcenter.heroku.com/articles/buildpacks
[emacs]: https://www.gnu.org/software/emacs/
[upstream]: https://github.com/kosh04/heroku-buildpack-emacs
