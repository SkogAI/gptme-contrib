#!/usr/bin/env bash
git show-ref --verify --quiet refs/heads/feature/skogai3 || git branch feature/skogai3
git-flow feature finish skogai3
rm -rf ./b

