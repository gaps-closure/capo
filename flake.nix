{
    description = "Compiler and Partitioner Optimizer";

    # Nixpkgs / NixOS version to use.
    inputs.nixpkgs.url = "nixpkgs";

    # Flake utils
    inputs.flake-utils.url = "github:numtide/flake-utils";

    # PDG2
    inputs.pdg2.url = "path:C/pdg2";

    outputs = { self, nixpkgs, flake-utils, pdg2 }:
        flake-utils.lib.eachDefaultSystem
        (system:
            let pkgs = nixpkgs.legacyPackages.${system}; 
                pdgPkgs = pdg2.packages.${system};
                version = "3.0.0";
                capoPython = with pkgs; python3Packages.buildPythonPackage {
                    pname = "capo";
                    inherit version;
                    src = ./C;
                    doCheck = false;
                    propagatedBuildInputs = with python3Packages; [ lark jsonschema pyzmq ];
                };
            in
            {
                packages = {
                    default = capoPython;
                };
                devShells = {
                    default = with pkgs; pkgs.mkShell {
                        packages = [ capoPython pdgPkgs.default llvmPackages_14.llvm clang_14 ];
                        shellHook = ''
                            export PDG=${pdgPkgs.default.out};
                            export CAPO=${capoPython.out};
                        '';
                    };
                };
            }
        );
}