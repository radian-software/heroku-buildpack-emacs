# Emacs buildpack for Heroku

This is a [Heroku
buildpack](https://devcenter.heroku.com/articles/buildpacks) which
installs [GNU Emacs](https://www.gnu.org/software/emacs/) for use on
server applications such as [GNU ELPA
Mirror](https://github.com/raxod502/gnu-elpa-mirror).

## Usage

To install Emacs for your Heroku app called `<myapp>`, run:

    $ heroku buildpacks:add                                 \
        https://github.com/raxod502/heroku-buildpack-emacs  \
        -a <myapp>

After the next time you deploy your app, `emacs` will be available on
the `PATH`.

## Configuration

Supported versions of Emacs are:

* `25.2`
* `25.3`
* `26.1`
* `26.2`
* `26.3`
* `27.1`
* `27.2`

By default the latest supported version will be selected. You can
force a specific version to be selected by setting `EMACS_VERSION`
appropriately in the app config (e.g. `heroku config:set EMACS_VERSION
27.2`).

Supported versions of the Heroku runtime are:

* `heroku-18`
* `heroku-20`

This is detected automatically during buildpack processing and cannot
be overridden.

## How does it work?

We have a script `build.bash` in this repository which does the
following things:

* Pull the latest version of the Heroku runtime base Docker image.
    * Run using `--security-opt seccomp=unconfined` to support
      pre-27.1 versions of Emacs that use some very sketchy OS
      features as part of the build process.
* Download the Emacs source code into it.
* Compile and install it with a prefix of `/app/emacs`.
* Create a tarball of that installation and export it outside the
  container.

Then I manually do the following:

* Create an empty tag in this repo named `heroku-VER-emacs-VER` (where
  the versions are for the Heroku stack and Emacs respectively).
* Upload the tarball to that tag as a GitHub Release. Provided I
  follow the existing naming convention, this is picked up
  automatically by the buildpack.

## Why not...?

* *Install using
  [heroku-buildpack-apt](https://github.com/heroku/heroku-buildpack-apt)*:
  Because [it doesn't
  work](https://github.com/heroku/heroku-buildpack-apt/issues/37),
  which is because Emacs installations are not relocatable.
* *Build from source at deployment time:* Because we can't use Docker
  when executing a buildpack.

## History

This repository was originally forked from
[kosh04/heroku-buildpack-emacs](https://github.com/kosh04/heroku-buildpack-emacs),
but today literally none of the original code or documentation
remains, so I marked it as a source repository and added a license.
