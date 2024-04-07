{
  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nixos/nixpkgs/nixos-unstable";
    };
  };

  outputs = {
    flake-utils,
    nixpkgs,
    ...
  }:
    flake-utils.lib.eachDefaultSystem (
      system: let
        cleaners = builtins.toJSON {
          alejandra = {
            title = "Alejandra";
            homepage = pkgs.alejandra.meta.homepage;
            command = ["${pkgs.alejandra}/bin/alejandra" "--"];
            file_patterns = ["*.nix"];
          };
          black = {
            title = "Black";
            homepage = pkgs.black.meta.homepage;
            command = ["${pkgs.black}/bin/black" "--"];
            file_patterns = ["*.py" "*.pyi"];
          };
          git = {
            title = "Git diff check";
            homepage = "https://git-scm.com/docs/git-diff#Documentation/git-diff.txt---check";
            command = ["${pkgs.git}/bin/git" "diff" "--check" "HEAD^" "--"];
            file_patterns = ["*"];
          };
          gitlint = {
            title = "Gitlint";
            homepage = pkgs.gitlint.meta.homepage;
            command = ["${pkgs.gitlint}/bin/gitlint" "--ignore" "body-is-missing"];
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
          isort = {
            title = "isort";
            homepage = pkgs.isort.meta.homepage;
            command = [
              "${pkgs.isort}/bin/isort"
              "--force-single-line-imports"
              "--from-first"
              "--profile"
              "black"
              "--"
            ];
            file_patterns = ["*.py" "*.pyi"];
          };
          jsonnet-lint = {
            title = "Jsonnet linter";
            homepage = "https://jsonnet.org/learning/tools.html";
            command = ["${pkgs.go-jsonnet}/bin/jsonnet-lint" "--"];
            file_patterns = ["*.jsonnet" "*.libsonnet"];
          };
          jsonnetfmt = {
            title = "Jsonnet formatter";
            homepage = "https://jsonnet.org/learning/tools.html";
            command = ["${pkgs.go-jsonnet}/bin/jsonnetfmt" "--in-place" "--"];
            file_patterns = ["*.jsonnet" "*.libsonnet"];
          };
          prettier = {
            title = "Prettier";
            homepage = pkgs.nodePackages.prettier.meta.homepage;
            command = [
              "${pkgs.nodePackages.prettier}/bin/prettier"
              "--plugin"
              "${pkgs.nodePackages.prettier-plugin-toml}/lib/node_modules/prettier-plugin-toml/lib/index.cjs"
              "--write"
              "--"
            ];
            file_patterns = [
              "*.css"
              "*.htm"
              "*.html"
              "*.js"
              "*.json"
              "*.md"
              "*.toml"
              "*.ts"
              "*.xht"
              "*.xhtml"
              "*.xml"
              "*.yaml"
              "*.yml"
            ];
          };
          pylint = {
            title = "Pylint";
            homepage = pkgs.pylint.meta.homepage;
            command = ["${pkgs.pylint}/bin/pylint" "--"];
            file_patterns = ["*.py"];
          };
          rufo = {
            title = "Rufo";
            homepage = pkgs.rufo.meta.homepage;
            command = ["${pkgs.rufo}/bin/rufo" "--"];
            file_patterns = ["*.rb" "Vagrantfile"];
          };
          shellcheck = {
            title = "ShellCheck";
            homepage = pkgs.shellcheck.meta.homepage;
            command = ["${pkgs.shellcheck}/bin/shellcheck" "--"];
            file_patterns = ["*.sh"];
          };
          shfmt = {
            title = "shfmt";
            homepage = pkgs.shfmt.meta.homepage;
            command = [
              "${pkgs.shfmt}/bin/shfmt"
              "--binary-next-line"
              "--case-indent"
              "--indent"
              "2"
              "--list"
              "--write"
              "--"
            ];
            file_patterns = ["*.sh"];
          };
          stylelint = {
            title = "Stylelint";
            homepage = pkgs.nodePackages.stylelint.meta.homepage;
            command = ["${pkgs.nodePackages.stylelint}/bin/stylelint" "--"];
            file_patterns = ["*.css"];
          };
          terraform = {
            title = "Terraform fmt";
            homepage = "https://developer.hashicorp.com/terraform/cli/commands/fmt";
            command = ["${pkgs.terraform}/bin/terraform" "fmt" "--"];
            file_patterns = ["*.tf"];
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
      in {
        apps.default = {
          program = "${package}/bin/travel-kit";
          type = "app";
        };
        packages.default = package;
      }
    );
}
