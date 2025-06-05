# SkogAI Patches

This directory contains patches and enhancements for SkogAI agents that can be applied to existing installations.

## Patching System (v0.1)

The patching system allows for extending the functionality of gptme-based agents. When a patch is applied:

1. It modifies the fork.sh script in the current project
2. It ensures the patch is also applied to any new agent workspaces created with fork.sh
3. Patches are designed to be modular and non-destructive

### How It Works

The patching system works by injecting code into the fork.sh script that will:
- Apply patches to the current workspace
- Copy the patches to the new agent workspace
- Set up the new workspace to use the patches

This creates a self-propagating enhancement system that maintains compatibility with the upstream gptme project while adding SkogAI-specific features.

## Available Patches

### Context System Patch (v0.1)
Enhanced context management for agent workspaces.

## Usage

To apply a patch:

```bash
./gptme-contrib/patches/skogai/0.1-patching-bootstrap/0.1-patching-bootstrap.sh
```

This will bootstrap the patching system and allow for additional patches to be applied.

