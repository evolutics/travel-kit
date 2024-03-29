def get():
    return r"""# Travel Kit 💼

![test](https://github.com/evolutics/travel-kit/workflows/test/badge.svg)

Common code formatters and linters in a single Nix flake.

## Installation

As a prerequisite, you need Nix to use this flake. You can integrate it into a
flake as in this [example](example/flake.nix). To use it ad hoc instead, run

```bash
nix run --no-write-lock-file github:evolutics/travel-kit -- {{check,fix}} …
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

{menu}"""
