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
            alejandra = "${pkgs.lib.makeBinPath [pkgs.alejandra]}/alejandra";
          in {
            title = "Alejandra";
            homepage = pkgs.alejandra.meta.homepage;
            command = [alejandra "--"];
            file_patterns = ["*.nix"];
          };
          black = let
            black = "${pkgs.lib.makeBinPath [pkgs.black]}/black";
          in {
            title = "Black";
            homepage = pkgs.black.meta.homepage;
            command = [black "--"];
            file_patterns = ["*.py" "*.pyi"];
          };
          git = let
            git = "${pkgs.lib.makeBinPath [pkgs.git]}/git";
          in {
            title = "Git diff check";
            homepage = "https://git-scm.com/docs/git-diff#Documentation/git-diff.txt---check";
            command = [git "diff" "--check" "HEAD^" "--"];
            file_patterns = ["*"];
          };
          gitlint = let
            gitlint = "${pkgs.lib.makeBinPath [pkgs.gitlint]}/gitlint";
          in {
            title = "Gitlint";
            homepage = pkgs.gitlint.meta.homepage;
            command = [gitlint "--ignore" "body-is-missing"];
            file_patterns = [];
          };
          hadolint = let
            hadolint = "${pkgs.lib.makeBinPath [pkgs.hadolint]}/hadolint";
          in {
            title = "Haskell Dockerfile Linter";
            homepage = pkgs.hadolint.meta.homepage;
            command = [hadolint "--"];
            file_patterns = ["*.Dockerfile" "Dockerfile"];
          };
          html5validator = let
            html5validator = "${pkgs.lib.makeBinPath [pkgs.html5validator]}/html5validator";
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
            htmlhint = "${pkgs.lib.makeBinPath [pkgs.nodePackages.htmlhint]}/htmlhint";
          in {
            title = "HTMLHint";
            homepage = pkgs.nodePackages.htmlhint.meta.homepage;
            command = [htmlhint "--"];
            file_patterns = ["*.htm" "*.html"];
          };
          isort = let
            isort = "${pkgs.lib.makeBinPath [pkgs.isort]}/isort";
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
            jsonnetLint = "${pkgs.lib.makeBinPath [pkgs.go-jsonnet]}/jsonnet-lint";
          in {
            title = "Jsonnet linter";
            homepage = "https://jsonnet.org/learning/tools.html";
            command = [jsonnetLint "--"];
            file_patterns = ["*.jsonnet" "*.libsonnet"];
          };
          jsonnetfmt = let
            jsonnetfmt = "${pkgs.lib.makeBinPath [pkgs.go-jsonnet]}/jsonnetfmt";
          in {
            title = "Jsonnet formatter";
            homepage = "https://jsonnet.org/learning/tools.html";
            command = [jsonnetfmt "--in-place" "--"];
            file_patterns = ["*.jsonnet" "*.libsonnet"];
          };
          prettier = let
            prettier = "${pkgs.lib.makeBinPath [pkgs.nodePackages.prettier]}/prettier";
            options = [
              "--plugin"
              "${pkgs.lib.makeLibraryPath [pkgs.nodePackages.prettier-plugin-toml]}/node_modules/prettier-plugin-toml/lib/index.cjs"
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
            pylint = "${pkgs.lib.makeBinPath [pkgs.pylint]}/pylint";
          in {
            title = "Pylint";
            homepage = pkgs.pylint.meta.homepage;
            command = [pylint "--"];
            file_patterns = ["*.py"];
          };
          rufo = let
            rufo = "${pkgs.lib.makeBinPath [pkgs.rufo]}/rufo";
          in {
            title = "Rufo";
            homepage = pkgs.rufo.meta.homepage;
            command = [rufo "--"];
            file_patterns = ["*.rb" "Vagrantfile"];
          };
          shellcheck = let
            shellcheck = "${pkgs.lib.makeBinPath [pkgs.shellcheck]}/shellcheck";
          in {
            title = "ShellCheck";
            homepage = pkgs.shellcheck.meta.homepage;
            command = [shellcheck "--"];
            file_patterns = ["*.sh"];
          };
          shfmt = let
            shfmt = "${pkgs.lib.makeBinPath [pkgs.shfmt]}/shfmt";
            options = ["--binary-next-line" "--case-indent" "--indent" "2"];
          in {
            title = "shfmt";
            homepage = pkgs.shfmt.meta.homepage;
            command = [shfmt] ++ options ++ ["--list" "--write" "--"];
            file_patterns = ["*.sh"];
          };
          stylelint = let
            stylelint = "${pkgs.lib.makeBinPath [pkgs.nodePackages.stylelint]}/stylelint";
          in {
            title = "Stylelint";
            homepage = pkgs.nodePackages.stylelint.meta.homepage;
            command = [stylelint "--"];
            file_patterns = ["*.css"];
          };
          terraform = let
            terraform = "${pkgs.lib.makeBinPath [pkgs.terraform]}/terraform";
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
