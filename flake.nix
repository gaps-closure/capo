{
    description = "Compiler and Partitioner Optimizer";

    # Nixpkgs / NixOS version to use.
    inputs.nixpkgs.url = "nixpkgs";

    # Flake utils
    inputs.flake-utils.url = "github:numtide/flake-utils";

    inputs.pdg.url = "path:C/pdg2"; 

    outputs = { self, nixpkgs, flake-utils, pdg }:
        flake-utils.lib.eachDefaultSystem
        (system:
            let pkgs = nixpkgs.legacyPackages.${system}; 
                version = "3.0.0";
                # pdg = with pkgs; stdenv.mkDerivation {
                #     pname = "pdg";
                #     inherit version;
                #     src = ./C/pdg2;
                #     buildInputs = [ cmake llvmPackages_14.llvm ]; 
                # };
                svf = with pkgs; stdenv.mkDerivation {
                    pname = "svf";
                    inherit version;
                    src = ./svf;
                    buildInputs = [ cmake llvmPackages_14.llvm z3 ];
                    buildPhase = "./build.sh";
                    installPhase = ''
                        cp -r Release-build $out/
                    '';
                };
                capoPython = with pkgs; python3Packages.buildPythonPackage {
                    pname = "capo";
                    inherit version;
                    src = ./C;
                    doCheck = false;
                    propagatedBuildInputs = with python3Packages; [ lark jsonschema pyzmq minizinc ];
                };
            in
            {
                packages = {
                    default = svf;
                };
                # devShells = {
                #     default = with pkgs; pkgs.mkShell {
                #         packages = [ capoPython pdg svf llvmPackages_14.llvm clang_14 ];
                #         shellHook = ''
                #             export PDG=${pdg.out};
                #             export SVF=${svf.out};
                #             export CAPO=${capoPython.out};
                #         '';
                #     };
                # };
            }
        );
}