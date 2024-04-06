def get():
    return r"""# Travel Kit 💼

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

By default, this affects only Git-tracked files in the current folder and its subfolders (recursively).

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

{menu}"""
