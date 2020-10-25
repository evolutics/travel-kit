def get():
    return """# Travel Kit 💼

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

{menu}

If you'd like to use another mix of tools instead, take a look at [Code Cleaner Buffet](https://github.com/evolutics/code-cleaner-buffet). It integrates many more code cleaners."""
