def get():
    return r"""# Travel Kit 💼

![test](https://github.com/evolutics/travel-kit/workflows/test/badge.svg)

Common code formatters and linters in a single Nix flake.

## Usage

Usage modes:

- [Checking](#checking-code) your code for its format, linting errors, and more.
- [Fixing](#fixing-code) your code automatically if possible.

As a prerequisite, you need Nix to use this flake (see
[example](example/flake.nix)).

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

{menu}"""
