# Provenance

## Repository baseline

Strap Bender began from repository commit:

```text
3f8cf6e — Initial commit
```

The baseline contained only the Unlicense file. Batch 001 adds design documentation and no executable OpenSCAD source.

## Framework lineage

The project adopts organizational and lifecycle lessons from:

- `git64bit/grid-stack`;
- `git64bit/polygon-stack`.

Relevant inherited principles include:

- self-contained repository;
- focused executable Customizer workbenches;
- stable `wb_*` values resolved through defaults;
- indexed records with named constructors and index constants;
- exact-name registry lookup;
- validation, reporting, mathematics, paths, and rendering kept separate;
- mutable Laboratory presets;
- immutable Catalog objects after physical acceptance;
- direct-open F5 contract tests;
- bounded delta-ZIP development and commit reconciliation.

## Independence

Strap Bender will not include, use, import, or otherwise depend at runtime on files from Grid Stack or Polygon Stack. Generic infrastructure may be copied, renamed, reduced, and maintained as native Strap Bender source.

BOSL2 remains an external implementation candidate. No dependency decision is made by Batch 001.

## Domain originality

The bend-program grammar, line-and-arc normalization, target/fixture separation, long-pattern scheduling, PET forming calibration, and fixture planning are native Strap Bender concerns. Geometry code from the stack projects is not assumed to solve this domain.
