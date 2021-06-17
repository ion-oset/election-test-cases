---
title: Notes on the Jetsons Cast Vote Records
---

Notes are about the design choices for the CVRs in `data/cvr/samples/jetsons.`

### Status

CVRs are done and ready for review.

Still left to do:

- Add ballot styles for each of the ballot types from Election Results Reporting.

### CVRs / Cast Vote Records

#### CVR Notes

- The CVR Report (`jetsons.yaml`) specifies the `Election` but not the cast vote records (`CVR` elements). The former is what's used to describe the contents of the ballot. The latter are meaningful only for an already marked ballot. The ballot marking app will read in the former and generate the latter.

- The Orbit City mayoral election:
    - Is a `Candidate Contest`
    - Is either a `majority` or a `plurality` contest. With only two candidates they are equivalent. There's no way to tell the difference without provisions for resolving the race if no one gets a majority.
        
        Technically both kinds of contests are `n-of-m` where `n` and `m` are both 1. But they are simpler to track than the other kinds of contests. for instance `VotesAllowed` and `NumberElected` are both 1, and are not explicit.

- The SpacePort Board election:
    - Is a `Candidate Contest`
    - Is an `n-of-m` contest: 3 candidates for 2 slots. Voters select 2 and the top 2 vote getters fill the seats.
        - `VotesAllowed` is maximum number of candidates a voter can select.
        - `NumberElected` is the total number of seats to fill.

            `VotesAllowed` is needed to produce the CVRs correctly, `NumberElected` is there for clarity. There's nothing in the specification that requires these two properties to be the same, but in this contest there's no other interpretation, so the latter could be left out.

- The county ballot measure:
    - Is a `BallotMeasureContest`
    - Is _presumably_ an `approval` contest? There's no description of how to handle this in the specification.
        
        NIST SP-1500-103 Example 2 has two contests with ballot measures, but it treats them as `CandidateContest`s which seems strange.

- IDs are named as follows:
    - Candidates: `candidate-{firstname}-{lastname}`
    - Contests: `contest-{office}-{location}`
    - Contest selections: `contest-{office}--selection-{name}`

- Every write-in slot needs a `ContestSelection` with `IsWriteIn = true`.
  - There should be as many slots as there are `VotesAllowed` in the contest.

