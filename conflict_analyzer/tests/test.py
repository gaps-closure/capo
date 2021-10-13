from pathlib import Path
import unittest
import tempfile
from conflict_analyzer import conflict_analyzer

pdg_lib = Path('/opt/closure/lib/libpdg.so') 
constraints_def = Path('/opt/closure/scripts/constraints/conflict_analyzer_constraints.mzn') 
decls_def = Path('/opt/closure/scripts/constraints/conflict_variable_declarations.mzn')
sdir = Path('conflict_analyzer/tests')
tdir = Path(tempfile.mkdtemp())

class End2EndTests(unittest.TestCase):
    def test_example1(self):
        out = conflict_analyzer.start(conflict_analyzer.Args(
            sources=[sdir / 'example1.c'], 
            temp_dir=tdir, clang_args="", 
            schema=None, 
            pdg_lib=pdg_lib,
            constraint_files=[constraints_def, decls_def],
            log_level="ERROR" 
        ))
        self.assertEqual(out["result"], 'Success')
        self.assertEqual([ fn["level"] for fn in out["topology"]["functions"] if fn["name"] == "get_a" ][0], 'orange_E')

    def test_example2(self):
        out = conflict_analyzer.start(conflict_analyzer.Args(
            sources=[sdir / 'example2.c'], 
            temp_dir=tdir, clang_args="", 
            schema=None, 
            pdg_lib=pdg_lib,
            constraint_files=[constraints_def, decls_def],
            log_level="ERROR" 
        ))
        self.assertEqual(out["result"], 'Success')

    def test_example3(self):
        out = conflict_analyzer.start(conflict_analyzer.Args(
            sources=[sdir / 'example2.c'], 
            temp_dir=tdir, clang_args="", 
            schema=None, 
            pdg_lib=pdg_lib,
            constraint_files=[constraints_def, decls_def],
            log_level="ERROR" 
        ))
        self.assertEqual(out["result"], 'Success')

        




if __name__ == '__main__':
    unittest.main()