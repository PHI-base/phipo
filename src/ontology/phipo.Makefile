## Customize Makefile settings for phipo
## 
## If you need to customize your Makefile, make
## changes here rather than in the main Makefile

# SPARQL_VALIDATION_CHECKS:=$(SPARQL_VALIDATION_CHECKS) missing-namespace

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

SPARQL_VALIDATION_CHECKS =  owldef-self-reference label-with-iri
