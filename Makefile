# --- Variables

# Paths

ROOT_path := $(dir $(abspath $(MAKEFILE_LIST)))
ROOT_path := $(ROOT_path:%/=%)
DATA_path := $(ROOT_path)/data
DOCS_path := $(ROOT_path)/doc

# Samples

SAMPLES_path := $(DATA_path)/samples
SAMPLES_XML_ext := _sample.xml
CVR_SAMPLES_path := $(SAMPLES_path)/cvr
CVR_SAMPLES_XML_files := $(wildcard $(CVR_SAMPLES_path)/*$(SAMPLES_XML_ext))

# Schemas

SCHEMAS_path := $(DATA_path)/schemas
CVR_SCHEMAS_path := $(SCHEMAS_path)/cvr
CVR_XMLSCHEMA_ext := xmlschema.xml
CVR_XMLSCHEMA_file := $(CVR_SCHEMAS_path)/nist-cvr-v1_$(CVR_XMLSCHEMA_ext)

VALIDATE_XML := xmlschema-validate


# --- Rules

help:
	@echo "Targets":
	@echo ""
	@echo "  Validation:"
	@echo ""
	@echo "    validate:              Validate all samples"
	@echo "    validate-xml:          Validate XML samples"


# Validation

validate: validate-xml


validate-xml: validate-cvr-xml


validate-cvr-xml: $(CVR_SAMPLES_XML_files)
	@for file in $^; do \
		$(VALIDATE_XML) --schema $(CVR_XMLSCHEMA_file) $$file; \
	done
