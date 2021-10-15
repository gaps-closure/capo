import logging
from pathlib import Path
import unittest
import tempfile
import sys
from conflict_analyzer import conflict_analyzer

pdg_lib = Path('/opt/closure/lib/libpdg.so') 
constraints_def = Path('/opt/closure/scripts/constraints/conflict_analyzer_constraints.mzn') 
decls_def = Path('/opt/closure/scripts/constraints/conflict_variable_declarations.mzn')
sdir = Path('conflict_analyzer/tests')
tdir = Path(tempfile.mkdtemp())
logger = logging.getLogger()
handler = logging.FileHandler('/dev/null')
logger.addHandler(handler)

class End2EndTests(unittest.TestCase):
    def test_example1(self):
        out = conflict_analyzer.start(conflict_analyzer.Args(
            sources=[sdir / 'example1.c'], 
            temp_dir=tdir, clang_args="", 
            schema=None, 
            pdg_lib=pdg_lib,
            constraint_files=[constraints_def, decls_def],
            log_level="ERROR" 
        ), logger)
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
        ), logger)
        self.assertEqual(out["result"], 'Success')

    def test_example3(self):
        out = conflict_analyzer.start(conflict_analyzer.Args(
            sources=[sdir / 'example2.c'], 
            temp_dir=tdir, clang_args="", 
            schema=None, 
            pdg_lib=pdg_lib,
            constraint_files=[constraints_def, decls_def],
            log_level="ERROR" 
        ), logger)
        self.assertEqual(out["result"], 'Success')

    def test_array_1(self):
        out = conflict_analyzer.start(conflict_analyzer.Args(
                sources=[sdir / 'array_1.c'], 
                temp_dir=tdir, clang_args="", 
                schema=None, 
                pdg_lib=pdg_lib,
                constraint_files=[constraints_def, decls_def],
                log_level="ERROR" 
        ), logger)
        self.assertEqual(out["result"], 'Success')

    def test_argument_mismatch(self):
        try: 
            conflict_analyzer.start(conflict_analyzer.Args(
                sources=[sdir / 'argument_mismatch.c'], 
                temp_dir=tdir, clang_args="", 
                schema=None, 
                pdg_lib=pdg_lib,
                constraint_files=[constraints_def, decls_def],
                log_level="ERROR" 
            ), logger)
        except:
            self.assertTrue(True)
            return

        self.assertTrue(False, "should throw exception")

    def test_empty_arg_taints(self):
        out = conflict_analyzer.start(conflict_analyzer.Args(
                sources=[sdir / 'empty_arg_taints.c'], 
                temp_dir=tdir, clang_args="", 
                schema=None, 
                pdg_lib=pdg_lib,
                constraint_files=[constraints_def, decls_def],
                log_level="ERROR" 
        ), logger)
        self.assertEqual(out["result"], 'Conflict')

    def test_example2_error(self):
        out = conflict_analyzer.start(conflict_analyzer.Args(
                sources=[sdir / 'example2_error.c'], 
                temp_dir=tdir, clang_args="", 
                schema=None, 
                pdg_lib=pdg_lib,
                constraint_files=[constraints_def, decls_def],
                log_level="ERROR" 
        ), logger)
        self.assertEqual(out["result"], 'Conflict')
    
    def test_global_variable_level_mismatch(self):
        out = conflict_analyzer.start(conflict_analyzer.Args(
                sources=[sdir / 'global_variable_level_mismatch.c'], 
                temp_dir=tdir, clang_args="", 
                schema=None, 
                pdg_lib=pdg_lib,
                constraint_files=[constraints_def, decls_def],
                log_level="ERROR" 
        ), logger)
        self.assertEqual(out["result"], 'Conflict')

    def test_label_duplicate(self):
        try:
            conflict_analyzer.start(conflict_analyzer.Args(
                    sources=[sdir / 'label_duplicate.c'], 
                    temp_dir=tdir, clang_args="", 
                    schema=None, 
                    pdg_lib=pdg_lib,
                    constraint_files=[constraints_def, decls_def],
                    log_level="ERROR" 
            ), logger)
        except:
            self.assertTrue(True)
            return
       
        self.assertTrue(False, "should throw exception")

    def test_missing_cdf(self):
        out = conflict_analyzer.start(conflict_analyzer.Args(
                sources=[sdir / 'missing_cdf.c'], 
                temp_dir=tdir, clang_args="", 
                schema=None, 
                pdg_lib=pdg_lib,
                constraint_files=[constraints_def, decls_def],
                log_level="ERROR" 
        ), logger)
        self.assertEqual(out["result"], 'Conflict')

    def test_missing_taints_def(self):
        try:
            conflict_analyzer.start(conflict_analyzer.Args(
                    sources=[sdir / 'missing_taints_def.c'], 
                    temp_dir=tdir, clang_args="", 
                    schema=None, 
                    pdg_lib=pdg_lib,
                    constraint_files=[constraints_def, decls_def],
                    log_level="ERROR" 
            ), logger)
        except:
            self.assertTrue(True)
            return
       
        self.assertTrue(False, "should throw exception")

    def test_multiple_levels_fun(self):
        out = conflict_analyzer.start(conflict_analyzer.Args(
                sources=[sdir / 'multiple_levels_fun.c'], 
                temp_dir=tdir, clang_args="", 
                schema=None, 
                pdg_lib=pdg_lib,
                constraint_files=[constraints_def, decls_def],
                log_level="ERROR" 
        ), logger)
        self.assertEqual(out["result"], 'Conflict')

    def test_multiple_taints_1(self):
        out = conflict_analyzer.start(conflict_analyzer.Args(
                sources=[sdir / 'multiple_taints_1.c'], 
                temp_dir=tdir, clang_args="", 
                schema=None, 
                pdg_lib=pdg_lib,
                constraint_files=[constraints_def, decls_def],
                log_level="ERROR" 
        ), logger)
        self.assertEqual(out["result"], 'Conflict')
    
    def test_multiple_taints_2(self):
        out = conflict_analyzer.start(conflict_analyzer.Args(
                sources=[sdir / 'multiple_taints_2.c'], 
                temp_dir=tdir, clang_args="", 
                schema=None, 
                pdg_lib=pdg_lib,
                constraint_files=[constraints_def, decls_def],
                log_level="ERROR" 
        ), logger)
        self.assertEqual(out["result"], 'Conflict')

    def test_multiple_taints_3(self):
        out = conflict_analyzer.start(conflict_analyzer.Args(
                sources=[sdir / 'multiple_taints_3.c'], 
                temp_dir=tdir, clang_args="", 
                schema=None, 
                pdg_lib=pdg_lib,
                constraint_files=[constraints_def, decls_def],
                log_level="ERROR" 
        ), logger)
        self.assertEqual(out["result"], 'Conflict')

    def test_taint_conflict(self):
        out = conflict_analyzer.start(conflict_analyzer.Args(
                sources=[sdir / 'taint_conflict.c'], 
                temp_dir=tdir, clang_args="", 
                schema=None, 
                pdg_lib=pdg_lib,
                constraint_files=[constraints_def, decls_def],
                log_level="ERROR" 
        ), logger)
        self.assertEqual(out["result"], 'Conflict')

    def test_unannotated_cut(self):
        out = conflict_analyzer.start(conflict_analyzer.Args(
                sources=[sdir / 'unannotated_cut.c'], 
                temp_dir=tdir, clang_args="", 
                schema=None, 
                pdg_lib=pdg_lib,
                constraint_files=[constraints_def, decls_def],
                log_level="ERROR" 
        ), logger)
        self.assertEqual(out["result"], 'Conflict')








if __name__ == '__main__':
    unittest.main()