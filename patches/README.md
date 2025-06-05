# SkogAI Patches

This directory contains patches and enhancements for SkogAI agents that can be applied to existing installations.

## System Architecture

The SkogAI patching system extends gptme-based agents with additional functionality while maintaining compatibility with the upstream project. The system works as follows:

1. **Bootstrap Process**: The bootstrap patch modifies fork.sh to propagate patches to new agent workspaces
2. **Patch Organization**: Patches are stored in gptme-contrib/patches/skogai/{patch-name}/
3. **Auto-Apply**: Patches with auto-apply.sh scripts are automatically applied to new workspaces
4. **Self-Propagation**: All patches are copied to new agent workspaces during forking

### Directory Structure

```
gptme-contrib/
└── patches/
    ├── README.md (this file)
    └── skogai/
        └── {patch-name}/
            ├── {patch-name}.sh (main patch script)
            └── auto-apply.sh (optional, runs automatically in new workspaces)
```

### Patch Lifecycle

1. **Development**: Patches are initially developed in skogai-contrib for testing
2. **Bootstrap**: The bootstrap patch copies patches to gptme-contrib
3. **Propagation**: When fork.sh runs, patches are copied to the new workspace
4. **Auto-Apply**: Any auto-apply.sh scripts run in the new workspace

## Available Patches

### Patching Bootstrap (v0.1)
The foundation patch that enables the patching system.

### Context System Patch (v0.1)
Enhanced context management for agent workspaces.

## Usage

To apply a patch:

```bash
./gptme-contrib/patches/skogai/0.1-patching-bootstrap/0.1-patching-bootstrap.sh
```

To run tests:

```bash
./skogai-contrib/run-tests.sh
```

