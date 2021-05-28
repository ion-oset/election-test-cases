# --- Variables

# Paths

ROOT_path := $(dir $(abspath $(MAKEFILE_LIST)))
ROOT_path := $(ROOT_path:%/=%)
DATA_path := $(ROOT_path)/data
DOCS_path := $(ROOT_path)/docs

CVR_SAMPLES_path := $(DATA_path)/cvr/samples
CVR_SCHEMAS_path := $(DATA_path)/cvr/schemas

NOTES_DOCS_path := $(DOCS_path)/notes
ANNOTATIONS_DOCS_path := $(DOCS_path)/annotated

# File types

XML_ext := .xml
JSON_ext := .json
YAML_ext := .yaml
JSON_PORTED_ext := _ported.json
JSON_CONVERTED_ext := _converted.json

JSONSCHEMA_ext := jsonschema.json
XMLSCHEMA_ext := xmlschema.xml

NOTES_MARKDOWN_ext := .md
NOTES_HTML_ext := .html

ANNOTATIONS_HTML_ext := .html

# Samples - NIST

NIST_CVR_path := $(CVR_SAMPLES_path)/nist

NIST_CVR_XML_files := $(wildcard $(NIST_CVR_path)/*$(XML_ext))
NIST_CVR_JSON_CONVERTED_files := $(NIST_CVR_XML_files:%$(XML_ext)=%$(JSON_CONVERTED_ext))

NIST_CVR_YAML_files := $(wildcard $(NIST_CVR_path)/*$(YAML_ext))
NIST_CVR_JSON_PORTED_files := $(NIST_CVR_YAML_files:%$(YAML_ext)=%$(JSON_PORTED_ext))

# Samples - Minimal

MINIMAL_CVR_path := $(CVR_SAMPLES_path)/minimal

MINIMAL_CVR_YAML_files := $(wildcard $(MINIMAL_CVR_path)/*$(YAML_ext))
MINIMAL_CVR_JSON_files := $(MINIMAL_CVR_YAML_files:%$(YAML_ext)=%$(JSON_ext))

# Samples - NY-1912

NY_1912_CVR_path := $(CVR_SAMPLES_path)/ny-1912

NY_1912_CVR_YAML_files := $(wildcard $(NY_1912_CVR_path)/*$(YAML_ext))
NY_1912_CVR_JSON_files := $(NY_1912_CVR_YAML_files:%$(YAML_ext)=%$(JSON_ext))

# Schemas

CVR_JSONSCHEMA_file := $(CVR_SCHEMAS_path)/nist-cvr-v1_$(JSONSCHEMA_ext)
CVR_XMLSCHEMA_file := $(CVR_SCHEMAS_path)/nist-cvr-v1_$(XMLSCHEMA_ext)

# Notes

NOTES_MARKDOWN_files := $(wildcard $(NOTES_DOCS_path)/*$(NOTES_MARKDOWN_ext))
NOTES_HTML_files := $(NOTES_MARKDOWN_files:%$(NOTES_MARKDOWN_ext)=%$(NOTES_HTML_ext))

# Annotations - NIST

NIST_ANNOTATIONS_HTML_path := $(NIST_CVR_path)
NIST_ANNOTATIONS_HTML_files := $(NIST_CVR_YAML_files:%$(YAML_ext)=%$(ANNOTATIONS_HTML_ext))
NIST_ANNOTATIONS_DOCS_path := $(ANNOTATIONS_DOCS_path)/nist
NIST_ANNOTATIONS_DOCS_files := $(NIST_ANNOTATIONS_HTML_files:$(NIST_ANNOTATIONS_HTML_path)/%=$(NIST_ANNOTATIONS_DOCS_path)/%)

# Annotations - Minimal

MINIMAL_ANNOTATIONS_HTML_path := $(MINIMAL_CVR_path)
MINIMAL_ANNOTATIONS_HTML_files := $(MINIMAL_CVR_YAML_files:%$(YAML_ext)=%$(ANNOTATIONS_HTML_ext))
MINIMAL_ANNOTATIONS_DOCS_path := $(ANNOTATIONS_DOCS_path)/minimal
MINIMAL_ANNOTATIONS_DOCS_files := $(MINIMAL_ANNOTATIONS_HTML_files:$(MINIMAL_ANNOTATIONS_HTML_path)/%=$(MINIMAL_ANNOTATIONS_DOCS_path)/%)

# # Annotations - NY-1912

NY_1912_ANNOTATIONS_HTML_path := $(NY_1912_CVR_path)
NY_1912_ANNOTATIONS_HTML_files := $(NY_1912_CVR_YAML_files:%$(YAML_ext)=%$(ANNOTATIONS_HTML_ext))
NY_1912_ANNOTATIONS_DOCS_path := $(ANNOTATIONS_DOCS_path)/ny-1912
NY_1912_ANNOTATIONS_DOCS_files := $(NY_1912_ANNOTATIONS_HTML_files:$(NY_1912_ANNOTATIONS_HTML_path)/%=$(NY_1912_ANNOTATIONS_DOCS_path)/%)

# Tools

PANDOC := pandoc
PANDOC_NOTES_flags := --standalone

VALIDATE_JSON := jsonschema
VALIDATE_XML := xmlschema-validate

XML_TO_JSON := xmlschema-xml2json
YAML_TO_JSON := yaml2json

DOCCO := docco
# One of: parallel, linear, classic
DOCCO_LAYOUT := parallel
DOCCO_STYLES :=
DOCCO_TEMPLATES :=
DOCCO_flags := $(DOCCO_LAYOUT:%= -l %)$(DOCCO_STYLES:%= -c %)$(DOCCO_TEMPLATES:%= -t %)

# --- Rules

help:
	@echo "Targets":
	@echo ""
	@echo "  General"
	@echo ""
	@echo "    build:                 Build all samples, notes, annotations"
	@echo "    clean:                 Clean all samples, notes, annotations"
	@echo ""
	@echo "  Build samples:"
	@echo ""
	@echo "    build-samples:         Build all JSON samples from YAML"
	@echo "    clean-samples:         Clean all JSON samples built from YAML"
	@echo ""
	@echo "    build-nist-samples:    Build NIST JSON samples from YAML"
	@echo "    clean-nist-samples:    Clean NIST JSON samples built from YAML"
	@echo ""
	@echo "    build-minimal-samples: Build 'minimal' JSON samples from YAML"
	@echo "    clean-ninimal-samples: Clean 'minimal' JSON samples built from YAML"
	@echo ""
	@echo "    build-ny-1912-samples: Build NY 1912 JSON samples from YAML"
	@echo "    clean-ny-1912-samples: Clean NY 1912 JSON samples built from YAML"
	@echo ""
	@echo "  Converted samples:"
	@echo ""
	@echo "    build-nist-conversions: Converted NIST examples from XML to JSON"
	@echo "       Note: The result is NOT valid under the JSON Schema. Use it for comparison."
	@echo "    clean-nist-conversions: Cleanup converted samples"
	@echo ""
	@echo "  Documentation:"
	@echo ""
	@echo "    notes:                 Generate all notes"
	@echo "      html-notes:          Generate HTML notes"
	@echo "    clean-notes:           Cleanup all generated notes"
	@echo "      clean-html-notes:    Cleanup generated HTML notes"
	@echo ""
	@echo "    annotate:              Generate all annotations from samples"
	@echo "      annotate-docco:      Generate Docco annotations from all samples"
	@echo "    clean-annotations:     Cleanup all annotations"
	@echo "      clean-docco-annotations: Cleanup all Docco annotations"
	@echo ""
	@echo "  Validation:"
	@echo ""
	@echo "    validate:              Validate all samples"
	@echo "    validate-json:         Validate JSON samples"
	@echo "    validate-xml:          Validate XML samples"


# Build everything

build: build-samples notes annotate


clean: clean-samples clean-notes clean-annotations


# Build JSON samples

build-samples: build-nist-samples build-nist-conversions build-minimal-samples build-ny-1912-samples


clean-samples: clean-nist-samples clean-nist-conversions clean-minimal-samples clean-ny-1912-samples


# Convert NIST XML samples to JSON

build-nist-conversions: $(NIST_CVR_JSON_CONVERTED_files)


$(NIST_CVR_path)/%$(JSON_CONVERTED_ext): $(NIST_CVR_path)/%$(JSON_ext)
	jq '.' $< > $@


$(NIST_CVR_path)/%$(JSON_ext): $(NIST_CVR_path)/%$(XML_ext)
	@$(XML_TO_JSON) --schema $(CVR_XMLSCHEMA_file) $< -o $(NIST_CVR_path)


clean-nist-conversions:
	rm -f $(NIST_CVR_JSON_CONVERTED_files)


.PHONY: clean-nist-conversions


# Build NIST samples from YAML

build-nist-samples: $(NIST_CVR_JSON_PORTED_files)


$(NIST_CVR_path)/%$(JSON_PORTED_ext): $(NIST_CVR_path)/%$(YAML_ext)
	$(YAML_TO_JSON) $< $@


clean-nist-samples:
	rm -f $(NIST_CVR_JSON_PORTED_files)


.PHONY: clean-nist-samples


# Build minimal sample from YAML

build-minimal-samples: $(MINIMAL_CVR_JSON_files)


$(MINIMAL_CVR_path)/%$(JSON_ext): $(MINIMAL_CVR_path)/%$(YAML_ext)
	$(YAML_TO_JSON) $< $@


clean-minimal-samples:
	rm -f $(MINIMAL_CVR_JSON_files)


.PHONY: clean-minimal-samples


# Build NY 1912 sample from YAML

build-ny-1912-samples: $(NY_1912_CVR_JSON_files)


$(NY_1912_CVR_path)/%$(JSON_ext): $(NY_1912_CVR_path)/%$(YAML_ext)
	$(YAML_TO_JSON) $< $@


clean-ny-1912-samples:
	rm -f $(NY_1912_CVR_JSON_files)


.PHONY: clean-ny-1912-samples


# Documentation - Notes

notes: html-notes


html-notes: $(NOTES_HTML_files)


$(NOTES_DOCS_path)/%.html: $(NOTES_DOCS_path)/%.md
	$(PANDOC) $(PANDOC_NOTES_flags) $< -o $@


clean-notes: clean-html-notes


clean-html-notes:
	rm -f $(NOTES_HTML_files)


.PHONY: clean-notes clean-html-notes


# Documentation - Annotations
#
# Note: docco has unintuitive behavior regarding paths which requires switching
# to the destination directory and having all sources file in it.

annotate: $(ANNOTATIONS_DOCS_path) annotate-docco


annotate-docco: \
	$(NIST_ANNOTATIONS_DOCS_path) \
	$(MINIMAL_ANNOTATIONS_DOCS_path) \
	$(NY_1912_ANNOTATIONS_DOCS_path) \
	$(NIST_ANNOTATIONS_DOCS_files) \
	$(MINIMAL_ANNOTATIONS_DOCS_files) \
	$(NY_1912_ANNOTATIONS_DOCS_files)

$(ANNOTATIONS_DOCS_path):
	mkdir -p $@


$(NIST_ANNOTATIONS_DOCS_path):
	mkdir -p $@


$(NIST_ANNOTATIONS_DOCS_path)/%$(ANNOTATIONS_HTML_ext): $(NIST_ANNOTATIONS_DOCS_path)/%$(YAML_ext)
	( \
		cd $(NIST_ANNOTATIONS_DOCS_path); \
		$(DOCCO) $(DOCCO_flags) $$(basename $<) -o $$PWD; \
	)


$(NIST_ANNOTATIONS_DOCS_path)/%$(YAML_ext): $(NIST_CVR_path)/%$(YAML_ext)
	cp -af $< $@


$(MINIMAL_ANNOTATIONS_DOCS_path):
	mkdir -p $@


$(MINIMAL_ANNOTATIONS_DOCS_path)/%$(ANNOTATIONS_HTML_ext): $(MINIMAL_ANNOTATIONS_DOCS_path)/%$(YAML_ext)
	( \
		cd $(MINIMAL_ANNOTATIONS_DOCS_path); \
		$(DOCCO) $(DOCCO_flags) $$(basename $<) -o $$PWD; \
	)


$(MINIMAL_ANNOTATIONS_DOCS_path)/%$(YAML_ext): $(MINIMAL_CVR_path)/%$(YAML_ext)
	cp -af $< $@


$(NY_1912_ANNOTATIONS_DOCS_path):
	mkdir -p $@


$(NY_1912_ANNOTATIONS_DOCS_path)/%$(ANNOTATIONS_HTML_ext): $(NY_1912_ANNOTATIONS_DOCS_path)/%$(YAML_ext)
	( \
		cd $(NY_1912_ANNOTATIONS_DOCS_path); \
		$(DOCCO) $(DOCCO_flags) $$(basename $<) -o $$PWD; \
	)


$(NY_1912_ANNOTATIONS_DOCS_path)/%$(YAML_ext): $(NY_1912_CVR_path)/%$(YAML_ext)
	cp -af $< $@


clean-annotations: clean-nist-docco-annotations clean-minimal-docco-annotations clean-ny-1912-docco-annotations


clean-nist-docco-annotations:
	rm -rf $(NIST_ANNOTATIONS_DOCS_path)


clean-minimal-docco-annotations:
	rm -rf $(MINIMAL_ANNOTATIONS_DOCS_path)


clean-ny-1912-docco-annotations:
	rm -rf $(NY_1912_ANNOTATIONS_DOCS_path)


.PHONY: clean-annotations clean-nist-docco-annotations clean-minimal-docco-annotations clean-ny-1912-docco-annotations


# Validation
#
# Note: JSON converted from NIST XML examples will *not* validate.


validate: validate-xml validate-json


validate-json: validate-cvr-json


validate-cvr-json: validate-nist-cvr-json validate-minimal-cvr-json validate-ny-1912-cvr-json


validate-nist-cvr-json: $(NIST_CVR_JSON_PORTED_files)
	@for file in $^; do \
		echo "Validating: $$file..."; \
		$(VALIDATE_JSON) $(CVR_JSONSCHEMA_file) -i $$file; \
		if [ $$? -eq 0 ]; then echo "Valid schema."; else echo "Invalid schema."; fi; \
	done


validate-minimal-cvr-json: $(MINIMAL_CVR_JSON_files)
	@for file in $^; do \
		echo "Validating: $$file..."; \
		$(VALIDATE_JSON) $(CVR_JSONSCHEMA_file) -i $$file; \
		if [ $$? -eq 0 ]; then echo "Valid schema."; else echo "Invalid schema."; fi; \
	done


validate-ny-1912-cvr-json: $(NY_1912_CVR_JSON_files)
	@for file in $^; do \
		echo "Validating: $$file..."; \
		$(VALIDATE_JSON) $(CVR_JSONSCHEMA_file) -i $$file; \
		if [ $$? -eq 0 ]; then echo "Valid schema."; else echo "Invalid schema."; fi; \
	done


validate-xml: validate-cvr-xml


validate-cvr-xml: validate-nist-cvr-xml


validate-nist-cvr-xml: $(NIST_CVR_XML_files)
	@for file in $^; do \
		$(VALIDATE_XML) --schema $(CVR_XMLSCHEMA_file) $$file; \
	done
