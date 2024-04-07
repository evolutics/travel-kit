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

This affects all Git-tracked files in the current folder and its subfolders
(recursively).

Alternatively, you can pass specific paths to precisely affect those files as in

```bash
travel-kit foo.js bar.md
```

To not apply certain tools, use the `--skip` option.

The `--dry-run` option shows what would be done without changing anything.

## Related projects

- [Super-linter](https://github.com/super-linter/super-linter)
- [`treefmt`](https://github.com/numtide/treefmt)

## Tools

The following tools are integrated:

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

- [**Jsonnet linter**](https://jsonnet.org/learning/tools.html)

  ```bash
  jsonnet-lint -- *.jsonnet *.libsonnet
  ```

- [**Pylint**](https://pylint.readthedocs.io/en/stable/)

  ```bash
  pylint -- *.py
  ```

- [**ShellCheck**](https://hackage.haskell.org/package/ShellCheck)

  ```bash
  shellcheck -- *.sh
  ```

- [**Stylelint**](https://stylelint.io)

  ```bash
  stylelint -- *.css
  ```

- [**treefmt**](https://github.com/numtide/treefmt)

  ```bash
  treefmt --fail-on-change --no-cache *.cjs *.css *.html *.js *.json *.json5 *.jsonnet *.jsx *.libsonnet *.md *.mdx *.mjs *.nix *.py *.pyi *.rb *.scss *.sh *.tf *.toml *.ts *.tsx *.vue *.yaml *.yml Vagrantfile
  ```
