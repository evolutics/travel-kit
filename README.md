# Travel Kit 💼

Common code formatters and linters in a single Nix flake.

## Installation

As a prerequisite, you need Nix to use this flake. You can integrate it into a
flake as in this [example](example/flake.nix). To use it ad hoc instead, run

```bash
nix run --no-write-lock-file github:evolutics/travel-kit -- [argument …]
```

## Usage

To format your code and check for linting errors, simply run

```bash
# WARNING: this overwrites original files.
travel-kit
```

By default, this affects only Git-tracked files in the current folder and its
subfolders (recursively).

To only check certain files (say `a.js` and `b.md`), pass their paths as in

```bash
travel-kit a.js b.md
```

To not apply certain tools, use the `--skip` option.

The `--dry-run` option shows what would be done without changing anything.

## Related projects

- [Super-linter](https://github.com/super-linter/super-linter)
- [`treefmt`](https://github.com/numtide/treefmt)

## Tools

The following tools are integrated:

- [**Alejandra**](https://github.com/kamadorueda/alejandra)

  ```bash
  alejandra -- *.nix
  ```

- [**Black**](https://github.com/psf/black)

  ```bash
  black -- *.py *.pyi
  ```

- [**Git diff check**](https://git-scm.com/docs/git-diff#Documentation/git-diff.txt---check)

  ```bash
  git diff --check 'HEAD^' -- *
  ```

- [**Gitlint**](https://jorisroovers.com/gitlint/)

  ```bash
  gitlint --ignore body-is-missing
  ```

- [**Haskell Dockerfile Linter**](https://hackage.haskell.org/package/hadolint)

  ```bash
  hadolint -- *.Dockerfile Dockerfile
  ```

- [**HTML5 Validator**](https://github.com/svenkreiss/html5validator)

  ```bash
  html5validator --also-check-css --also-check-svg --Werror -- *.css *.htm *.html *.svg *.xht *.xhtml
  ```

- [**HTMLHint**](https://github.com/htmlhint/HTMLHint)

  ```bash
  htmlhint -- *.htm *.html
  ```

- [**isort**](https://github.com/PyCQA/isort)

  ```bash
  isort --force-single-line-imports --from-first --profile black -- *.py *.pyi
  ```

- [**Jsonnet linter**](https://jsonnet.org/learning/tools.html)

  ```bash
  jsonnet-lint -- *.jsonnet *.libsonnet
  ```

- [**Jsonnet formatter**](https://jsonnet.org/learning/tools.html)

  ```bash
  jsonnetfmt --in-place -- *.jsonnet *.libsonnet
  ```

- [**Prettier**](https://prettier.io)

  ```bash
  prettier --plugin … --write -- *.css *.htm *.html *.js *.json *.md *.toml *.ts *.xht *.xhtml *.xml *.yaml *.yml
  ```

- [**Pylint**](https://pylint.readthedocs.io/en/stable/)

  ```bash
  pylint -- *.py
  ```

- [**Rufo**](https://github.com/ruby-formatter/rufo)

  ```bash
  rufo -- *.rb Vagrantfile
  ```

- [**ShellCheck**](https://hackage.haskell.org/package/ShellCheck)

  ```bash
  shellcheck -- *.sh
  ```

- [**shfmt**](https://github.com/mvdan/sh)

  ```bash
  shfmt --binary-next-line --case-indent --indent 2 --list --write -- *.sh
  ```

- [**Stylelint**](https://stylelint.io)

  ```bash
  stylelint -- *.css
  ```

- [**Terraform fmt**](https://developer.hashicorp.com/terraform/cli/commands/fmt)

  ```bash
  terraform fmt -- *.tf
  ```
