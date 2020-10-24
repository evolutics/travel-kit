def get():
    return """# Travel Kit 💼

![build](https://github.com/evolutics/travel-kit/workflows/build/badge.svg)

Common code formatters and linters in a single Alpine Docker image.

## Usage

As a prerequisite, you need Docker to use the image [`evolutics/travel-kit`](https://hub.docker.com/r/evolutics/travel-kit).

Run the following commands from a Git repository root because only tracked files are considered.

**Check** code with

```bash
docker run --rm --volume "$(pwd)":/workdir evolutics/travel-kit check
```

**Fix** code with

```bash
# Warning: this overwrites original files.
docker run --rm --volume "$(pwd)":/workdir evolutics/travel-kit fix
```

## Tools

The following tools are integrated:

{menu}

If you'd like to use another mix of tools instead, take a look at [Code Cleaner Buffet](https://github.com/evolutics/code-cleaner-buffet). It integrates many more code cleaners."""
