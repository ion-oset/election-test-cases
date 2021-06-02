---
title: Notes on the Jetsons Cast Vote Records
---

Notes are about the design choices for the CVRs in `data/cvr/samples/jetsons.`

### Status

CVRs are done and ready for review.

Still left to do:

- Add ballot styles for each of the ballot types from Election Results Reporting.

### Notes

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
    - Contest selections: `contest-{office}/selection-{name}`

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
    - It's not clear how to interpret `SerialNumber`. Perhaps use the MAC address of the phone or computer that generates the ballot?

- There's one `GpUnit` for each precinct.

- `ElectionId` needs to be a `GpUnit` but it can't be any one of the precincts. Presumably it needs to be entire county, so there's also `GpUnit` for the county.

- `ReportType` for a ballot generating/marking device is always `originating-device-export`. A scanner would be the same. Other types are only used by processing stages used in adjudication and tabulation - out of scope for the ABC.

- `Version` is always `1.0.0`. (It's an enumeration which currently only has one value.)

### Questions

- How are the roles of non-partisans listed?

    There's no property attached to `Candidate` that allows for non-party related data to be attached.

- Is Orbit City mayor a majority or plurality race?

    With only two candidates it doesn't matter, this is for correctness only.

- `CandidateIds` is redundant for plurarity races. Should they be listed anyway?

- Should there be a `GpUnit` for the county?

- Does the ballot measure have `VotingVariation` of'approval'?

- What are appropriate values for 'ReportingDevice.SerialNumber'?
