---
title: Notes on the Jetsons election data samples
---

These notes are about the design choices for the CVRs and EDFs in `data/cvr/samples/jetsons.`

### Naming conventions

#### File Names

File names use the naming convention:

```
    jetsons_{group}_{schema}.{format}
```

- `group` associates files tracking similar specific information (such as precincts).
- `schema` is one of `cvr` or `edf`
- `format` is one of `json`, `yaml` or `xml`.

#### Internal IDs

Internal IDs are unique only within a given file.

- In XML they are the attribute `ObjectId`
- In JSON they are the property `@id`

Internal IDs use the naming convention:

```
    {record}-{category}-{subcategory}
```

- The primary constraint is to be immediately readable to developers. Once you know the convention you should be able to easily figure out what kind of element an identifier is referring to and where to find the definition.
    - Compactness is *not* a goal.
- `record` is a record class name (e.g. `contest`, `candidate`, etc.)
- `category` and `subcategory` are dependent on the `record`
- Words are all lower case
    - Only `XMLChar`s are allowed (`[a-z0-9_-`) for compatibility with XML, even though JSON Schema has no real restrictions on the IDs.
- Multi-word terms are also separated by dashes (`-`).

    In the case of record classes that are a relation between types (like `ContestSelection`s) the '--' separator may be used to make the clearly separate related types because they can get confused with those types.

- Any numbers intended as counts should be suffixes and should be two digits.

    There may be more than 10 of an element but probably not more than 100.)

Specific elements are named as follows:

- Ballot Styles: `ballot-style-{name}-{gpunit}`
- Candidates: `candidate-{firstname}-{lastname}`
- Contests: `contest-{office}-{location}`
- Contest selections: `contest-{office}--selection-{name}`
- Election: `election-{name}-{gpunit}`
- GP / Reporting Units: `{name}-{gpunit}`

#### External IDs

External IDs are defined between record files and can be used to identify a entity shared between CVRs and EDFs, or from multiple jurisdictions (such as the precincts of Gadget County).

The format of external IDs is specific to a jurisdiction. In the case of Gadget County they are defined to be exactly the same as internal IDs for the sake of both simplicity and readability.

- For EDFs, in both XML and JSON they are defined in the record class `ExternalIdentifier`.
- CVRs don't create External IDs, they use the external IDs in EDF.

Alternatives that could be used:

- A variant on [Open Civic Data Identifiers](https://opencivicdata.readthedocs.io/en/latest/ocdids.html). Real OCD IDs have to be registered, so it would be important to use a top-level path element that was *not* `ocd-*` (e.g. `demo-*`)
    - Pseudo division IDs look like geographical paths. Note: `country:hb` refers to Hanna-Barbera, `state:js` refers to the Jetsons.


        ```
            demo-division/country:hb/state:js/county:gadget
            demo-division/country:hb/state:js/county:gadget/precinct:bedrock
            ...
        ```

    - Pseudo organization IDs are UUIDs. Real OCDID organization IDs use UUID1 but here UUID5 parameterized by the project and the jurisdiction is clearer.

        ```
            demo-organization/{UUID5("Trust the Vote/Jetsons", "Gadget County")}
            demo-organization/{UUID5("Trust the Vote/Jetsons", "Bedrock Precinct")}
            ...
        ```

### CVRs / Cast Vote Records

#### CVR Notes

- The CVR Report (`jetsons_main_cvr.yaml`) specifies the `Election` but not the cast vote records (`CVR` elements). The former is what's used to describe the contents of the ballot. The latter are meaningful only for an already marked ballot. The ballot marking app will read in the former and generate the latter.

Election specifics:

- The Orbit City mayoral election:
    - Is a `CandidateContest`.
    - Has a `VoteVariation` of `plurality`.
        
        With only two candidates it's equivalent to a majority contest. (There's no way to tell the difference without provisions for resolving the race if no one gets a majority.) 
        
        Technically both kinds of contests are `n-of-m` where `n` and `m` are both 1. But they are simpler to track than `n-of-m`: for instance `VotesAllowed` and `NumberElected` are both 1, and do not need to be explicit.

- The SpacePort Board election:
    - Is a `CandidateContest`.
    - Has a `VoteVariation` of `n-of-m`: 3 candidates for 2 slots. Voters select 2 and the top 2 vote getters fill the seats.
        - `VotesAllowed` is maximum number of candidates a voter can select.
        - `NumberElected` is the total number of seats to fill.

            `VotesAllowed` is needed to produce the CVRs correctly, `NumberElected` is there for clarity. There's nothing in the specification that requires these two properties to be the same, but in this contest there's no other interpretation, so the latter could be left out.

