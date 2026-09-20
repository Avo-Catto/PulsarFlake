{
  description = "A plugin and mod loader for Space Engineers.";

  inputs = {
    nixpkgs.url = "https://channels.nixos.org/nixpkgs-unstable/nixexprs.tar.zst";
  };

  outputs = { self, nixpkgs, ... }: 
  let 
    system = "x86_64-linux";
    pkgs = import nixpkgs { inherit system; };
  in 
  {
    packages = builtins.mapAttrs (system: pkgs: {
      pulsar = pkgs.callPackage (import ./pulsar.nix) {};
      ipulsar = pkgs.callPackage (import ./ipulsar.nix) { pulsar = self.packages.${system}.pulsar; };

      default = self.packages.${system}.ipulsar;
    }) nixpkgs.legacyPackages;

    apps.${pkgs.stdenv.hostPlatform.system}.install = {
        type = "app";
        program = "${self.packages.${system}.ipulsar}/bin/ipulsar";
        meta.description = "Install Pulsar to the current working directory.";
    };
  };
}
