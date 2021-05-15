# --- Variables

# Paths

ROOT_path := $(dir $(abspath $(MAKEFILE_LIST)))
ROOT_path := $(ROOT_path:%/=%)
DATA_path := $(ROOT_path)/data
DOCS_path := $(ROOT_path)/docs

# Samples

SAMPLES_path := $(DATA_path)/samples
SAMPLES_JSON_ext := _sample.json
SAMPLES_XML_ext := _sample.xml
SAMPLES_XML_TO_JSON_ext := _sample.xml-json
CVR_SAMPLES_path := $(SAMPLES_path)/cvr
CVR_SAMPLES_CONVERTED_path := $(CVR_SAMPLES_path)/converted
CVR_SAMPLES_JSON_files := $(wildcard $(CVR_SAMPLES_path)/*$(SAMPLES_JSON_ext))
CVR_SAMPLES_XML_files := $(wildcard $(CVR_SAMPLES_path)/*$(SAMPLES_XML_ext))
CVR_SAMPLES_XML_TO_JSON_files := $(patsubst %$(SAMPLES_XML_ext),%$(SAMPLES_XML_TO_JSON_ext),$(CVR_SAMPLES_XML_files))
CVR_SAMPLES_XML_TO_JSON_files := $(notdir $(CVR_SAMPLES_XML_TO_JSON_files))
CVR_SAMPLES_XML_TO_JSON_files := $(CVR_SAMPLES_XML_TO_JSON_files:%=$(CVR_SAMPLES_CONVERTED_path)/%)

# Sources

SOURCES_YAML_ext := _cvr.yaml
SOURCES_JSON_ext := _cvr.json
CVR_SOURCES_path := $(CVR_SAMPLES_path)/sources
CVR_SOURCES_YAML_files := $(wildcard $(CVR_SOURCES_path)/*$(SOURCES_YAML_ext))
CVR_SOURCES_JSON_files := $(CVR_SOURCES_YAML_files:%$(SOURCES_YAML_ext)=%$(SOURCES_JSON_ext))

# Schemas

SCHEMAS_path := $(DATA_path)/schemas
CVR_SCHEMAS_path := $(SCHEMAS_path)/cvr
CVR_JSONSCHEMA_ext := jsonschema.json
CVR_JSONSCHEMA_file := $(CVR_SCHEMAS_path)/nist-cvr-v1_$(CVR_JSONSCHEMA_ext)
CVR_XMLSCHEMA_ext := xmlschema.xml
CVR_XMLSCHEMA_file := $(CVR_SCHEMAS_path)/nist-cvr-v1_$(CVR_XMLSCHEMA_ext)

VALIDATE_JSON := jsonschema
VALIDATE_XML := xmlschema-validate

XML_TO_JSON := xmlschema-xml2json

YAML_TO_JSON := yaml2json

# Documentation

NOTES_MARKDOWN_ext := md
NOTES_HTML_ext := html
NOTES_DOCS_path := $(DOCS_path)/notes
NOTES_MARKDOWN_files := $(wildcard $(NOTES_DOCS_path)/*.$(NOTES_MARKDOWN_ext))
NOTES_HTML_files := $(NOTES_MARKDOWN_files:%.$(NOTES_MARKDOWN_ext)=%.$(NOTES_HTML_ext))

PANDOC := pandoc
PANDOC_NOTES_flags := --standalone

# --- Rules

help:
	@echo "Targets":
	@echo ""
	@echo "  Build samples:"
	@echo ""
	@echo "    build-samples:         Build JSON samples from YAML"
	@echo "    clean-build-samples:   Clean built JSON samples from YAML"
	@echo ""
	@echo "  Convert samples:"
	@echo ""
	@echo "    convert-samples:          Generate all converted samples"
	@echo "    convert-samples-xml-json: Generate converted JSON samples from XML samples"
	@echo "       Generated JSON is NOT valid. Use it for comparison."
	@echo "    clean-converted-samples:  Cleanup converted samples"
	@echo ""
	@echo "  Documentation:"
	@echo ""
	@echo "    notes:                 Generate all notes"
	@echo "    html-notes:            Generate HTML notes"
	@echo "    clean-notes:           Cleanup all generated notes"
	@echo "    clean-html-notes:      Cleanup generated HTML notes"
	@echo ""
	@echo "  Validation:"
	@echo ""
	@echo "    validate:              Validate all samples"
	@echo "    validate-json:         Validate JSON samples"
	@echo "    validate-xml:          Validate XML samples"

build: build-samples convert-samples


clean: clean-build-samples clean-converted-samples clean-notes


# Build JSON samples from YAML

build-samples: build-yaml-sources


build-yaml-sources: $(CVR_SOURCES_JSON_files)


$(CVR_SOURCES_path)/%_cvr.json: $(CVR_SOURCES_path)/%_cvr.yaml
	$(YAML_TO_JSON) $< $@


clean-build-samples:
	rm $(CVR_SOURCES_JSON_files)

.PHONY: clean-build-samples


# Convert XML samples to JSON

convert-samples: convert-samples-xml-json


convert-samples-xml-json: $(CVR_SAMPLES_XML_TO_JSON_files)


$(CVR_SAMPLES_CONVERTED_path)/%.xml-json: $(CVR_SAMPLES_CONVERTED_path)/%.json
	jq '.' $< > $@


$(CVR_SAMPLES_CONVERTED_path)/%.json: $(CVR_SAMPLES_path)/%.xml
	@$(XML_TO_JSON) --schema $(CVR_XMLSCHEMA_file) $< -o $(CVR_SAMPLES_CONVERTED_path)


clean-converted-samples:
	rm $(CVR_SAMPLES_XML_TO_JSON_files)

.PHONY: clean-converted-samples


# Documentation

notes: html-notes


html-notes: $(NOTES_HTML_files)


$(NOTES_DOCS_path)/%.html: $(NOTES_DOCS_path)/%.md
	$(PANDOC) $(PANDOC_NOTES_flags) $< -o $@


clean-notes: clean-html-notes


clean-html-notes:
	rm -f $(NOTES_HTML_files)


.PHONY: clean-notes clean-html-notes


# Validation

validate: validate-xml validate-json


validate-json: validate-cvr-json


validate-cvr-json: $(CVR_SAMPLES_JSON_files) $(CVR_SOURCES_JSON_files)
	@for file in $^; do \
		echo "Validating: $$file..."; \
		$(VALIDATE_JSON) $(CVR_JSONSCHEMA_file) -i $$file; \
		if [ $$? -eq 0 ]; then echo "Valid schema."; else echo "Invalid schema."; fi; \
	done


validate-xml: validate-cvr-xml


validate-cvr-xml: $(CVR_SAMPLES_XML_files)
	@for file in $^; do \
		$(VALIDATE_XML) --schema $(CVR_XMLSCHEMA_file) $$file; \
	done
