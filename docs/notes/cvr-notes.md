---
title: Notes on Cast Vote Records Data Specification 1.0
subtitle: NIST Special Publication 1500-103
---

## Overview

These notes are intended to help anyone working on Cast Vote Records as part of Trust the Vote get oriented with the specification and schemas without needing to read the entire specification.

### The specification

The full specification source is on GitHub in the [NIST CastVoteRecords repository][nist-cvr-source].

The CVR 1.0 specification PDF is 94 pages long, but you don't need to read it. The notes below refer to the specification where it is useful so you can follow up on any questions you have.

If you decide to read it, a recommended reading order to save you time.

- Start with [Section 2, Background: Cast Vote Record Creation, Contents, and Handling]() which explains the general design of Cast Vote Records and what they are intended to be used for.
- Take a look at the UML diagram record classes in [Section 3, Figure 1, UML Model - Classes] to get oriented.
- Take a look at [Section 5, Usage Examples]() to see what records look like and get a taste of how they are used.
- Look at [Appendix A, Acronyms] and [Appendix B, Glossary] if you want a summary of the terminology.

That should get you oriented in general and help with the examples. If or when you need to know more or dig into the details of the CVR records.

- Look at [Section 3. Cast Vote Record UML Model Overview]. This discusses the overall structure of the records, and how they work together.
- Use [Section 4. Cast Vote Record UML Model Documentation] only when you need to know specific details of specific record classes, or specific fields names and values.

### Schemas

There are two schema definitions designed by NIST for Cast Vote Records, one for [JSON Schema][json-schema-current]([Draft 4][json-schema-draft-4]) and one for [XML Schema (version 1.0)][xml-schema-version-1].

- We are preferentially using the JSON schema to pass data between modules of the Trust the Vote system.
- The two schemas are trying to capture the same information but there are some small translation incompatibilities.

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

[nist-cvr-source]: https://github.com/usnistgov/CastVoteRecords

[json-schema-current]: https://json-schema.org/specification-links.html
[json-schema-draft-4]: https://json-schema.org/specification-links.html#draft-4

[xml-schema-version-1]: https://www.w3.org/2001/XMLSchema
