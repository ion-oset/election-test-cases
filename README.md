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

If you want to look at the CVR data samples you should not need to build anything.

If you want to add to or update the samples and build them see below.

## Development

### Pre-requisites

To rebuild the data and/or you will need some of the following tools. You don't necessarily need all of them. How you install them is OS dependent and up to you.

- GNU Make >= 4
- Pandoc >= 2.5 (for building documentation)
- Python >= 3.6 (for tools, and for scripts)
- Node.js (optional)

#### Python

1. Make sure you are on a system with Python >=3.6 installed.
2. Setup a Python virtual environment:

    ```
    python -m virtualenv .venv
    source .venv/bin/activate
    ```

3. Install the required packages:

    ```
    python -m pip install -r pip.requirements.txt
    ```


#### Node.js

1. Make sure you have Node.js installed.
2. Install the required packages.

    ```
    npm -i package.json
    ```

### Generating documents and samples

Use the Makefile to drive all tasks and tests.

#### Top-level Actions

To get a list of targets:

    ```
    make help
    ```

To build everything:

    ```
    make build
    ```

To clean everything:

    ```
    make clean
    ```

#### Building Samples

To build our hand-written samples:

    ```
    make build-samples
    ```

To build the NIST samples:

    ```
    make convert-samples
    ```

#### Validation

1. To validate all CVR files:

    ```
    make validate
    ```

2. To validate only JSON CVR files:

    ```
    make validate-cvr-json
    ```

3. To validate only XML CVR files:

    ```
    make validate-cvr-xml
    ```
