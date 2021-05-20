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

## Notes

### Key Concepts

The most important distinction to make is that a CVR report will include two overlapping contexts:

- An *"election definition"* defines all possible choices for each contest, and all attributes of those choices (for instance a list of a candidates and names and parties of those candidates).

    Think of these as the description of the full ballot *before* a voter makes any choices.

- A *"cast vote record"* is description of the *concrete choices* made by an actual voter. These choices are a subset of the choices in the election definition. (A "cast vote record" is strictly speaking, this *concrete* choice but the term is used ambigiously. See below under [`Terminology`](#terminology)).

    Think of these as the choices made on the ballot by a voter. This is (obviously) a subset of the full set of choices on the ballot.

There are several concepts ("contest", "candidate") that have meaning in both contexts. The distinction is confusing enough that these notes reinforce it in several places.

- A *"contest"* is all the choices available in a contest. Most contests are "candidate contests", but there are several other kinds. A *"contest selection"* is any individual choice in a contest.
    - In an election definition a contest [`Section 4.9` (p. 29 (38))] includes all the choices available to a voter.
    - In a cast vote record a contest [`Section 4.12` (p. 33 (42))] includes only the choices actually made by the voter. It will refer back to the contest in the election definition.

#### Terminology

This section is about any terminology that can be confusing.

- The formal name for the document is a "Cast Vote Record _Report_". There is also a record type called `'CVR'` that refers to information about a given voter's cast vote. A `'CastVoteRecordReport'` consists of a series of `'CVR'` records as well as a formal definition of the election (in `'Election'` records) and other properties of the actual election, such as its location and the machinery used to carry it out.

### Record Classes

The full overview of record types in CVR is in [`Section 2: Background: Cast Vote Record Creation, Contents, and Handling`(p. 3 (12))]. These are a brief summary of the main ones and their subtle or confusing points.

- The top-level record is `CastVoteRecordReport` [`Section 4.7` (p. 26 (35)]. It's most important sub-records are `CVR` and `Election`.
- `Election` represents an "election defintion". It includes details such as what it is called, where it happened, who or what is being voted on. It's sub-elements are the full set of choices available to a voter in an election. The choices made by the voter in a `CVR` will refer back to the definitions made in an `Election`.

    `Election`s avoid duplication by using references between types.

    - A `Contest` describes an abstract contest being voted on. A contest with candidates will have `Candidate`s defined in the election, and referenced by ID in the `Contest`.
    - Similarly a `Candidate` will keep a reference to the ID of a `Party`, with the `Party` defined separately.

- `CVR` [`Section 4.11` (p. 31 (40)] represents a "cast vote record". It includes the information which choices the voter made, whether the vote was counted, and what the details of the vote are if it needs arbitration. Its sub-records are concrete choices made from the menu of choices available in the `Election`. It refers back to the records in `Election`s.

    `CVR` sub-elements refer to the sub-elements of `Election`. Some main record types that start with a `"CVR"` prefix are sub-elements of `CVR` records that refer back to sub-elements of `Election` without the prefix.

Notes & Gotchas:

- Not all records starting with `"CVR"` have equivalents in `Election` because some properties are only part of a CVR such as the actual choices made on the ballot.
    - The main ones are  `Contest`/`CVRContest` and `ContestSelection`/`CVRContestSelection`.
- In general the attributes of similar types differ significantly between the election definition and the cast vote record.
- Not all sub-elements of a cast vote record start with `"CVR"`, only the ones that are ambiguous. This can be confusing when trying to remember what something is called.

### JSON Schema Notes

- The schema disallows `additionalProperties`: you can't add a property to a record that's not explicitly defined in the schema
- An `@` at the start of a property name is a convention for attributes that are internal to the CVR document and have no meaning outside of it. (In the XML Schema these correspond to element names and attributes of a record class.)
- `@id` is used for "object identifiers".
    - *References* to object identifiers end with `"Id"`.
    - Somewhat confusingly other kinds of ID definition *also* end with `"Id"`.

        ```
            "Contest": {
                "@id": "contest-01"
            }

            # ...

            "CVRContest": {
                "ContestId": "contest-01"
            }        
        ```
  - `@type` is the record's class according to the s pecification. In the XML schema this is the XML element name.
    - `@type` is required on *every record*. 
    - In CVR the JSON keys almost always match the class names, but the data always has to independently contain the class. The definitions can look repetitive but they structurally are not.
- `@type` is a required property on any JSON object that represents a CVR record class. The keys used for those records often the same as the class name, which will seem redundant and verbose, but the keys are informational but they are not used for type checking. (In the XML schema this the element's tag and not an attribute.)
    - All classes are prefixed with a `CVR.` namespace. The namespace is a *convention*, not a feature of JSON Schema, but leaving it off is an error.

    Example:

    ```
        {
            "CVRContest": {
                "@type": "CVR.CVRContest"
            }
        }
    ```

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
