#!/bin/bash
set -euo pipefail

# Get the directory containing this script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../../../.." && pwd)"
PATCH_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
SKOGAI_CONTRIB_DIR="$(cd "$SCRIPT_DIR/../../.." && pwd)"

echo "Bootstrapping SkogAI patching system..."

# Function to patch the fork.sh script
patch_fork_script() {
    local fork_script="$1"
    
    # Check if the script already has our patch
    if grep -q "# SkogAI Patch System" "$fork_script"; then
        echo "Patch already applied to $fork_script"
        return 0
    fi
    
    echo "Patching $fork_script..."
    
    # Find the line before the final echo message
    local insert_line=$(grep -n "echo \"" "$fork_script" | tail -1 | cut -d: -f1)
    insert_line=$((insert_line - 1))
    
    # Create a temporary file with our patch
    local temp_file=$(mktemp)
    head -n "$insert_line" "$fork_script" > "$temp_file"
    
    # Add our patch code
    cat >> "$temp_file" << 'EOL'

# SkogAI Patch System
echo "Applying SkogAI patches to new agent workspace..."
if [ -d "${SOURCE_DIR}/gptme-contrib/patches" ]; then
    # Create patches directory in target
    mkdir -p "${TARGET_DIR}/gptme-contrib/patches"
    
    # Copy patches directory
    cp -r "${SOURCE_DIR}/gptme-contrib/patches/"* "${TARGET_DIR}/gptme-contrib/patches/"
    
    # Make patch scripts executable
    find "${TARGET_DIR}/gptme-contrib/patches" -type f -name "*.sh" -exec chmod +x {} \;
    
    # Apply any patches that should be automatically applied
    for patch_script in "${TARGET_DIR}/gptme-contrib/patches/skogai/"*/auto-apply.sh; do
        if [ -f "$patch_script" ]; then
            echo "Auto-applying patch: $patch_script"
            (cd "${TARGET_DIR}" && "$patch_script")
        fi
    done
fi
EOL
    
    # Add the rest of the original file
    tail -n +"$((insert_line + 1))" "$fork_script" >> "$temp_file"
    
    # Replace the original file
    mv "$temp_file" "$fork_script"
    chmod +x "$fork_script"
    
    echo "Successfully patched $fork_script"
}

# Copy patches from skogai-contrib to gptme-contrib
copy_patches_to_gptme_contrib() {
    echo "Copying patches from skogai-contrib to gptme-contrib..."
    
    # Create the directory structure in gptme-contrib
    mkdir -p "${REPO_ROOT}/gptme-contrib/patches/skogai/0.1-patching-bootstrap"
    
    # Copy the README.md
    cp "${SKOGAI_CONTRIB_DIR}/patches/README.md" "${REPO_ROOT}/gptme-contrib/patches/"
    
    # Copy the bootstrap scripts
    cp "${SCRIPT_DIR}/0.1-patching-bootstrap.sh" "${REPO_ROOT}/gptme-contrib/patches/skogai/0.1-patching-bootstrap/"
    cp "${SCRIPT_DIR}/auto-apply.sh" "${REPO_ROOT}/gptme-contrib/patches/skogai/0.1-patching-bootstrap/"
    
    # Make scripts executable
    chmod +x "${REPO_ROOT}/gptme-contrib/patches/skogai/0.1-patching-bootstrap/0.1-patching-bootstrap.sh"
    chmod +x "${REPO_ROOT}/gptme-contrib/patches/skogai/0.1-patching-bootstrap/auto-apply.sh"
    
    echo "Patches copied to gptme-contrib successfully"
}

# Copy patches to gptme-contrib
copy_patches_to_gptme_contrib

# Patch the fork.sh script in the current repo
patch_fork_script "$REPO_ROOT/fork.sh"

echo "SkogAI patching system has been bootstrapped!"
echo "You can now create auto-apply patches in gptme-contrib/patches/skogai/<patch-name>/auto-apply.sh"
echo "These patches will be automatically applied to new agent workspaces."
