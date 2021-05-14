# Trust the Vote ABC Schemas

Documentation and tooling for explaining and validating schemas used in the Trust the Vote ABC.

## Overview

This repository contains or will contain:

- Sample files for the data exchanged between modules of the TTV ABC.
- Documentation and notes on the design of those APIs.

For the ABC the focus is on NIST Cast Vote Records (CVRs).

## Goals and Design Choices

1. Provide cast vote record samples with annotations.

    The Cast Vote Records spec comes with XML and JSON schemas. We focus on the JSON schemas as they are the fundamental 'API' between elements of the ABC design. However JSON is hard to write by hand and has no comments, so annotations have to be done on top of it. The current solution is to write documents in YAML, which allows comments and generate the JSON from it.

2. Allow support for comparing the samples in readable ways.

    Diffs, annotated HTML views, JSON visualizations in a browser - whatever makes CVRs easier to understand.

3. Support extended validation and testing.

    The XML and JSON schemas only do structural validation. They don't cover certain aspects of correctness, such as whether IDs in CVRs match the IDs in definitions.
    Over time adding this capability should turn into a suite of tests for CVRs.

## Status

### Current Schemas

Cast Vote Records (NIST 1500-103):

- Documentation on usage of Cast Vote Records.
- Samples:
    - Examples from NIST.
    - Customized samples demonstrating different parts of the CVR spec.
    - Annotated samples.

### Current Status

In progress:

- Notes on Cast Vote Records.
- Annotated samples of CVR data (NIST 1500-103).
- Annotated custom elections:
    - New York State in 1912
- Basic validation of CVR records for XML and JSON Schemas (provided by external libraries).
- Basic support for comparing CVR records.

In planning:

- Notes on testing.
- Generation of CVR data from readable (but not valid by the schema) fragments.
- Additional validation of CVR records on top of what the NIST schemas provide.

## File Structure

### Documentation

Documentation is in the `docs` folder. Notes are in `docs/notes` and annotated samples in `docs/annotated`.

### Data

All generated samples files are in `data/samples` and the schemas in `data/schemas.` The index of specific files and what they contain is in `data/README.md`.

## Setup 

To setup and build the samples follow the directions in  `docs/development.md`.

## References

NIST Cast Vote Records v1.0 (NIST-SP-1500-103):

- Landing page & UML breakdown: https://pages.nist.gov/CastVoteRecords
- Github project: https://github.com/usnistgov/CastVoteRecords
    - Specification available as:
        - [HTML](https://github.com/usnistgov/CastVoteRecords/NIST.SP.1500-103-rev.html)
        - [Markdown](https://github.com/usnistgov/CastVoteRecords/NIST.SP.1500-103-rev.md)
        - [PDF](https://github.com/usnistgov/CastVoteRecords/NIST.SP.1500-103-rev.pdf)
        - [Word](https://github.com/usnistgov/CastVoteRecords/NIST.SP.1500-103-rev.docx)
    - JSON schema: https://github.com/usnistgov/CastVoteRecords/NIST_V0_cast_vote_records.json
    - XML schema: https://github.com/usnistgov/CastVoteRecords/NIST_V0_cast_vote_records.xsd
    - XML examples:
        - https://github.com/usnistgov/CastVoteRecords/example_1.xml

JSON Schema:

- Main site: https://json-schema.org
- Specification
    - Current: https://json-schema.org/specification-links.html
    - Draft v4: https://json-schema.org/specification-links.html#draft-4

XML Schema:

- Main site and specification: https://www.w3.org/2001/XMLSchema
