FDPATH=../fast-downward
all:
	@echo "Usage: 'make <target>' where target is:"
	@echo "  clean, configkb_docs.done,"
	@echo "  configkb.owl, or configkb_owlready.py"

clean:
	rm -f *_owlready.py *.owl *_docs.done
	rm -rf docs 

.SECONDARY:

%_docs.done: %.owl
	mkdir -p ./docs/$(basename $<)
	ontospy gendocs -o $(PWD)/docs/$(basename $<) --extra --nobrowser --type=2 --theme=cerulean $<
	touch $@

%.owl: %_owlready.py
	python3 $<

%_owlready.py: %.vocab
	python3 vocab2owlready.py -v $< -o $@ -n $(basename $<)
