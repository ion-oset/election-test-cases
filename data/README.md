# NIST: Data Files

## CVR: Cast Vote Records

### Schemas

`cvr/schemas`
: Cast Vote Records schema: NIST SP 1500-103, version 1

    - [HTML (nist.gov)][nist-cvr-html]
    - [Source (github.com)][nist-cvr-source]

    `nist-cvr-v1_jsonschema.json`
    : JSON Schema for Cast Vote Records

        - Currently (May 2021) at revision 1.0.3
        - Last changed in version 1.0.0
        - Validates against [JSON Schema, Draft 4][json-schema-spec-draft-4]

    `nist-cvr-v1_xmlschema.xml`
    : XML Schema for Cast Vote Records

        - Currently (May 2021) at revision 1.0.3
        - Last changed in version 1.0.3
        - Validates against [XML Schema, 1.0][xml-schema-spec-2001]

### Samples

`cvr/samples`:
: All samples.

    Samples are grouped by their origin (e.g. NIST) or the election they are modelling.

`cvr/samples/nist`:
: NIST examples (from the CastVoteRecords repository.)

    The original examples are in XML. They JSON examples were converted from the XML ones by us - they are not part of the spec.

    `nist-example-1.xml`
    : Basic example from NIST CVR repository (XML).

        Shows basic structure only.
        Validates with the XML schema.
        
        See: `Section 5.1: Anatomy of a CVR.` of the NIST-SP-1500-103 specification.

    `nist-example-2.xml`
    : Complex example from NIST CVR repository (XML).

        Show more realistic examples.
        Validates with the XML schema.

        See: `Section(s) 5.2 - 5.8` of the NIST-SP-1500-103 specification.

    `nist-example-*_ported.json` (generated from `nist-example-*.yaml`)
    : XML exampes manually ported to YAML.

        - These validate with the JSON schema.
        - Compare them to the `_converted.json` versions below.

    `nist-example-*_converted.json` (generated from `nist-example-*.xml`)
    : Basic example converted to JSON from XML.

        - Converted using `xmlschema_xml2json`.
        - These are a 1:1 translation from XML and does *not* validate with the JSON schema. Initially they were used as the basis for generating the manual `_ported.json` versions. They remain for the sake of comparison with the manual versions.


`cvr/samples/minimal`:
: An absolutely minimal skeleton CVR.

    This is the minimum document that passes JSON schema validation. It doesn't have any CVR records or even define a useful election. 


`cvr/samples/ny-1912`
: A complex example based on the 1912 Presidential and Governor's races in New York state.

    This sample contains a series of CVRs, each adding another common variation on an actual vote.

    - They are heavily annotated. Use `make annotate` to generate the annotations in readable form, or look at the source YAML.

[nist-cvr-html]: https://pages.nist.gov/CastVoteRecords/
[nist-cvr-source]: https://github.com/usnistgov/CastVoteRecords

[json-schema-spec-all]: https://json-schema.org/specification-links.html
[json-schema-spec-current]: https://json-schema.org/specification-links.html
[json-schema-spec-draft-4]: https://json-schema.org/specification-links.html#draft-4
[json-schema-rfc-draft-4]: https://tools.ietf.org/html/draft-zyp-json-schema-04

[xml-schema-spec-2001]: https://www.w3.org/2001/XMLSchema
