#!/bin/bash
set -euo pipefail

# This script is automatically run when a new agent workspace is created
# It ensures the patching system is bootstrapped in the new workspace

# Get the directory containing this script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../../../../.." && pwd)"

# The bootstrap script has already copied all patches to the new workspace
# and the fork.sh script has already been patched by the bootstrap process

echo "Patching system bootstrapped in new workspace"
