# Trust the Vote ABC Schemas

## Setup/Installation

### Pre-requisites

To rebuild the data and/or you will need the following pre-requisites. Installation is dependent on your operating system.

- GNU Make >= 4 (for building everything)
- Python >= 3.6 (for building and validating samples)
- Pandoc >= 2.5 (for generating HTML notes)
- Node.js (for generating HTML annotations)

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

    - Docco is needed to build the annotated CVR samples.

        ```
            npm --install docco
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
