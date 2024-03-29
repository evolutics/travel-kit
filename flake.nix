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
              is_only_active_if_command = [];
              file_pattern = "\\.nix$";
              check = alejandra ++ ["--check" "--"];
              fix = alejandra ++ ["--"];
            };
            black = let
              black = [(pkgs.lib.makeBinPath [pkgs.black]) "black"];
            in {
              title = "Black";
              homepage = pkgs.black.meta.homepage;
              is_only_active_if_command = [];
              file_pattern = "\\.(py|pyi)$";
              check = black ++ ["--check" "--diff" "--"];
              fix = black ++ ["--"];
            };
            git = {
              title = "Git diff check";
              homepage = "https://git-scm.com/docs/git-diff#Documentation/git-diff.txt---check";
              is_only_active_if_command = git ++ ["rev-parse"];
              file_pattern = "";
              check = git ++ ["diff" "--check" "HEAD^" "--"];
              fix = [];
            };
            gitlint = let
              gitlint = [(pkgs.lib.makeBinPath [pkgs.gitlint]) "gitlint"];
            in {
              title = "Gitlint";
              homepage = pkgs.gitlint.meta.homepage;
              is_only_active_if_command = git ++ ["rev-parse"];
              file_pattern = null;
              check = gitlint ++ ["--ignore" "body-is-missing"];
              fix = [];
            };
            hadolint = let
              hadolint = [(pkgs.lib.makeBinPath [pkgs.hadolint]) "hadolint"];
            in {
              title = "Haskell Dockerfile Linter";
              homepage = pkgs.hadolint.meta.homepage;
              is_only_active_if_command = [];
              file_pattern = "(^|[./])Dockerfile$";
              check = hadolint ++ ["--"];
              fix = [];
            };
            html5validator = let
              html5validator = [(pkgs.lib.makeBinPath [pkgs.html5validator]) "html5validator"];
            in {
              title = "HTML5 Validator";
              homepage = pkgs.html5validator.meta.homepage;
              is_only_active_if_command = [];
              file_pattern = "\\.(css|htm|html|svg|xht|xhtml)$";
              check =
                html5validator
                ++ ["--also-check-css" "--also-check-svg" "--Werror" "--"];
              fix = [];
            };
            htmlhint = let
              htmlhint = [(pkgs.lib.makeBinPath [pkgs.nodePackages.htmlhint]) "htmlhint"];
            in {
              title = "HTMLHint";
              homepage = pkgs.nodePackages.htmlhint.meta.homepage;
              is_only_active_if_command = [];
              file_pattern = "\\.(htm|html)$";
              check = htmlhint ++ ["--"];
              fix = [];
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
              is_only_active_if_command = [];
              file_pattern = "\\.(py|pyi)$";
              check = isort ++ options ++ ["--check" "--diff" "--"];
              fix = isort ++ options ++ ["--"];
            };
            jsonnet-lint = let
              jsonnetLint = [(pkgs.lib.makeBinPath [pkgs.go-jsonnet]) "jsonnet-lint"];
            in {
              title = "Jsonnet linter";
              homepage = "https://jsonnet.org/learning/tools.html";
              is_only_active_if_command = [];
              file_pattern = "\\.(jsonnet|libsonnet)$";
              check = jsonnetLint ++ ["--"];
              fix = [];
            };
            jsonnetfmt = let
              jsonnetfmt = [(pkgs.lib.makeBinPath [pkgs.go-jsonnet]) "jsonnetfmt"];
            in {
              title = "Jsonnet formatter";
              homepage = "https://jsonnet.org/learning/tools.html";
              is_only_active_if_command = [];
              file_pattern = "\\.(jsonnet|libsonnet)$";
              check = jsonnetfmt ++ ["--test" "--"];
              fix = jsonnetfmt ++ ["--in-place" "--"];
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
              is_only_active_if_command = [];
              file_pattern = "\\.(css|htm|html|js|json|md|toml|ts|xht|xhtml|xml|yaml|yml)$";
              check = prettier ++ options ++ ["--check" "--"];
              fix = prettier ++ options ++ ["--write" "--"];
            };
            pylint = let
              pylint = [(pkgs.lib.makeBinPath [pkgs.pylint]) "pylint"];
            in {
              title = "Pylint";
              homepage = pkgs.pylint.meta.homepage;
              is_only_active_if_command = [];
              file_pattern = "\\.py$";
              check = pylint ++ ["--"];
              fix = [];
            };
            rufo = let
              rufo = [(pkgs.lib.makeBinPath [pkgs.rufo]) "rufo"];
            in {
              title = "Rufo";
              homepage = pkgs.rufo.meta.homepage;
              is_only_active_if_command = [];
              file_pattern = "(\\.rb|(^|/)Vagrantfile)$";
              check = rufo ++ ["--check" "--"];
              fix = rufo ++ ["--"];
            };
            shellcheck = let
              shellcheck = [(pkgs.lib.makeBinPath [pkgs.shellcheck]) "shellcheck"];
            in {
              title = "ShellCheck";
              homepage = pkgs.shellcheck.meta.homepage;
              is_only_active_if_command = [];
              file_pattern = "\\.sh$";
              check = shellcheck ++ ["--"];
              fix = [];
            };
            shfmt = let
              shfmt = [(pkgs.lib.makeBinPath [pkgs.shfmt]) "shfmt"];
              options = ["--binary-next-line" "--case-indent" "--indent" "2"];
            in {
              title = "shfmt";
              homepage = pkgs.shfmt.meta.homepage;
              is_only_active_if_command = [];
              file_pattern = "\\.sh$";
              check = shfmt ++ options ++ ["--diff" "--"];
              fix = shfmt ++ options ++ ["--list" "--simplify" "--write" "--"];
            };
            stylelint = let
              stylelint = [(pkgs.lib.makeBinPath [pkgs.nodePackages.stylelint]) "stylelint"];
            in {
              title = "Stylelint";
              homepage = pkgs.nodePackages.stylelint.meta.homepage;
              is_only_active_if_command = [];
              file_pattern = "\\.css$";
              check = stylelint ++ ["--"];
              fix = [];
            };
            terraform = let
              terraform = [(pkgs.lib.makeBinPath [pkgs.terraform]) "terraform"];
            in {
              title = "Terraform fmt";
              homepage = "https://developer.hashicorp.com/terraform/cli/commands/fmt";
              is_only_active_if_command = [];
              file_pattern = "\\.tf$";
              check = terraform ++ ["fmt" "-check" "-diff" "--"];
              fix = terraform ++ ["fmt" "--"];
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