- `ReportingDevice` and `ReportGeneratingIds` are required properties. The latter is references to the former. There are no constraints in the CVR specification about what information is needed in most of the properties of a `ReportingDevice`. The only ones required are `@type` and `@id`. If we are being thorough and define the others the properties are mostly self-evident for hardware devices. For software devices, such as the ballot marking mobile app the following are suggested:
    - `Application` is the name of the software.
    - `Manufacturer` is "Trust the Vote".
    - `Model` is the software version number. For tagged versions would follow either [semantic versioning](https://semver.org) or [calendar versioning](https://calver.org). For untagged or work-in-progress versions build numbers or commit/revision hashes combined with the date could work.
    e.g.
        - `v0.1.2`
        - `2021.05.27`
        - `build 1027`
        - `git:abcdef01+2021-06-01`
    - `SerialNumber` is not required but if it use the MAC address of the phone or computer that generates the ballot.

- There's one `GpUnit` for each precinct.

- `ElectionId` needs to be a `GpUnit` but it can't be any one of the precincts. Presumably it needs to be entire county, so there's also `GpUnit` for the county.

- `ReportType` for a ballot generating/marking device is always `originating-device-export`. A scanner would be the same. Other types are only used by processing stages used in adjudication and tabulation - out of scope for the ABC.

- `Version` is always `1.0.0`. (It's an enumeration which currently only has one value.)

#### CVR Questions

- How are the roles of non-partisans listed?

    There's no property attached to `Candidate` that allows for non-party related data to be attached.

- Is Orbit City mayor a majority or plurality race?

    Plurality.

- `CandidateIds` is redundant for plurality races. Should they be listed anyway?

    Yes.

- Should there be a `GpUnit` for the county?

    Yes. Since `ReportingType` doesn't have `'county'` as a value, use:

    ```
        {
            "Type": "other",
            "OtherType": "county"
        }
    ```

- Does the ballot measure have `VotingVariation` of 'approval'?

    No, the `VotingVariation` is `plurality`.

- What are appropriate values for 'ReportingDevice.SerialNumber'?

    MAC address of device that generated the report.

### EDFs / Election Report Results

*Note*: Election Report Results is the spec. But we use the same format for its pre-election use case "to specify informaton needed for ballot generation before the election". In this case it's called an "Election Definition File" or "EDF".

#### EDF Notes

- All the EDF changes are because EDFs allow specifying the content of `BallotStyle`s which CVRs do not. This means the CVR depends on the EDF for the ballot styles and needs to refer to them using the ID created in the EDF.
    - Because of this EDF `BallotStyle` IDs are defined in `ExternalIdentifier`s and not `@id`, and have to follow the rules for external identifiers (which are not defined in the ERR specification).
    - Several options exist according to the spec using [Open Civic Data Identifiers](https://opencivicdata.readthedocs.io/en/latest/ocdids.html)
        - A (pseudo/invalid) division ID, where the divisions are as fictional as the Jetsons jurisdiction is:

            ```
                ocd-division/country:hb/state:js/county:gadget
                ocd-division/country:hb/state:js/county:gadget/precinct:bedrock
                ...
            ```

        where `country:hb` refers to Hanna-Barbera, and `state:js` refers to the Jetsons.

        *Note*: This isn't a valid jurisdiction ID because it isn't registered but it gets the point across.

        - An organization ID, which uses UUIDs to set the prefix. The spec calls for UUID1, but we can use UUID5 parameterized by the project and the jurisdiction:

            ```
                ocd-organization/{UUID5("Trust the Vote/Jetsons", "Gadget County")}
                ocd-organization/{UUID5("Trust the Vote/Jetsons", "Bedrock Precinct")}
                ...
            ```

    - A simpler answer for the time being is to name them like internal IDs with an obvious namespace prefix (`jetsons:ballot-style-{jurisdiction}`):

        ```
            jetsons:ballot-style-gadget-county
            jetsons:ballot-style-bedrock-precinct
            ...
        ```

- There's a lot of data overlap between the CVR and the EDF: `Candidate`s, `Contest`s, `GPUnit`s and several other aspects need to be kept in sync. Ideally this is automated, but these examples are still hand-generated.

- It can be really hard to tell if `BallotStyle` `OrderedContent` and headers are nested properly. This may requiring tinkering as you modify the ballot layout.
Note that:
    - Each `OrderedContent` describes a sub-section of a section on the ballot, and each `OrderedHeader` describes a header for the sections below it.
    - There usually aren't more than a couple of nestings. The samples nest to two levels.
    - **TODO** There are `jq` scripts that can be used to display the layout clearly.

- The `ElectionDistrictId` of an EDF `Contest`s is the GpUnit of the entire county. It can't be any of the individual precincts because a contest can occur in multiple precincts.

- EDFs are more complex than CVRs. In particular a number of fields have the data type `InternationalizedText` which stores information about the language text is presented in.

- EDF `ReportingDevice`s differ from their CVR counterparts:
    - A CVR has the concept of a `ReportingDevice` for the whole `ElectionReport` as well as devices specific to a `GpUnit`. An EDF treats a `ReportingDevice` as another `GpUnit` entry.
    - Most of the properties are nested under the field `DeviceClass`, except for `SerialNumber`.
    - EDF has an explicit `Type` field to identify the device type, which CVR does not have.


#### EDF Questions

- Currently the information about a race is stored in both the `Contest` and the `Header` displayed in the `BallotStyle`. This is redundant but it's not obvious that one can infer the `Header` from the `Contest.Name`, and the `Header` is the correct place for display. Is this correct?

- `BallotStyle` needs an `ExternalIdentifier` to give it an ID that can be referred to outside of the EDF (e.g. in the CVR).

- Is the `ReportingDevice.DeviceClass.Type` of our ballot marking system `bmd`?
