# Travel Kit 💼

![test](https://github.com/evolutics/travel-kit/workflows/test/badge.svg)

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

  Only applied to files matching patterns: `*.nix`

  Command:

  ```bash
  alejandra --
  ```

  </details>

- [**Black**](https://github.com/psf/black)

  <details>

  <summary>Details of <code>black</code></summary>

  Only applied to files matching patterns: `*.py`, `*.pyi`

  Command:

  ```bash
  black --
  ```

  </details>

- [**Git diff check**](https://git-scm.com/docs/git-diff#Documentation/git-diff.txt---check)

  <details>

  <summary>Details of <code>git</code></summary>

  Only applied to files matching patterns: `*`

  Command:

  ```bash
  git diff --check 'HEAD^' --
  ```

  </details>

- [**Gitlint**](https://jorisroovers.com/gitlint/)

  <details>

  <summary>Details of <code>gitlint</code></summary>

  Command:

  ```bash
  gitlint --ignore body-is-missing
  ```

  </details>

- [**Haskell Dockerfile Linter**](https://hackage.haskell.org/package/hadolint)

  <details>

  <summary>Details of <code>hadolint</code></summary>

  Only applied to files matching patterns: `*.Dockerfile`, `Dockerfile`

  Command:

  ```bash
  hadolint --
  ```

  </details>

- [**HTML5 Validator**](https://github.com/svenkreiss/html5validator)

  <details>

  <summary>Details of <code>html5validator</code></summary>

  Only applied to files matching patterns: `*.css`, `*.htm`, `*.html`, `*.svg`, `*.xht`, `*.xhtml`

  Command:

  ```bash
  html5validator --also-check-css --also-check-svg --Werror --
  ```

  </details>

- [**HTMLHint**](https://github.com/htmlhint/HTMLHint)

  <details>

  <summary>Details of <code>htmlhint</code></summary>

  Only applied to files matching patterns: `*.htm`, `*.html`

  Command:

  ```bash
  htmlhint --
  ```

  </details>

- [**isort**](https://github.com/PyCQA/isort)

  <details>

  <summary>Details of <code>isort</code></summary>

  Only applied to files matching patterns: `*.py`, `*.pyi`

  Command:

  ```bash
  isort --force-single-line-imports --from-first --profile black --
  ```

  </details>

- [**Jsonnet linter**](https://jsonnet.org/learning/tools.html)

  <details>

  <summary>Details of <code>jsonnet-lint</code></summary>

  Only applied to files matching patterns: `*.jsonnet`, `*.libsonnet`

  Command:

  ```bash
  jsonnet-lint --
  ```

  </details>

- [**Jsonnet formatter**](https://jsonnet.org/learning/tools.html)

  <details>

  <summary>Details of <code>jsonnetfmt</code></summary>

  Only applied to files matching patterns: `*.jsonnet`, `*.libsonnet`

  Command:

  ```bash
  jsonnetfmt --in-place --
  ```

  </details>

- [**Prettier**](https://prettier.io)

  <details>

  <summary>Details of <code>prettier</code></summary>

  Only applied to files matching patterns: `*.css`, `*.htm`, `*.html`, `*.js`, `*.json`, `*.md`, `*.toml`, `*.ts`, `*.xht`, `*.xhtml`, `*.xml`, `*.yaml`, `*.yml`

  Command:

  ```bash
  prettier --plugin … --write --
  ```

  </details>

- [**Pylint**](https://pylint.readthedocs.io/en/stable/)

  <details>

  <summary>Details of <code>pylint</code></summary>

  Only applied to files matching patterns: `*.py`

  Command:

  ```bash
  pylint --
  ```

  </details>

- [**Rufo**](https://github.com/ruby-formatter/rufo)

  <details>

  <summary>Details of <code>rufo</code></summary>

  Only applied to files matching patterns: `*.rb`, `Vagrantfile`

  Command:

  ```bash
  rufo --
  ```

  </details>

- [**ShellCheck**](https://hackage.haskell.org/package/ShellCheck)

  <details>

  <summary>Details of <code>shellcheck</code></summary>

  Only applied to files matching patterns: `*.sh`

  Command:

  ```bash
  shellcheck --
  ```

  </details>

- [**shfmt**](https://github.com/mvdan/sh)

  <details>

  <summary>Details of <code>shfmt</code></summary>

  Only applied to files matching patterns: `*.sh`

  Command:

  ```bash
  shfmt --binary-next-line --case-indent --indent 2 --list --write --
  ```

  </details>

- [**Stylelint**](https://stylelint.io)

  <details>

  <summary>Details of <code>stylelint</code></summary>

  Only applied to files matching patterns: `*.css`

  Command:

  ```bash
  stylelint --
  ```

  </details>

- [**Terraform fmt**](https://developer.hashicorp.com/terraform/cli/commands/fmt)

  <details>

  <summary>Details of <code>terraform</code></summary>

  Only applied to files matching patterns: `*.tf`

  Command:

  ```bash
  terraform fmt --
  ```

  </details>
