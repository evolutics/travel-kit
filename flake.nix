{
  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nixos/nixpkgs/nixos-unstable";
    };
    treefmt-nix = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:numtide/treefmt-nix";
    };
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
            inherit (pkgs.gitlint.meta) homepage;
            command = [
              "${pkgs.gitlint}/bin/gitlint"
              "--ignore"
              "body-is-missing"
            ];
            file_patterns = [];
          };
          hadolint = {
            title = "Haskell Dockerfile Linter";
            inherit (pkgs.hadolint.meta) homepage;
            command = ["${pkgs.hadolint}/bin/hadolint" "--"];
            file_patterns = ["*.Dockerfile" "Dockerfile"];
          };
          htmlhint = {
            title = "HTMLHint";
            inherit (pkgs.nodePackages.htmlhint.meta) homepage;
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
            inherit (pkgs.pylint.meta) homepage;
            command = ["${pkgs.pylint}/bin/pylint" "--"];
            file_patterns = ["*.py"];
          };
          shellcheck = {
            title = "ShellCheck";
            inherit (pkgs.shellcheck.meta) homepage;
            command = ["${pkgs.shellcheck}/bin/shellcheck" "--"];
            file_patterns = ["*.sh"];
          };
          stylelint = {
            title = "Stylelint";
            inherit (pkgs.nodePackages.stylelint.meta) homepage;
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
              "--walk"
              "filesystem"
              # `"--"` would break treefmt as it seems to append `--tree-root`.
            ];
            file_patterns = let
              formatters = builtins.attrValues treefmtEval.config.settings.formatter;
              includes =
                builtins.concatMap (formatter: formatter.includes) formatters;
            in
              nixpkgs.lib.lists.unique (nixpkgs.lib.lists.naturalSort includes);
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
        treefmtEval = treefmt-nix.lib.evalModule pkgs ({pkgs, ...}: {
          programs.alejandra.enable = true;
          programs.black.enable = true;
          programs.buildifier.enable = true;
          programs.cljfmt.enable = true;
          programs.isort.enable = true;
          programs.jsonnetfmt.enable = true;
          programs.prettier.enable = true;
          programs.rufo.enable = true;
          programs.sqruff.enable = true;
          programs.statix.enable = true;
          programs.taplo.enable = true;
          programs.terraform.enable = true;

          projectRootFile = "flake.nix";

          settings.formatter = {
            isort.options = [
              "--force-single-line-imports"
              "--from-first"
              "--profile"
              "black"
              "--"
            ];
            rufo.includes = ["*Vagrantfile"];
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
