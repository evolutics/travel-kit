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
          black = [(pkgs.lib.makeBinPath [pkgs.black]) "black"];
          git = [(pkgs.lib.makeBinPath [pkgs.git]) "git"];
          gitlint = [(pkgs.lib.makeBinPath [pkgs.gitlint]) "gitlint"];
          hadolint = [(pkgs.lib.makeBinPath [pkgs.hadolint]) "hadolint"];
          html5validator = [(pkgs.lib.makeBinPath [pkgs.html5validator]) "html5validator"];
          htmlhint = [(pkgs.lib.makeBinPath [pkgs.nodePackages.htmlhint]) "htmlhint"];
          prettier = [(pkgs.lib.makeBinPath [pkgs.nodePackages.prettier]) "prettier"];
          pylint = [(pkgs.lib.makeBinPath [pkgs.pylint]) "pylint"];
          shellcheck = [(pkgs.lib.makeBinPath [pkgs.shellcheck]) "shellcheck"];
          shfmt = [(pkgs.lib.makeBinPath [pkgs.shfmt]) "shfmt"];
          stylelint = [(pkgs.lib.makeBinPath [pkgs.nodePackages.stylelint]) "stylelint"];
        in
          builtins.toJSON {
            black = {
              title = "Black";
              is_only_active_if_command = [];
              file_pattern = "\\.(py|pyi)$";
              check = black ++ ["--check" "--diff" "--"];
              fix = black ++ ["--"];
            };
            git = {
              title = "Git";
              is_only_active_if_command = git ++ ["rev-parse"];
              file_pattern = "";
              check = git ++ ["diff" "--check" "HEAD^" "--"];
              fix = [];
            };
            gitlint = {
              title = "Gitlint";
              is_only_active_if_command = git ++ ["rev-parse"];
              file_pattern = null;
              check = gitlint ++ ["--ignore" "body-is-missing"];
              fix = [];
            };
            hadolint = {
              title = "Haskell Dockerfile Linter";
              is_only_active_if_command = [];
              file_pattern = "(^|[./])Dockerfile$";
              check = hadolint ++ ["--"];
              fix = [];
            };
            html5validator = {
              title = "HTML5 Validator";
              is_only_active_if_command = [];
              file_pattern = "\\.(css|htm|html|svg|xht|xhtml)$";
              check = html5validator ++ ["--also-check-css" "--also-check-svg" "--Werror" "--"];
              fix = [];
            };
            htmlhint = {
              title = "HTMLHint";
              is_only_active_if_command = [];
              file_pattern = "\\.(htm|html)$";
              check = htmlhint ++ ["--"];
              fix = [];
            };
            prettier = {
              title = "Prettier";
              is_only_active_if_command = [];
              file_pattern = "\\.(css|htm|html|js|json|md|toml|ts|xht|xhtml|xml|yaml|yml)$";
              check =
                prettier
                ++ [
                  "--check"
                  "--plugin-search-dir"
                  "${pkgs.lib.makeLibraryPath [pkgs.nodePackages.prettier-plugin-toml]}"
                  "--"
                ];
              fix =
                prettier
                ++ [
                  "--plugin-search-dir"
                  "${pkgs.lib.makeLibraryPath [pkgs.nodePackages.prettier-plugin-toml]}"
                  "--write"
                  "--"
                ];
            };
            pylint = {
              title = "Pylint";
              is_only_active_if_command = [];
              file_pattern = "\\.py$";
              check = pylint;
              fix = [];
            };
            shellcheck = {
              title = "ShellCheck";
              is_only_active_if_command = [];
              file_pattern = "\\.sh$";
              check = shellcheck ++ ["--"];
              fix = [];
            };
            shfmt = {
              title = "shfmt";
              is_only_active_if_command = [];
              file_pattern = "\\.sh$";
              check = shfmt ++ ["-bn" "-ci" "-d" "-i" "2" "--"];
              fix = shfmt ++ ["-bn" "-ci" "-i" "2" "-l" "-s" "-w" "--"];
            };
            stylelint = {
              title = "stylelint";
              is_only_active_if_command = [];
              file_pattern = "\\.css$";
              check = stylelint ++ ["--"];
              fix = [];
            };
          };
        pkgs = nixpkgs.legacyPackages.${system};
      in {
        defaultApp = pkgs.python3Packages.buildPythonApplication {
          name = "travel-kit";
          preBuild = ''
            cat >travelkit/cleaners.json <<'EOF'
            ${cleaners}
            EOF
          '';
          src = ./.;
        };
      }
    );
}