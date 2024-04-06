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
        cleaners = let
          git = [(pkgs.lib.makeBinPath [pkgs.git]) "git"];
        in
          builtins.toJSON {
            alejandra = let
              alejandra = [(pkgs.lib.makeBinPath [pkgs.alejandra]) "alejandra"];
            in {
              title = "Alejandra";
              homepage = pkgs.alejandra.meta.homepage;
              file_patterns = ["*.nix"];
              command = alejandra ++ ["--"];
            };
            black = let
              black = [(pkgs.lib.makeBinPath [pkgs.black]) "black"];
            in {
              title = "Black";
              homepage = pkgs.black.meta.homepage;
              file_patterns = ["*.py" "*.pyi"];
              command = black ++ ["--"];
            };
            git = {
              title = "Git diff check";
              homepage = "https://git-scm.com/docs/git-diff#Documentation/git-diff.txt---check";
              file_patterns = ["*"];
              command = git ++ ["diff" "--check" "HEAD^" "--"];
            };
            gitlint = let
              gitlint = [(pkgs.lib.makeBinPath [pkgs.gitlint]) "gitlint"];
            in {
              title = "Gitlint";
              homepage = pkgs.gitlint.meta.homepage;
              file_patterns = [];
              command = gitlint ++ ["--ignore" "body-is-missing"];
            };
            hadolint = let
              hadolint = [(pkgs.lib.makeBinPath [pkgs.hadolint]) "hadolint"];
            in {
              title = "Haskell Dockerfile Linter";
              homepage = pkgs.hadolint.meta.homepage;
              file_patterns = ["*.Dockerfile" "Dockerfile"];
              command = hadolint ++ ["--"];
            };
            html5validator = let
              html5validator = [(pkgs.lib.makeBinPath [pkgs.html5validator]) "html5validator"];
            in {
              title = "HTML5 Validator";
              homepage = pkgs.html5validator.meta.homepage;
              file_patterns = [
                "*.css"
                "*.htm"
                "*.html"
                "*.svg"
                "*.xht"
                "*.xhtml"
              ];
              command =
                html5validator
                ++ ["--also-check-css" "--also-check-svg" "--Werror" "--"];
            };
            htmlhint = let
              htmlhint = [(pkgs.lib.makeBinPath [pkgs.nodePackages.htmlhint]) "htmlhint"];
            in {
              title = "HTMLHint";
              homepage = pkgs.nodePackages.htmlhint.meta.homepage;
              file_patterns = ["*.htm" "*.html"];
              command = htmlhint ++ ["--"];
            };
            isort = let
              isort = [(pkgs.lib.makeBinPath [pkgs.isort]) "isort"];
              options = [
                "--force-single-line-imports"
                "--from-first"
                "--profile"
                "black"
              ];
            in {
              title = "isort";
              homepage = pkgs.isort.meta.homepage;
              file_patterns = ["*.py" "*.pyi"];
              command = isort ++ options ++ ["--"];
            };
            jsonnet-lint = let
              jsonnetLint = [(pkgs.lib.makeBinPath [pkgs.go-jsonnet]) "jsonnet-lint"];
            in {
              title = "Jsonnet linter";
              homepage = "https://jsonnet.org/learning/tools.html";
              file_patterns = ["*.jsonnet" "*.libsonnet"];
              command = jsonnetLint ++ ["--"];
            };
            jsonnetfmt = let
              jsonnetfmt = [(pkgs.lib.makeBinPath [pkgs.go-jsonnet]) "jsonnetfmt"];
            in {
              title = "Jsonnet formatter";
              homepage = "https://jsonnet.org/learning/tools.html";
              file_patterns = ["*.jsonnet" "*.libsonnet"];
              command = jsonnetfmt ++ ["--in-place" "--"];
            };
            prettier = let
              prettier = [(pkgs.lib.makeBinPath [pkgs.nodePackages.prettier]) "prettier"];
              options = [
                "--plugin"
                "${pkgs.lib.makeLibraryPath [pkgs.nodePackages.prettier-plugin-toml]}/node_modules/prettier-plugin-toml/lib/index.cjs"
              ];
            in {
              title = "Prettier";
              homepage = pkgs.nodePackages.prettier.meta.homepage;
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
              command = prettier ++ options ++ ["--write" "--"];
            };
            pylint = let
              pylint = [(pkgs.lib.makeBinPath [pkgs.pylint]) "pylint"];
            in {
              title = "Pylint";
              homepage = pkgs.pylint.meta.homepage;
              file_patterns = ["*.py"];
              command = pylint ++ ["--"];
            };
            rufo = let
              rufo = [(pkgs.lib.makeBinPath [pkgs.rufo]) "rufo"];
            in {
              title = "Rufo";
              homepage = pkgs.rufo.meta.homepage;
              file_patterns = ["*.rb" "Vagrantfile"];
              command = rufo ++ ["--"];
            };
            shellcheck = let
              shellcheck = [(pkgs.lib.makeBinPath [pkgs.shellcheck]) "shellcheck"];
            in {
              title = "ShellCheck";
              homepage = pkgs.shellcheck.meta.homepage;
              file_patterns = ["*.sh"];
              command = shellcheck ++ ["--"];
            };
            shfmt = let
              shfmt = [(pkgs.lib.makeBinPath [pkgs.shfmt]) "shfmt"];
              options = ["--binary-next-line" "--case-indent" "--indent" "2"];
            in {
              title = "shfmt";
              homepage = pkgs.shfmt.meta.homepage;
              file_patterns = ["*.sh"];
              command = shfmt ++ options ++ ["--list" "--write" "--"];
            };
            stylelint = let
              stylelint = [(pkgs.lib.makeBinPath [pkgs.nodePackages.stylelint]) "stylelint"];
            in {
              title = "Stylelint";
              homepage = pkgs.nodePackages.stylelint.meta.homepage;
              file_patterns = ["*.css"];
              command = stylelint ++ ["--"];
            };
            terraform = let
              terraform = [(pkgs.lib.makeBinPath [pkgs.terraform]) "terraform"];
            in {
              title = "Terraform fmt";
              homepage = "https://developer.hashicorp.com/terraform/cli/commands/fmt";
              file_patterns = ["*.tf"];
              command = terraform ++ ["fmt" "--"];
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
