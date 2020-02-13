## Customize Makefile settings for phipo
## 
## If you need to customize your Makefile, make
## changes here rather than in the main Makefile

pattern_tsvs := $(patsubst %.tsv, $(PATTERNDIR)/data/default/%.tsv, $(notdir $(wildcard $(PATTERNDIR)/data/default/*.tsv)))

# SPARQL_VALIDATION_CHECKS:=$(SPARQL_VALIDATION_CHECKS) missing-namespace

tmp/phipo_deprecated.txt: $(SRC)
	$(ROBOT) query -i $(SRC) -q ../sparql/phipo_obsoletes.sparql $@
	sed -i -r -e '1d' -e 's/^.+?PHIPO_([[:digit:]]{7})/PHIPO:\1/g' $@

.PHONY: tmp/pattern_terms.txt
tmp/pattern_terms.txt:
	grep -E 'PHIPO_[[:digit:]]{7}' ../patterns/all_pattern_terms.txt |\
	sed -r 's/^.+?PHIPO_([[:digit:]]{7})/PHIPO:\1/g' > tmp/pattern_terms.txt

clean_obsolete: tmp/phipo_deprecated.txt tmp/pattern_terms.txt
	comm -12 tmp/pattern_terms.txt tmp/phipo_deprecated.txt |\
	while read -r line; do \
		for tsv in $(pattern_tsvs); do \
			sed -i "/$$line/d" "$$tsv"; \
		done \
	done

# $(ONT).owl: $(SRC)
#	 $(ROBOT)  reason -i $< -r ELK relax reduce -r ELK annotate -V $(BASE)/releases/`date +%Y-%m-%d`/$(ONT).owl -o $@

# we have to set strict mode (--check) to false to generate the OBO file
# see https://github.com/PHI-base/phipo/issues/30
# $(ONT).obo: $(ONT).owl
#	$(ROBOT) convert --check false -i $< -f obo -o $(ONT).obo.tmp && mv $(ONT).obo.tmp $@

# clone remote ontology locally; wget is used instead of ROBOT to
# prevent Travis-CI failing on large ontologies.
# mirror/%.owl: $(SRC)
#	mkdir -p mirror && wget -O $@ $(OBO)/$*.owl
