from distutils.core import setup, Extension
from distutils.cmd import Command
from distutils.command.build_py import build_py
from setuptools.command.install import install
from setuptools.command.install_lib import install_lib # type: ignore
from pathlib import Path
import os
import subprocess

def package_files(directory):
    paths = []
    for (path, directories, filenames) in os.walk(directory):
        for filename in filenames:
            paths.append(os.path.join(path, filename))
    return paths

class InstallGEDL(install_lib):
    def run(self):
        self.copy_file('gedl/build/libgedl.so', self.install_dir)

class InstallPDG(install_lib):
    def run(self):
        self.copy_file('pdg2/build/libpdg.so', self.install_dir)

class Install(install):
    def run(self):
        super().run()
        self.run_command('install_gedl')
        self.run_command('install_pdg')

class BuildGEDL(Command):
    description = 'Build the GEDL'
    path = Path('gedl').resolve()
    build_dir = Path('gedl/build').resolve()
    def initialize_options(self) -> None:
        pass
    def finalize_options(self) -> None:
        pass
    def run(self):
        def build():
            self.build_dir.mkdir(exist_ok=True) 
            subprocess.check_call(['cmake', self.path], cwd=self.build_dir)
            subprocess.check_call(['cmake', '--build', '.'], cwd=self.build_dir)
        build()
        # self.make_file(package_files(self.path), str(self.build_dir / 'libpdg.so'), func=build, args=[])

class BuildPDG(Command):
    description = 'Build the PDG'
    path = Path('pdg2').resolve()
    build_dir = Path('pdg2/build').resolve()
    def initialize_options(self) -> None:
        pass
    def finalize_options(self) -> None:
        pass
    def run(self):
        def build():
            self.build_dir.mkdir(exist_ok=True) 
            subprocess.check_call(['cmake', self.path], cwd=self.build_dir)
            subprocess.check_call(['cmake', '--build', '.'], cwd=self.build_dir)
        build()
        # self.make_file(package_files(self.path), str(self.build_dir / 'libpdg.so'), func=build, args=[])


class BuildPy(build_py):
    def run(self):
        self.run_command('build_gedl')
        build_py.run(self)


setup(
    name="capo",
    version="2.0.0",
    author="Benjamin Flin",
    author_email="benjamin.flin@peratonlabs.com",
    description="Compiler and Partitioner Optimizer (CAPO)",
    long_description="file: README.md",
    long_description_content_type="text/markdown",
    url = "https://github.com/gaps-closure/capo",
    project_urls={
        "Bug Tracker": "https://github.com/gaps-closure/capo/issues"
    },
    classifiers=["Programming Language :: Python :: 3"],
    packages=["conflict_analyzer", "gedl", "divider"],
    python_requires=">=3.6",
    entry_points={
        "console_scripts": [
            "conflict_analyzer=conflict_analyzer:conflict_analyzer.main",
            "divider=divider:program_divider.main",
            "rpc_generator=gedl:rpc_generator.main",
            "idl_generator=gedl:idl_generator.main"
        ]
    },
    package_data={
        "conflict_analyzer": ["constraints/*.mzn"]
    },
    include_package_data=True,
    cmdclass={
        'build_gedl': BuildGEDL,
        'build_pdg': BuildPDG,
        'build_py': BuildPy,
        'install_gedl': InstallGEDL,
        'install_pdg': InstallPDG,
        'install': Install,
    }
)