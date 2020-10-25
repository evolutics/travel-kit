# Travel Kit 💼

![build](https://github.com/evolutics/travel-kit/workflows/build/badge.svg)

Common code formatters and linters in a single Alpine Docker image.

## Usage

As a prerequisite, you need Docker to use the image [`evolutics/travel-kit`](https://hub.docker.com/r/evolutics/travel-kit).

**Check** code with

```bash
docker run --rm --volume "$(pwd)":/workdir evolutics/travel-kit check
```

**Fix** code with

```bash
docker run --rm --volume "$(pwd)":/workdir evolutics/travel-kit fix --dry-run
```

To actually apply the changes (warning: this overwrites original files), drop the `--dry-run` option in the example.

## Tools

The following tools are integrated:

- **Black**

  <details>

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

  Only used in Git repositories.

  Only applied to files.

  `check` command:

  ```bash
  git diff --check HEAD^ --
  ```

  </details>

- **Gitlint**

  <details>

  Only used in Git repositories.

  `check` command:

  ```bash
  gitlint --ignore body-is-missing
  ```

  </details>

- **Haskell Dockerfile Linter**

  <details>

  Only applied to files matching regex: `(^|\.)Dockerfile$`

  `check` command:

  ```bash
  hadolint --
  ```

  </details>

- **Hunspell**

  <details>

  Only used in Git repositories.

  `check` command:

  ```bash
  git log -1 --format=%B \
    | hunspell -l -d en_US -p ci/personal_words.dic \
    | sort | uniq | tr '\n' '\0' | xargs -0 -r -n 1 sh -c \
    'echo "Misspelling: $@"; exit 1' --
  ```

  </details>

- **Prettier**

  <details>

  Only applied to files matching regex: `\.(css|html|js|json|md|ts|yaml|yml)$`

  `check` command:

  ```bash
  prettier --check --
  ```

  `fix` command:

  ```bash
  prettier --write --
  ```

  </details>

If you'd like to use another mix of tools instead, take a look at [Code Cleaner Buffet](https://github.com/evolutics/code-cleaner-buffet). It integrates many more code cleaners.
