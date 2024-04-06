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

  <details>

  <summary>Details of <code>alejandra</code></summary>

  Command (file patterns apply recursively):

  ```bash
  alejandra -- *.nix
  ```

  </details>

- [**Black**](https://github.com/psf/black)

  <details>

  <summary>Details of <code>black</code></summary>

  Command (file patterns apply recursively):

  ```bash
  black -- *.py *.pyi
  ```

  </details>

- [**Git diff check**](https://git-scm.com/docs/git-diff#Documentation/git-diff.txt---check)

  <details>

  <summary>Details of <code>git</code></summary>

  Command (file patterns apply recursively):

  ```bash
  git diff --check 'HEAD^' -- *
  ```

  </details>

- [**Gitlint**](https://jorisroovers.com/gitlint/)

  <details>

  <summary>Details of <code>gitlint</code></summary>

  Command (file patterns apply recursively):

  ```bash
  gitlint --ignore body-is-missing
  ```

  </details>

- [**Haskell Dockerfile Linter**](https://hackage.haskell.org/package/hadolint)

  <details>

  <summary>Details of <code>hadolint</code></summary>

  Command (file patterns apply recursively):

  ```bash
  hadolint -- *.Dockerfile Dockerfile
  ```

  </details>

- [**HTML5 Validator**](https://github.com/svenkreiss/html5validator)

  <details>

  <summary>Details of <code>html5validator</code></summary>

  Command (file patterns apply recursively):

  ```bash
  html5validator --also-check-css --also-check-svg --Werror -- *.css *.htm *.html *.svg *.xht *.xhtml
  ```

  </details>

- [**HTMLHint**](https://github.com/htmlhint/HTMLHint)

  <details>

  <summary>Details of <code>htmlhint</code></summary>

  Command (file patterns apply recursively):

  ```bash
  htmlhint -- *.htm *.html
  ```

  </details>

- [**isort**](https://github.com/PyCQA/isort)

  <details>

  <summary>Details of <code>isort</code></summary>

  Command (file patterns apply recursively):

  ```bash
  isort --force-single-line-imports --from-first --profile black -- *.py *.pyi
  ```

  </details>

- [**Jsonnet linter**](https://jsonnet.org/learning/tools.html)

  <details>

  <summary>Details of <code>jsonnet-lint</code></summary>

  Command (file patterns apply recursively):

  ```bash
  jsonnet-lint -- *.jsonnet *.libsonnet
  ```

  </details>

- [**Jsonnet formatter**](https://jsonnet.org/learning/tools.html)

  <details>

  <summary>Details of <code>jsonnetfmt</code></summary>

  Command (file patterns apply recursively):

  ```bash
  jsonnetfmt --in-place -- *.jsonnet *.libsonnet
  ```

  </details>

- [**Prettier**](https://prettier.io)

  <details>

  <summary>Details of <code>prettier</code></summary>

  Command (file patterns apply recursively):

  ```bash
  prettier --plugin … --write -- *.css *.htm *.html *.js *.json *.md *.toml *.ts *.xht *.xhtml *.xml *.yaml *.yml
  ```

  </details>

- [**Pylint**](https://pylint.readthedocs.io/en/stable/)

  <details>

  <summary>Details of <code>pylint</code></summary>

  Command (file patterns apply recursively):

  ```bash
  pylint -- *.py
  ```

  </details>

- [**Rufo**](https://github.com/ruby-formatter/rufo)

  <details>

  <summary>Details of <code>rufo</code></summary>

  Command (file patterns apply recursively):

  ```bash
  rufo -- *.rb Vagrantfile
  ```

  </details>

- [**ShellCheck**](https://hackage.haskell.org/package/ShellCheck)

  <details>

  <summary>Details of <code>shellcheck</code></summary>

  Command (file patterns apply recursively):

  ```bash
  shellcheck -- *.sh
  ```

  </details>

- [**shfmt**](https://github.com/mvdan/sh)

  <details>

  <summary>Details of <code>shfmt</code></summary>

  Command (file patterns apply recursively):

  ```bash
  shfmt --binary-next-line --case-indent --indent 2 --list --write -- *.sh
  ```

  </details>

- [**Stylelint**](https://stylelint.io)

  <details>

  <summary>Details of <code>stylelint</code></summary>

  Command (file patterns apply recursively):

  ```bash
  stylelint -- *.css
  ```

  </details>

- [**Terraform fmt**](https://developer.hashicorp.com/terraform/cli/commands/fmt)

  <details>

  <summary>Details of <code>terraform</code></summary>

  Command (file patterns apply recursively):

  ```bash
  terraform fmt -- *.tf
  ```

  </details>
