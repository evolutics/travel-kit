{
  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nixos/nixpkgs/nixos-unstable";
    };
    treefmt-nix.url = "github:numtide/treefmt-nix";
  };

  outputs = {
    flake-utils,
    nixpkgs,
    self,
    treefmt-nix,
    ...
  }:
    flake-utils.lib.eachDefaultSystem (
      system: let
        cleaners = builtins.toJSON {
          git = {
            title = "Git diff check";
            homepage = "https://git-scm.com/docs/git-diff#Documentation/git-diff.txt---check";
            command = ["${pkgs.git}/bin/git" "diff" "--check" "HEAD^" "--"];
            file_patterns = ["*"];
          };
          gitlint = {
            title = "Gitlint";
            homepage = pkgs.gitlint.meta.homepage;
            command = [
              "${pkgs.gitlint}/bin/gitlint"
              "--ignore"
              "body-is-missing"
            ];
            file_patterns = [];
          };
          hadolint = {
            title = "Haskell Dockerfile Linter";
            homepage = pkgs.hadolint.meta.homepage;
            command = ["${pkgs.hadolint}/bin/hadolint" "--"];
            file_patterns = ["*.Dockerfile" "Dockerfile"];
          };
          html5validator = {
            title = "HTML5 Validator";
            homepage = pkgs.html5validator.meta.homepage;
            command = [
              "${pkgs.html5validator}/bin/html5validator"
              "--also-check-css"
              "--also-check-svg"
              "--Werror"
              "--"
            ];
            file_patterns = [
              "*.css"
              "*.htm"
              "*.html"
              "*.svg"
              "*.xht"
              "*.xhtml"
            ];
          };
          htmlhint = {
            title = "HTMLHint";
            homepage = pkgs.nodePackages.htmlhint.meta.homepage;
            command = ["${pkgs.nodePackages.htmlhint}/bin/htmlhint" "--"];
            file_patterns = ["*.htm" "*.html"];
          };
          jsonnet-lint = {
            title = "Jsonnet linter";
            homepage = "https://jsonnet.org/learning/tools.html";
            command = ["${pkgs.go-jsonnet}/bin/jsonnet-lint" "--"];
            file_patterns = ["*.jsonnet" "*.libsonnet"];
          };
          pylint = {
            title = "Pylint";
            homepage = pkgs.pylint.meta.homepage;
            command = ["${pkgs.pylint}/bin/pylint" "--"];
            file_patterns = ["*.py"];
          };
          shellcheck = {
            title = "ShellCheck";
            homepage = pkgs.shellcheck.meta.homepage;
            command = ["${pkgs.shellcheck}/bin/shellcheck" "--"];
            file_patterns = ["*.sh"];
          };
          stylelint = {
            title = "Stylelint";
            homepage = pkgs.nodePackages.stylelint.meta.homepage;
            command = ["${pkgs.nodePackages.stylelint}/bin/stylelint" "--"];
            file_patterns = ["*.css"];
          };
          treefmt = {
            title = "treefmt";
            homepage = "https://github.com/numtide/treefmt";
            command = [
              "${treefmtEval.config.build.wrapper}/bin/treefmt"
              "--fail-on-change"
              "--no-cache"
              # `"--"` would break treefmt as it seems to append `--tree-root`.
            ];
            file_patterns = ["*"];
          };
        };
        package = pkgs.python3Packages.buildPythonApplication {
          format = "pyproject";
          name = "travel-kit";
          preBuild = ''
            cat >travelkit/cleaners.json <<'EOF'
            ${cleaners}
            EOF
          '';
          propagatedBuildInputs = [pkgs.python3Packages.setuptools];
          src = ./.;
        };
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
        treefmtDefaults =
          (treefmt-nix.lib.evalModule pkgs ({pkgs, ...}: {
            programs.prettier.enable = true;
            programs.rufo.enable = true;
          }))
          .config
          .settings
          .formatter;
        treefmtEval = treefmt-nix.lib.evalModule pkgs ({pkgs, ...}: {
          programs.alejandra.enable = true;
          programs.black.enable = true;
          programs.isort.enable = true;
          programs.jsonnetfmt.enable = true;
          programs.prettier = {
            enable = true;
            settings.plugins = [
              "${pkgs.nodePackages.prettier-plugin-toml}/lib/node_modules/prettier-plugin-toml/lib/index.cjs"
            ];
            includes = treefmtDefaults.prettier.includes ++ ["*.toml"];
          };
          programs.rufo.enable = true;
          programs.terraform.enable = true;

          projectRootFile = "flake.nix";

          settings.formatter = {
            isort = {
              options = [
                "--force-single-line-imports"
                "--from-first"
                "--profile"
                "black"
                "--"
              ];
            };
            rufo = {
              includes = treefmtDefaults.rufo.includes ++ ["Vagrantfile"];
            };
            shfmt = {
              command = "${pkgs.shfmt}/bin/shfmt";
              includes = ["*.sh"];
              options = [
                "--binary-next-line"
                "--case-indent"
                "--indent"
                "2"
                "--list"
                "--write"
              ];
            };
          };
        });
      in {
        apps.default = {
          program = "${package}/bin/travel-kit";
          type = "app";
        };
        packages.default = package;
      }
    );
}
