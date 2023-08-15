rm -rf tmp
mkdir tmp
python3 -m conflict_analyzer --temp-dir tmp --pdg-lib pdg2/build/libpdg.so --dump-ptg pdg2/svf/Release-build/bin/dump-ptg conflict_analyzer/constraints/phase-3/examples/$1/$1.c
rm conflict_analyzer/constraints/phase-3/examples/$1/artifacts/*
mv tmp/* conflict_analyzer/constraints/phase-3/examples/$1/artifacts
