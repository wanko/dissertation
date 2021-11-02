# Latex Paper Template

This contains a simple template including our bibliography and comments style
setup to build with [latexmk] out of the box.

Please read our [collaboration guide][guide] before using this template.

## Building

Before building this paper, the following packages need to be installed:

- [latexmk]
  (see [installation instructions][install])

A [Makefile](Makefile) is provided to build the paper:

```sh
$ make
```

If you use this repository as a template, note that github does not properly
carry over submodules. Just run

```sh
$ make init
```

to add the required submodules. Afterward, you should add/commit/push the
changes.

[install]: https://latextools.readthedocs.io/en/latest/install/
[latexmk]: https://ctan.org/pkg/latexmk
[guide]: https://github.com/krr-up/latex-collaboration-guide
