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

[buildpack]: https://devcenter.heroku.com/articles/buildpacks
[emacs]: https://www.gnu.org/software/emacs/