- The county ballot measure:
    - Is a `BallotMeasureContest`.
    - Has a `VoteVariation` of `plurality`.
        
        NIST SP-1500-103 Example 2 has two contests with ballot measures, but it treats them as `CandidateContest`s (which seems strange).

Record classes:

- `ContestSelection`s:
    - `CandidateIds` should be included even though they are redundant for `plurality` contests.
    - Every write-in slot needs a `ContestSelection` with `IsWriteIn = true`.
        - There should be as many write-in slots as there are `VotesAllowed` in the contest.

- `ElectionId` is the `GpUnit` for the entire election, so it's for the county.

- There's one `GpUnit` for each precinct.

- `ReportingDevice` and `ReportGeneratingIds` are required properties. The latter is references to the former. There are no constraints in the CVR specification about what information is needed in most of the properties of a `ReportingDevice`. It's recommended to be thorough and define the others because it allows identifying multiple versions of CVRs in development. The properties are mostly self-evident for hardware devices. For software devices, such as the ballot marking mobile app the following are suggested:

    - `Application` is the name of the ballot-marking software.
    - `Manufacturer` is "Trust the Vote".
    - `Model` is the software version number.
        - For tagged versions it's recommended but not required to follow either [semantic versioning](https://semver.org) or [calendar versioning](https://calver.org).
        - For untagged or work-in-progress versions build numbers or commit/revision hashes combined with the date could work. E.g.
            - `v0.1.2`
            - `2021.05.27`
            - `build 1027`
            - `git:abcdef01+2021-06-01`
    - `SerialNumber` is not required but if it use the MAC address of the phone or computer that generates the ballot.

- `ReportType` for a ballot generating/marking device is always `originating-device-export`. A scanner would be the same. Other types are only used by processing stages used in adjudication and tabulation - out of scope for the ABC.

- `Version` is always `1.0.0`. (It's an enumeration which currently only has one value.)

#### CVR Questions

- How are the roles of non-partisans listed?

    The `ElectionResults.Person` element of an EDF can store this information so it can be made available on the ballot. But there is no property in a CVR's `Election.Candidate` that allows for non-party related data to be attached.

- How should the `GpUnit` for the county be defined? `ReportingType` doesn't have `'county'` as a value.

    Use:

    ```
        {
            "Type": "other",
            "OtherType": "county"
        }
    ```

    Arguably the spec needs updating.

### EDFs / Election Report Results

*Note*: Election Report Results is the spec. But the same format has a pre-election use case "to specify informaton needed for ballot generation before the election". In this case it's called an "Election Definition File" or "EDF".

#### EDF Notes

- EDFs allow specifying the content of `BallotStyle`s which CVRs do not. The CVR depends on the EDF for the ballot styles and needs to refer to them using the externl ID created in the EDF.

- There's a lot of data overlap between the CVR and the EDF: `Candidate`s, `Contest`s, `GPUnit`s and several other aspects need to be kept in sync. Ideally this is automated, but these examples are still hand-generated.

- It can be really hard to tell if `BallotStyle.OrderedContent` and headers are nested properly. This may requiring tinkering as you modify the ballot layout.
Note that:
    - Each `OrderedContent` describes a sub-section of a section on the ballot, and each `OrderedHeader` describes a header for the sections below it.
    - There usually aren't more than a couple of nestings. The samples nest to two levels.
    - **TODO** It would be useful to have JQ and XPath scripts to display the layout clearly.

- An EDF `Contest.ElectionDistrictId` has to be the `GpUnit` of the entire county. It can't be any of the individual precincts because a contest can occur in multiple precincts.

- EDFs are more complex than CVRs. For JSON a number of fields have the data type `InternationalizedText` which stores information about the language text is presented in.

- Partisan affiliation and non-partisan roles:
    - Information on candidates in a *partisan* race should be added to `Party` record and referenced with `Candidate.PartyId`.
    - Information on candidates in a *non-partisan* race should be added to `Person` record and referenced with `Candidate.PersonId`.
        - This data can get quite expansive depending on the ballot requirements. The Jetsons ballot is very minimal requiring just `FullName` and `Profession`.

- EDF `ReportingDevice`s differ from their CVR counterparts:
    - A CVR has the concept of a `ReportingDevice` for the whole `ElectionReport` as well as devices specific to a `GpUnit`. An EDF treats a `ReportingDevice` as another `GpUnit` entry.
    - Most of the properties are nested under the field `DeviceClass`, except for `SerialNumber`.
    - EDF has an explicit `Type` field to identify the device type, which CVR does not have.
        - The `ReportingDevice.DeviceClass.Type` of a ballot marking system is `bmd`.

#### EDF Questions

- The information about a race is stored in both the `Contest` and the `Header` displayed in the `BallotStyle`. This is redundant but it's not obvious that one can infer the `Header` from the `Contest.Name`, and the `Header` is the correct place for display. Is this correct?
