def get():
    return r"""# Travel Kit 💼

![test](https://github.com/evolutics/travel-kit/workflows/test/badge.svg)

Common code formatters and linters in a single Alpine Docker image.

If you'd like to use your own mix of tools instead, take a look at [Code Cleaner Buffet](https://github.com/evolutics/code-cleaner-buffet).

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

To not apply certain tools, use the `--skip` option.

### Fixing code

Fix code with

```bash
docker run --rm --volume "$(pwd)":/workdir evolutics/travel-kit fix --dry-run
```

To actually apply the changes (warning: this overwrites original files), drop the `--dry-run` option in the example.

## Tools

The following tools are integrated:

{menu}"""
