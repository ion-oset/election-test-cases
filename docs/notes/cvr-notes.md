---
title: Notes on Cast Vote Records Data Specification 1.0
subtitle: NIST Special Publication 1500-103
---

## Overview

These notes are intended to help anyone working with Cast Vote Records (CVRs) as part of Trust the Vote to get oriented with the spec and schemas without needing to read the entire specification. This `Overview` section gives a summary of what's covered, the `Notes` are observations and tips.

This is a work in progress. There are bound to be errors, misconceptions, and lack of clarity. Please provide feedback and edits.

### Specification

CVRs are defined as **`NIST CastVoteRecords Data Specification 1.0`** also known as *NIST-SP-1500-103*. The [home page][nist-cvr-home] provides the UML descriptions, and the [full specification is available as PDF][nist-cvr-pdf]. The complete source, including the spec, schemas, examples, and UML diagrams is on GitHub in the [NIST CastVoteRecords repository][nist-cvr-source].

[The full CVR 1.0 specification PDF][cvr] is 94 pages long. The purpose of these notes is to save you the effort of reading it unless you need to. When the notes describe anything backed up by the spec they refer to sections of the specification and list the page number(s) to refer to. The first number is the page of the spec, and the number in parentheses is the page of the PDF.tree/v1.0.3/NIST_V0_cast_vote_records.json

```
    Section 1, p. 1 (10)
    Section 2, p. 10-11 (19-20)
```

#### Reading Order

If you decide to read the full spec, a recommended reading order to save you time:

To get you oriented in general and help understand the examples.

- Start with [`Section 2, Background: Cast Vote Record Creation, Contents, and Handling` (p. 3 (12))] which explains the general design and use cases of Cast Vote Records.
- Look over the UML diagram record classes in [`Section 3, Figure 1, UML Model - Classes` (p. 7-8 (16-17))] to understand how they relate.
- Look at [`Section 5, Usage Examples` (p. 66 (75))] to see what records look like and get a taste of how they are used.
- Look at [`Appendix A, Acronyms` (p. 79 (88))] and [`Appendix B, Glossary` (p. 80 (89))] when you need a term defined.

If or when you need to know more or dig into the details of the CVR records.

- Look at [`Section 3: Cast Vote Record UML Model Overview` (p. 6 (15))]. This explains the design of the structure of the records, and how they work together.
- Use [`Section 4. Cast Vote Record UML Model Documentation` (p. 20 (29))] when you need to know specific details of specific record classes, or specific fields names and values. This is the bulk of the specification.

### Schemas

There are two schema definitions designed by NIST for Cast Vote Records, one for [JSON Schema][json-schema-current]([Draft 4][json-schema-draft-4]) and one for [XML Schema (version 1.0)][xml-schema-version-1]. The schemas are found in this repository at [data/cvr/schemas](../../data/cvr/schemas).

- CVR 1.0 JSON Schema: [`data/cvr/schemas/nist-cvr-v1_jsonschema.json`](../../data/cvr/schemas/nist-cvr-v1_jsonschema.json). It's taken directly from the CVR GitHub repository from release 1.0.3: [`NIST_V0_cast_vote_records.json`][nist-source-jsonschema]
- CVR 1.0 XML Schema: [`data/cvr/schemas/nist-cvr-v1_xmlschema.xml`](../../data/cvr/schemas/nist-cvr-v1_xmlschema.xml). It's taken directly from the CVR GitHub repository from release 1.0.3: [`NIST_V0_cast_vote_records.xsd`][nist-source-xmlschema]

Notes:

- We are using the JSON schema because modules of the Trust the Vote system communicate via JSON documents.
- The two schemas are semantically 1-to-1 but there are some changes of notation and convention between XML and JSON that make a direct translation by naive software not produce a valid document.

### JSON Schema specific notes

- Optional properties are allowed in the spec but disallowed by the JSON schema.
- An `@` at the start of a property name is a convention that is used to capture information that the XML schema represents as element and attribute names. The only examples are:
  - `@id`, contains an ID unique to a given record or element that is used to refer to that record from other parts of the schema. In the XML schema this is an attribute called `ObjectId`.
  - `@type` is the record's class according to the specification. In the XML schema this is the XML element name.
    - `@type` is required on *every record*. The keys of the records are informational but they are not used for type checking.
    - In CVR the JSON keys almost always match the class names, but the data always has to independently contain the class. The definitions can look repetitive but they structurally are not.
