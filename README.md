# Travel Kit 💼

![test](https://github.com/evolutics/travel-kit/workflows/test/badge.svg)

Common code formatters and linters in a single Nix flake.

## Installation

As a prerequisite, you need Nix to use this flake. You can integrate it into a
flake as in this [example](example/flake.nix). To use it ad hoc instead, run

```bash
nix run --no-write-lock-file github:evolutics/travel-kit -- {check,fix} …
```

## Usage

Usage modes:

- [Checking](#checking-code) your code for its format, linting errors, and more.
- [Fixing](#fixing-code) your code automatically if possible.

### Checking code

Check code with

```bash
travel-kit check
```

This checks the current folder and its subfolders (recursively).

To only check certain files (say `a.js` and `b.md`), pass their paths at the end as in

```bash
travel-kit check a.js b.md
```

You can use this to only check files tracked by Git with

```bash
git ls-files -z | xargs -0 travel-kit check --
```

To not apply certain tools, use the `--skip` option.

### Fixing code

Fix code with

```bash
travel-kit fix --dry-run
```

To actually apply the changes (warning: this overwrites original files), drop the `--dry-run` option in the example.

## Related projects

- [Super-linter](https://github.com/super-linter/super-linter)
- [`treefmt`](https://github.com/numtide/treefmt)

## Tools

The following tools are integrated:

- [**Alejandra**](https://github.com/kamadorueda/alejandra)

  <details>

  <summary>Details of <code>alejandra</code></summary>

  Only applied to files matching regex: `\.nix$`

  `check` command:

  ```bash
  alejandra --check --
  ```

  `fix` command:

  ```bash
  alejandra --
  ```

  </details>

- [**Black**](https://github.com/psf/black)

  <details>

  <summary>Details of <code>black</code></summary>

  Only applied to files matching regex: `\.(py|pyi)$`

  `check` command:

  ```bash
  black --check --diff --
  ```

  `fix` command:

  ```bash
  black --
  ```

  </details>

- [**Git diff check**](https://git-scm.com/docs/git-diff#Documentation/git-diff.txt---check)

  <details>

  <summary>Details of <code>git</code></summary>

  Only used if command returns 0: `git rev-parse`

  Only applied to files.

  `check` command:

  ```bash
  git diff --check 'HEAD^' --
  ```

  </details>

- [**Gitlint**](https://jorisroovers.com/gitlint/)

  <details>

  <summary>Details of <code>gitlint</code></summary>

  Only used if command returns 0: `git rev-parse`

  `check` command:

  ```bash
  gitlint --ignore body-is-missing
  ```

  </details>

- [**Haskell Dockerfile Linter**](https://hackage.haskell.org/package/hadolint)

  <details>

  <summary>Details of <code>hadolint</code></summary>

  Only applied to files matching regex: `(^|[./])Dockerfile$`

  `check` command:

  ```bash
  hadolint --
  ```

  </details>

- [**HTML5 Validator**](https://github.com/svenkreiss/html5validator)

  <details>

  <summary>Details of <code>html5validator</code></summary>

  Only applied to files matching regex: `\.(css|htm|html|svg|xht|xhtml)$`

  `check` command:

  ```bash
  html5validator --also-check-css --also-check-svg --Werror --
  ```

  </details>

- [**HTMLHint**](https://github.com/htmlhint/HTMLHint)

  <details>

  <summary>Details of <code>htmlhint</code></summary>

  Only applied to files matching regex: `\.(htm|html)$`

  `check` command:

  ```bash
  htmlhint --
  ```

  </details>

- [**isort**](https://github.com/PyCQA/isort)

  <details>

  <summary>Details of <code>isort</code></summary>

  Only applied to files matching regex: `\.(py|pyi)$`

  `check` command:

  ```bash
  isort --force-single-line-imports --from-first --profile black --check --diff --
  ```

  `fix` command:

  ```bash
  isort --force-single-line-imports --from-first --profile black --
  ```

  </details>

- [**Jsonnet linter**](https://jsonnet.org/learning/tools.html)

  <details>

  <summary>Details of <code>jsonnet-lint</code></summary>

  Only applied to files matching regex: `\.(jsonnet|libsonnet)$`

  `check` command:

  ```bash
  jsonnet-lint --
  ```

  </details>

- [**Jsonnet formatter**](https://jsonnet.org/learning/tools.html)

  <details>

  <summary>Details of <code>jsonnetfmt</code></summary>

  Only applied to files matching regex: `\.(jsonnet|libsonnet)$`

  `check` command:

  ```bash
  jsonnetfmt --test --
  ```

  `fix` command:

  ```bash
  jsonnetfmt --in-place --
  ```

  </details>

- [**Prettier**](https://prettier.io)

  <details>

  <summary>Details of <code>prettier</code></summary>

  Only applied to files matching regex: `\.(css|htm|html|js|json|md|toml|ts|xht|xhtml|xml|yaml|yml)$`

  `check` command:

  ```bash
  prettier --plugin … --check --
  ```

  `fix` command:

  ```bash
  prettier --plugin … --write --
  ```

  </details>

- [**Pylint**](https://pylint.readthedocs.io/en/stable/)

  <details>

  <summary>Details of <code>pylint</code></summary>

  Only applied to files matching regex: `\.py$`

  `check` command:

  ```bash
  pylint --
  ```

  </details>

- [**Rufo**](https://github.com/ruby-formatter/rufo)

  <details>

  <summary>Details of <code>rufo</code></summary>

  Only applied to files matching regex: `(\.rb|(^|/)Vagrantfile)$`

  `check` command:

  ```bash
  rufo --check --
  ```

  `fix` command:

  ```bash
  rufo --simple-exit --
  ```

  </details>

- [**ShellCheck**](https://hackage.haskell.org/package/ShellCheck)

  <details>

  <summary>Details of <code>shellcheck</code></summary>

  Only applied to files matching regex: `\.sh$`

  `check` command:

  ```bash
  shellcheck --
  ```

  </details>

- [**shfmt**](https://github.com/mvdan/sh)

  <details>

  <summary>Details of <code>shfmt</code></summary>

  Only applied to files matching regex: `\.sh$`

  `check` command:

  ```bash
  shfmt --binary-next-line --case-indent --indent 2 --diff --
  ```

  `fix` command:

  ```bash
  shfmt --binary-next-line --case-indent --indent 2 --list --simplify --write --
  ```

  </details>

- [**Stylelint**](https://stylelint.io)

  <details>

  <summary>Details of <code>stylelint</code></summary>

  Only applied to files matching regex: `\.css$`

  `check` command:

  ```bash
  stylelint --
  ```

  </details>

- [**Terraform fmt**](https://developer.hashicorp.com/terraform/cli/commands/fmt)

  <details>

  <summary>Details of <code>terraform</code></summary>

  Only applied to files matching regex: `\.tf$`

  `check` command:

  ```bash
  terraform fmt -check -diff --
  ```

  `fix` command:

  ```bash
  terraform fmt --
  ```

  </details>
