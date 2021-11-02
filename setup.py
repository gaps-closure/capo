from distutils.core import setup, Extension
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
    packages=["preprocessor", "conflict_analyzer", "gedl", "divider"],
    python_requires=">=3.6",
    entry_points={
        "console_scripts": [
            "conflict_analyzer=conflict_analyzer:__main__.main",
            "divider=divider:program_divider.main",
            "gedl=gedl:__main__.main",
            "rpc_generator=gedl:rpc_generator.main",
            "idl_generator=gedl:idl_generator.main",
            "preprocessor=preprocessor:__main__.main",
            "join_clemaps=preprocessor:join_clemaps.main"
        ]
    },
    scripts=[
        'ect/flowspec/Explanations.py',
        'ect/flowspec/FlowModel.py',
        'ect/flowspec/FlowSolver.py',
        'ect/flowspec/xdmfview.py'
    ],
    package_data={
        "conflict_analyzer": ["constraints/*.mzn"],
        "gedl": ["heuristics/*.json"]
    }
)