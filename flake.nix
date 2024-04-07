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
          alejandra = let
            alejandra = "${pkgs.alejandra}/bin/alejandra";
          in {
            title = "Alejandra";
            homepage = pkgs.alejandra.meta.homepage;
            command = [alejandra "--"];
            file_patterns = ["*.nix"];
          };
          black = let
            black = "${pkgs.black}/bin/black";
          in {
            title = "Black";
            homepage = pkgs.black.meta.homepage;
            command = [black "--"];
            file_patterns = ["*.py" "*.pyi"];
          };
          git = let
            git = "${pkgs.git}/bin/git";
          in {
            title = "Git diff check";
            homepage = "https://git-scm.com/docs/git-diff#Documentation/git-diff.txt---check";
            command = [git "diff" "--check" "HEAD^" "--"];
            file_patterns = ["*"];
          };
          gitlint = let
            gitlint = "${pkgs.gitlint}/bin/gitlint";
          in {
            title = "Gitlint";
            homepage = pkgs.gitlint.meta.homepage;
            command = [gitlint "--ignore" "body-is-missing"];
            file_patterns = [];
          };
          hadolint = let
            hadolint = "${pkgs.hadolint}/bin/hadolint";
          in {
            title = "Haskell Dockerfile Linter";
            homepage = pkgs.hadolint.meta.homepage;
            command = [hadolint "--"];
            file_patterns = ["*.Dockerfile" "Dockerfile"];
          };
          html5validator = let
            html5validator = "${pkgs.html5validator}/bin/html5validator";
          in {
            title = "HTML5 Validator";
            homepage = pkgs.html5validator.meta.homepage;
            command = [
              html5validator
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
          htmlhint = let
            htmlhint = "${pkgs.nodePackages.htmlhint}/bin/htmlhint";
          in {
            title = "HTMLHint";
            homepage = pkgs.nodePackages.htmlhint.meta.homepage;
            command = [htmlhint "--"];
            file_patterns = ["*.htm" "*.html"];
          };
          isort = let
            isort = "${pkgs.isort}/bin/isort";
            options = [
              "--force-single-line-imports"
              "--from-first"
              "--profile"
              "black"
            ];
          in {
            title = "isort";
            homepage = pkgs.isort.meta.homepage;
            command = [isort] ++ options ++ ["--"];
            file_patterns = ["*.py" "*.pyi"];
          };
          jsonnet-lint = let
            jsonnetLint = "${pkgs.go-jsonnet}/bin/jsonnet-lint";
          in {
            title = "Jsonnet linter";
            homepage = "https://jsonnet.org/learning/tools.html";
            command = [jsonnetLint "--"];
            file_patterns = ["*.jsonnet" "*.libsonnet"];
          };
          jsonnetfmt = let
            jsonnetfmt = "${pkgs.go-jsonnet}/bin/jsonnetfmt";
          in {
            title = "Jsonnet formatter";
            homepage = "https://jsonnet.org/learning/tools.html";
            command = [jsonnetfmt "--in-place" "--"];
            file_patterns = ["*.jsonnet" "*.libsonnet"];
          };
          prettier = let
            prettier = "${pkgs.nodePackages.prettier}/bin/prettier";
            options = [
              "--plugin"
              "${pkgs.nodePackages.prettier-plugin-toml}/lib/node_modules/prettier-plugin-toml/lib/index.cjs"
            ];
          in {
            title = "Prettier";
            homepage = pkgs.nodePackages.prettier.meta.homepage;
            command = [prettier] ++ options ++ ["--write" "--"];
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
          pylint = let
            pylint = "${pkgs.pylint}/bin/pylint";
          in {
            title = "Pylint";
            homepage = pkgs.pylint.meta.homepage;
            command = [pylint "--"];
            file_patterns = ["*.py"];
          };
          rufo = let
            rufo = "${pkgs.rufo}/bin/rufo";
          in {
            title = "Rufo";
            homepage = pkgs.rufo.meta.homepage;
            command = [rufo "--"];
            file_patterns = ["*.rb" "Vagrantfile"];
          };
          shellcheck = let
            shellcheck = "${pkgs.shellcheck}/bin/shellcheck";
          in {
            title = "ShellCheck";
            homepage = pkgs.shellcheck.meta.homepage;
            command = [shellcheck "--"];
            file_patterns = ["*.sh"];
          };
          shfmt = let
            shfmt = "${pkgs.shfmt}/bin/shfmt";
            options = ["--binary-next-line" "--case-indent" "--indent" "2"];
          in {
            title = "shfmt";
            homepage = pkgs.shfmt.meta.homepage;
            command = [shfmt] ++ options ++ ["--list" "--write" "--"];
            file_patterns = ["*.sh"];
          };
          stylelint = let
            stylelint = "${pkgs.nodePackages.stylelint}/bin/stylelint";
          in {
            title = "Stylelint";
            homepage = pkgs.nodePackages.stylelint.meta.homepage;
            command = [stylelint "--"];
            file_patterns = ["*.css"];
          };
          terraform = let
            terraform = "${pkgs.terraform}/bin/terraform";
          in {
            title = "Terraform fmt";
            homepage = "https://developer.hashicorp.com/terraform/cli/commands/fmt";
            command = [terraform "fmt" "--"];
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
