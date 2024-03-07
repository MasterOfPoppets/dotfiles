{
  inputs = {
    nixpkgs.follows = "nix-vscode-extensions/nixpkgs";
    flake-utils.follows = "nix-vscode-extensions/flake-utils";
    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
  };

  outputs = { self, nixpkgs, flake-utils, nix-vscode-extensions }:
    flake-utils.lib.eachDefaultSystem
      (system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
          extensions = nix-vscode-extensions.extensions.${system};
          inherit (pkgs) vscode-with-extensions vscodium;

          packages.default =
            vscode-with-extensions.override {
              vscode = vscodium;
              vscodeExtensions = [
                extensions.open-vsx-release.rust-lang.rust-analyzer
              ];
            };

          devShells.default = pkgs.mkShell {
            buildInputs = [ packages.default ];
            shellHook = ''
              printf "VSCodium with extensions:\n"
              codium --list-extensions
            '';
          };
        in
        {
          inherit packages devShells;
        });
}
