# Travel Kit 💼

![build](https://github.com/evolutics/travel-kit/workflows/build/badge.svg)

Common code formatters and linters in a single Alpine Docker image.

## Usage

Usage modes:

- [Checking](#checking-code) your code for its format, linting errors, and more.
- [Fixing](#fixing-code) your code automatically if possible.

As a prerequisite, you need Docker to use the image [`evolutics/travel-kit`](https://hub.docker.com/r/evolutics/travel-kit).

### Checking code

Check code with

```bash
docker run --rm --volume "$(pwd)":/workdir evolutics/travel-kit check
```

This checks the current folder (`pwd`) and its subfolders (recursively).

To only check certain files (say `a.js` and `b.md`), pass their paths at the end as in

```bash
docker run --rm --volume "$(pwd)":/workdir evolutics/travel-kit check a.js b.md
```

You can use this to only check files tracked by Git with

```bash
docker run --entrypoint sh --rm --volume "$(pwd)":/workdir \
  evolutics/travel-kit -c 'git ls-files -z | xargs -0 travel-kit check --'
```

### Fixing code

Fix code with

```bash
docker run --rm --volume "$(pwd)":/workdir evolutics/travel-kit fix --dry-run
```

To actually apply the changes (warning: this overwrites original files), drop the `--dry-run` option in the example.

## Tools

The following tools are integrated:

<details>
<summary><strong>Ansible Lint</strong></summary>

`check` command:

```bash
ansible-lint
```

</details>

<details>
<summary><strong>Black</strong></summary>

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

<details>
<summary><strong>Git</strong></summary>

Only used if command returns 0: `git rev-parse`

Only applied to files.

`check` command:

```bash
git diff --check HEAD^ --
```

</details>

<details>
<summary><strong>Gitlint</strong></summary>

Only used if command returns 0: `git rev-parse`

`check` command:

```bash
gitlint --ignore body-is-missing
```

</details>

<details>
<summary><strong>Haskell Dockerfile Linter</strong></summary>

Only applied to files matching regex: `(^|\.)Dockerfile$`

`check` command:

```bash
hadolint --
```

</details>

<details>
<summary><strong>Hunspell</strong></summary>

Only used if command returns 0: `git rev-parse`

`check` command:

```bash
git log -1 --format=%B \
  | hunspell -l -d en_US -p ci/personal_words.dic \
  | sort | uniq | tr '\n' '\0' | xargs -0 -r -n 1 sh -c \
  'echo "Misspelling: $@"; exit 1' --
```

</details>

<details>
<summary><strong>Prettier</strong></summary>

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

<details>
<summary><strong>Pylint</strong></summary>

Only applied to files matching regex: `\.py$`

`check` command:

```bash
pylint --
```

</details>

If you'd like to use another mix of tools instead, take a look at [Code Cleaner Buffet](https://github.com/evolutics/code-cleaner-buffet). It integrates many more code cleaners.
