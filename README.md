# Travel Kit 💼

![test](https://github.com/evolutics/travel-kit/workflows/test/badge.svg)

Common code formatters and linters in a single Nix flake.

## Usage

Usage modes:

- [Checking](#checking-code) your code for its format, linting errors, and more.
- [Fixing](#fixing-code) your code automatically if possible.

As a prerequisite, you need Nix to use this flake `github:evolutics/travel-kit`.

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

## Tools

The following tools are integrated:

- **Alejandra**

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

- **Black**

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

- **Git**

  <details>

  <summary>Details of <code>git</code></summary>

  Only used if command returns 0: `git rev-parse`

  Only applied to files.

  `check` command:

  ```bash
  git diff --check HEAD^ --
  ```

  </details>

- **Gitlint**

  <details>

  <summary>Details of <code>gitlint</code></summary>

  Only used if command returns 0: `git rev-parse`

  `check` command:

  ```bash
  gitlint --ignore body-is-missing
  ```

  </details>

- **Haskell Dockerfile Linter**

  <details>

  <summary>Details of <code>hadolint</code></summary>

  Only applied to files matching regex: `(^|[./])Dockerfile$`

  `check` command:

  ```bash
  hadolint --
  ```

  </details>

- **HTML5 Validator**

  <details>

  <summary>Details of <code>html5validator</code></summary>

  Only applied to files matching regex: `\.(css|htm|html|svg|xht|xhtml)$`

  `check` command:

  ```bash
  html5validator --also-check-css --also-check-svg --Werror --
  ```

  </details>

- **HTMLHint**

  <details>

  <summary>Details of <code>htmlhint</code></summary>

  Only applied to files matching regex: `\.(htm|html)$`

  `check` command:

  ```bash
  htmlhint --
  ```

  </details>

- **Prettier**

  <details>

  <summary>Details of <code>prettier</code></summary>

  Only applied to files matching regex: `\.(css|htm|html|js|json|md|toml|ts|xht|xhtml|xml|yaml|yml)$`

  `check` command:

  ```bash
  prettier --check --plugin … --
  ```

  `fix` command:

  ```bash
  prettier --plugin … --write --
  ```

  </details>

- **Pylint**

  <details>

  <summary>Details of <code>pylint</code></summary>

  Only applied to files matching regex: `\.py$`

  `check` command:

  ```bash
  pylint
  ```

  </details>

- **ShellCheck**

  <details>

  <summary>Details of <code>shellcheck</code></summary>

  Only applied to files matching regex: `\.sh$`

  `check` command:

  ```bash
  shellcheck --
  ```

  </details>

- **shfmt**

  <details>

  <summary>Details of <code>shfmt</code></summary>

  Only applied to files matching regex: `\.sh$`

  `check` command:

  ```bash
  shfmt -bn -ci -d -i 2 --
  ```

  `fix` command:

  ```bash
  shfmt -bn -ci -i 2 -l -s -w --
  ```

  </details>

- **stylelint**

  <details>

  <summary>Details of <code>stylelint</code></summary>

  Only applied to files matching regex: `\.css$`

  `check` command:

  ```bash
  stylelint --
  ```

  </details>
