{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    systems.url = "github:nix-systems/default";
    # Hugo 0.116.1
    nixpkgsHugo.url = "github:NixOS/nixpkgs/d937df65cadb80769e30b272d7b66eb7aa9f0b9c";
  };

  outputs =
    {
      nixpkgs,
      systems,
      nixpkgsHugo,
      ...
    }:
    let
      forEachSystem =
        f:
        nixpkgs.lib.genAttrs (import systems) (
          system:
          f {
            pkgs = import nixpkgs {
              inherit system;
            };
            pkgsHugo = import nixpkgsHugo {
              inherit system;
            };
          }
        );
    in
    {
      devShells = forEachSystem (
        { pkgs, pkgsHugo }:
        {
          default = pkgs.mkShell {
            packages = with pkgs; [
              pkgsHugo.hugo
            ];
          };
        }
      );
    };
}
