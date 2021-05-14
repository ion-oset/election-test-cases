# NIST: Data Files

## CVR: Cast Vote Records

### Schemas

`schemas/cast-vote-records`
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

`samples/cvr`:
: NIST examples.

    The original examples are in XML. They JSON examples were converted from the XML ones by us - they are not part of the spec.

    `nist-cvr-01_sample.xml`
    : Basic example from NIST CVR repository (XML). Shows basic structure only.
      See: `Section 5.1: Anatomy of a CVR.` of the NIST-SP-1500-103 specification.

    `nist-cvr-02_sample.xml`
    : Complex example from NIST CVR repository (XML). Show more realistic examples.
      See: `Section(s) 5.2 - 5.8` of the NIST-SP-1500-103 specification.

    `nist-cvr-01_sample.json`
    : Basic example manually ported to JSON.

    `nist-cvr-02_sample.json`
    : Complex example manually ported to JSON.


`samples/cvr/converted`:
: NIST XML examples converted to JSON using `xmlschema-xml2json`.

    Note that these are *not valid* according to the JSON schema. They were used as the basis for generating the manual JSON samples which do validate.

    `nist-cvr-02_sample.xml`
    : More complex example from NIST CVR repository (XML).


`samples/cvr/sources`:
: JSON examples written by hands.

    `minimal_cvr.yaml`
    : An absolutely minimal skeleton CVR.

        It doesn't have any records or even define a real election.

    `ny-1912_cvr.yaml`
    : A CVR based on the 1912 Presidential and Governor's races in New York state.

        This sample contains a series of CVRs each adding another common variation on an actual vote.


[nist-cvr-html]: https://pages.nist.gov/CastVoteRecords/
[nist-cvr-source]: https://github.com/usnistgov/CastVoteRecords

[json-schema-spec-all]: https://json-schema.org/specification-links.html
[json-schema-spec-current]: https://json-schema.org/specification-links.html
[json-schema-spec-draft-4]: https://json-schema.org/specification-links.html#draft-4
[json-schema-rfc-draft-4]: https://tools.ietf.org/html/draft-zyp-json-schema-04

[xml-schema-spec-2001]: https://www.w3.org/2001/XMLSchema
