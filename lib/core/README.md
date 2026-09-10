
---

# `lib/core/README.md`

```markdown
# Core Data & Integration Layer

## Overview

The **Core module** contains shared data structures and integration components used by different modules of the application.

It provides a common interface for exchanging game-performance information between:

* Cognitive games
* AI / adaptive personalization
* Caregiver monitoring
* Performance analytics

The core layer prevents individual modules from becoming tightly coupled to each other's internal implementation.

---

## Purpose

Different cognitive games produce different result objects.

For example:

```text
MemoryGameResult
AttentionGameResult