# NIST: Data Files

### Schemas

#### NIST Schemas

`schemas`
: NIST SP 1500 schemas for election data:

    - Cast Vote Records: `NIST SP 1500-103, version 1`
        - [HTML (nist.gov)][nist-cvr-html]
        - [Source (github.com)][nist-cvr-source]
    - Election Report Results: `NIST SP 1500-103, version 2`
        - [HTML (nist.gov)][nist-edf-html]
        - [Source (github.com)][nist-edf-source]

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

    `nist-cvr-v1_jsonschema.json`
    : JSON Schema for Election Report Results

        - Currently (May 2021) at revision 2.0.3
        - Last changed in version 1.0.0
        - Validates against [JSON Schema, Draft 4][json-schema-spec-draft-4]

    `nist-cvr-v1_xmlschema.xml`
    : XML Schema for Cast Vote Records

        - Currently (May 2021) at revision 2.0.3
        - Last changed in version 2.0.2
        - Validates against [XML Schema, 1.0][xml-schema-spec-2001]

### Samples

`samples`:
: All samples.

    Samples are grouped by their origin (e.g. NIST) or the election they are modelling.

#### NIST Samples

`samples/nist`:
: Official NIST examples, from the [CastVoteRecords][nist-cvr-source] and [ElectionReportResults][nist-edf-source] repositories.

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

#### Minimal Samples

`samples/minimal`:
: An absolutely minimal skeleton CVR.

    This is the minimum document that passes JSON schema validation. It doesn't have any CVR records or even define a useful election. 

#### NY-1912 Samples

`samples/ny-1912`
: A complex example based on the 1912 Presidential and Governor's races in New York state.

    This sample contains a series of CVRs, each adding another common variation on an actual vote.

    They are heavily annotated. Use `make annotate` to generate the annotations in readable form, or look at the source YAML.

#### Jetsons Samples

`samples/jetsons`:
: CVRs for the Jetsons demo election.

    Samples for the Jetsons election used in the ABC.

    The current specification is described on the [Jetsons Elections wiki page][ttv-jetsons-wiki]. Documentation about the use and meaning of various fields is in `doc/notes/jetsons.notes.md`.

    All files have an XML and a JSON version, which validate using their respective schemas. The JSON version is generated from the YAML version. The YAML versions are annotated.

    The `main` CVR file has all the CVR records for every precinct. There is also a *standalone* CVR file (in each data format) for each of the precincts, limited to the CVR records, candidates and contests for each precinct. The standalone CVRs should be proper subsets of the main one. Inconsistencies are errors.

    `jetsons_main_edf.{xml,json,yaml}`
    : Election Definition File for Jetsons elections.

    `jetsons_main_cvr.{xml,json,yaml}`
    : Full Cast Vote Record for Jetsons elections, with all precincts.

    `jetsons_{bedrock,downtown,port,spacetown}-precinct_cvr.{xml,json,yaml}`
    : Standalone Cast Vote Records for each precinct in the Jetsons elections.

        - `bedrock` for Bedrock Precinct.
        - `downtown` for Downtown Precinct.
        - `port` for Port Precinct.
        - `spacetown` for SpaceTown Precinct (the 'T' is capitalized).

[nist-cvr-html]: https://pages.nist.gov/CastVoteRecords/
[nist-cvr-source]: https://github.com/usnistgov/CastVoteRecords
[nist-edf-html]: https://pages.nist.gov/ElectionReportResults/
[nist-edf-source]: https://github.com/usnistgov/ElectionReportResults

[json-schema-spec-all]: https://json-schema.org/specification-links.html
[json-schema-spec-current]: https://json-schema.org/specification-links.html
[json-schema-spec-draft-4]: https://json-schema.org/specification-links.html#draft-4
[json-schema-rfc-draft-4]: https://tools.ietf.org/html/draft-zyp-json-schema-04

[xml-schema-spec-2001]: https://www.w3.org/2001/XMLSchema

[ttv-jetsons-wiki]: https://github.com/ion-oset/cast-vote-records/wiki/Jetsons-Election
