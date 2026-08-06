# Development workflow

1. Discuss and accept one bounded change.
2. Implement only that batch.
3. Deliver new and changed complete files in a delta ZIP.
4. The user uploads the complete files through GitHub and tests them in OpenSCAD when executable files exist.
5. The user commits the accepted batch and provides the commit SHA.
6. Reconcile the repository against that SHA before continuing.

The user is not required to edit source files. Deletions, when required, are supplied in a separate deletion list.

A failed batch is not a base for further work. Recover to the last accepted commit before implementing another change.

Design discussion remains separate from implementation. No new geometry family, record schema, fixture topology, or physical-process assumption is introduced merely because it appears on the roadmap.
