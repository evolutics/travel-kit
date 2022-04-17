#!/usr/bin/env python3

import argparse
import subprocess


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("image")
    arguments = parser.parse_args()

    base_image = _build_base_image()
    subprocess.run(
        [
            "docker",
            "build",
            "--build-arg",
            f"base_image={base_image}",
            "--tag",
            arguments.image,
            ".",
        ],
        check=True,
    )


def _build_base_image():
    return subprocess.run(
        [
            "docker",
            "build",
            "--build-arg",
            "black=22.3.0",
            "--build-arg",
            "git=2.30.3",
            "--build-arg",
            "gitlint=0.17.0",
            "--build-arg",
            "hadolint=2.10.0",
            "--build-arg",
            "htmlhint=1.1.4",
            "--build-arg",
            "prettier_toml=0.3.1",
            "--build-arg",
            "prettier_xml=2.1.0",
            "--build-arg",
            "prettier=2.6.2",
            "--build-arg",
            "pylint=2.13.5",
            "--build-arg",
            "shellcheck=0.8.0",
            "--build-arg",
            "shfmt=3.4.3",
            "--build-arg",
            "stylelint=14.7.0",
            "--build-arg",
            "vnu=21.10.12",
            "--quiet",
            "https://github.com/evolutics/code-cleaner-buffet.git#0.17.0",
        ],
        capture_output=True,
        check=True,
        env={"DOCKER_BUILDKIT": "1"},
        text=True,
    ).stdout.rstrip()


if __name__ == "__main__":
    main()