- Types always are prefixed with a `CVR.` namespace. The namespace is a *convention, not a feature of JSON Schema. However it is enforced by schema validation so if you leave it off you get an error.
- You'll see fields called `@id` and fields ending in `Id`. The former are in the definition of the record the ID refers to. The latter are references to other records. So a contest defined in `Election.Contest` with an `@id`  of `contest-01` will be referenced in a `CVRContest` record as `ContestId: contest-01`.
IDs are contest specific. Their primary purpose is to allow reference to a declaration to appear in the `CVR*` prefixed records without duplicating, i.e. to keep the record normalized.
    - These are distinct from `@id` fields which identify the given record within the CVR.
    - It's not clear if there is a benefit in them being unique beyond a given CVR.
- Codes refer to codes used by election officials in particular jurisdictions.
  They have a formal definition provided by the jurisdiction.
    - Codes may be labelled with their purpose but they do not have to be meaningful outside of their jurisdiction.
- A lot of material repeats.
    - 
    - CVRs need to be able to stand independently of other CVRs so the CVRs for a single election or contest will often replicate information in other CVRs.
    - Snapshots in particular

### Record Classes

Certain record classes can be subtle or confugins

- `SelectionPosition` is the record type that has the most special cases. It 
    - `HasIndication`: the presence of a mark.
    - `IsAllocable`: does the mark get "allocated" (counted)
        - Optional. Defaults to `HasIndication`

- Distinguish between `CVRContestPosition.OptionPosition` and `SelectionPosition.Position` will be the same in a valid majority or plurality ballot. The reason they are different is that more than one selection can be marked in other kinds of voting methods, and CVRs need to track all marks valid or not.

### Glossary

You can see look at the [Full Glossary]

- `CVR`: "Cast Vote Record". This term can be used ambiguously.
    - The entire report. The specification calls this a  `CastVoteRecordReport`, but discussion of the reports often refers to "CVRs"
    - An individual cast vote record. The specification calls this a `CVR`.
    - The specification itself.

- `Election`: An entire election as run in a given jurisdiction.
- `Contest`: Anything being voted on: an office or offices, a ballot measure, a party-line vote. What is colloquially referred to as a "race" is a `Contest`. An `Election` typically has multiple `Contest`s. 
- `ContestSelection`: A choice in a `Contest`.
- `Candidate`: Anyone running for an office.

### Questions

- How unique are CVR IDs? e.g.
    - Are they best kept opaque to the contents of what they are identifying?
      e.g. is a prefix like `contest-` or `candidate-` an issue?
    - Should the ID be for an object like a Contest or Candidate be the same in all CVRs for that election?
    - Hashes? Descriptive prefixes? Monotonically increasing IDs?
- The only date the CVR reports is the date the CVR was generated.
  It does not appear to have any field for noting the date of the election.
  Is this correct?
- `GpUnit.Type` where the record was generated. How does this work for a vote-by-mail ballot? (A ballot printed at home is currently not even an option.)

[nist-cvr-home]: https://pages.nist.gov/CastVoteRecords
[nist-cvr-pdf]: https://nvlpubs.nist.gov/nistpubs/SpecialPublications/NIST.SP.1500-103.pdf
[nist-cvr-source]: https://github.com/usnistgov/CastVoteRecords

[nist-source-jsonschema]: https://github.com/usnistgov/CastVoteRecords/tree/v1.0.3/NIST_V0_cast_vote_records.json
[nist-source-xmlschema]: https://github.com/usnistgov/CastVoteRecords/tree/v1.0.3/NIST_V0_cast_vote_records.xsd

[json-schema-current]: https://json-schema.org/specification-links.html
[json-schema-draft-4]: https://json-schema.org/specification-links.html#draft-4

[xml-schema-version-1]: https://www.w3.org/2001/XMLSchema
