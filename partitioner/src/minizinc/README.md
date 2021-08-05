Initial sketch of Phase 2 CLOSURE conflict analyzer based on minizinc constraint solver 

To test, use for example:
  time minizinc --solver Gecode *.mzn ./testdata/20210804-rkmods/*.mzn

Ideally each future testdata sub-directory should contain:
 1. The generated enclave_instance.mzn, cle_instance.mzn, and pdg_instance.mzn files
 2. The generated debug CSV file
 3. The input annotated C source and the LLVM IR and CLE-JSON derived from it 
 4. An explanation of the test case including any conflicts/errors introduced, and expected result and diagnostics 
 5. Test results using available version of the solver (document the git commit tag)

