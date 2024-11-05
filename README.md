# Overview

A modest set of [dev container Features](https://containers.dev/implementors/features/) features useful for authoring and testing Nextflow pipelines

## Features

This repository contains a _collection_ of two Features - `nextflow` and `nf-test`. Each sub-section below shows a sample `devcontainer.json` alongside example usage of the Feature. At present, there are no options available for the `nextflow` feature, so the empty object is provided after the feature ID:

### `nextflow`

Installs [Nextflow](https://www.nextflow.io/) and prerequisites (Java)

```jsonc
{
    "image": "mcr.microsoft.com/devcontainers/base:ubuntu",
    "features": {
        "ghcr.io/robsyme/features/nextflow:1": {}
    }
}
```

```bash
$ nextflow -version

      N E X T F L O W
      version 22.10.4 build 5836
      created 09-12-2022 09:58 UTC (04:58 EDT)
      cite doi:10.1038/nbt.3820
      http://nextflow.io
```

### `nf-test`

Installs [nf-test](https://code.askimed.com/nf-test/)

```jsonc
{
    "image": "mcr.microsoft.com/devcontainers/base:ubuntu",
    "features": {
        "ghcr.io/robsyme/features/nf-test:1": {}
    }
}
```

```bash
$ nf-test version

🚀 nf-test 0.7.1
https://code.askimed.com/nf-test
(c) 2021 - 2022 Lukas Forer and Sebastian Schoenherr

Nextflow Runtime:

      N E X T F L O W
      version 22.10.4 build 5836
      created 09-12-2022 09:58 UTC (04:58 EDT)
      cite doi:10.1038/nbt.3820
      http://nextflow.io
```
