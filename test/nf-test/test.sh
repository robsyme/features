#!/bin/bash

# This test file will be executed against an auto-generated devcontainer.json that
# includes the 'color' feature with no options.
#
# Eg:
# {
#    "image": "<..some-base-image...>",
#    "features": {
#      "color": {}
#    }
# }
#
# Thus, the value of all options, 
# will fall back to the default value in the feature's 'devcontainer-feature.json'
# For the 'color' feature, that means the default favorite color is 'red'.
# 
# This test can be run with the following command:
#
#    devcontainer features test \ 
#               --features color \
#               --base-image mcr.microsoft.com/devcontainers/base:ubuntu .

set -e

# Optional: Import test library bundled with the devcontainer CLI
# Provides the 'check' and 'reportResults' commands.
source dev-container-features-test-lib

# Feature-specific tests
# The 'check' command comes from the dev-container-features-test-lib.
check "version" bash -c "nf-test version | grep askimed"

# Report result
# If any of the checks above exited with a non-zero exit code, the test will fail.
reportResults