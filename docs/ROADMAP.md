# Development roadmap

The roadmap defines dependency order, not permission to implement all phases at once. Each phase is divided into bounded batches and reconciled against the user's commit SHA before continuing.

## Phase 0 — design contract

- establish project scope;
- define bend-program semantics;
- define geometry and radius conventions;
- define record boundaries;
- identify unresolved physical and fixture decisions.

Batch 001 covers this phase only.

## Phase 1 — analytical path kernel

- create the self-contained framework skeleton;
- implement native records and accessors;
- compile explicit straight and bend commands;
- calculate exact poses, arc centers, stations, bounds, and nominal length;
- render a diagnostic analytical reference path;
- add direct-open F5 contract tests.

No production fixture is required for this phase.

Implementation status:

- Corrected Batch 002 covers the framework skeleton, source records, registries, validation, reporting, and arbitrary-length program routing.
- Batch 003 covers explicit straight/bend compilation, exact poses, arc centers, stations, finished-inside-edge reference length, exact XY bounds, closure validation, and source provenance.
- Batch 004 adds bounded-error analytical sampling, sampled-path validation and reporting, and a thin diagnostic rendering of the finished-inside-edge reference path with tangent-point markers.
- Phase 1 is complete at the analytical and diagnostic-preview boundary. Strap solids, material behavior, and production fixtures remain later phases.

## Phase 2 — polygon front end

- ordered vertex input;
- convex and concave turn classification;
- per-corner radius schedules;
- tangent setback and feasibility validation;
- regular triangle, square, pentagon, and higher-sided generator;
- equivalence tests against explicit bend programs.

Implementation status:
- Batch 005 covers named closed vertex-polygon records, common or explicit per-corner radii, orientation-independent convex/concave classification, exact circular tangent setbacks, retained-edge feasibility, normalized bend-program generation, source edge/vertex provenance, a diagnostic workbench, and explicit-program equivalence testing.
- Batch 006 covers regular-polygon source and compilation records, side-length/circumradius/apothem authorities, counter-clockwise sharp-vertex generation, common or explicit radius propagation, a scalar Customizer workbench, and triangle/square/pentagon contracts.
- Batch 007 adds native constant, explicit, periodic, and every-nth numeric schedules; routes them through both polygon front ends; adds a schedule-capable Regular Polygon Customizer; and verifies the 1.6/1.6/5 mm every-third case.
- Arbitrary formula schedules and polygon self-intersection diagnostics remain later bounded work.

## Phase 3 — patterns and long paths

- named pattern blocks;
- repetition instances;
- reuse Batch 007 constant, explicit, periodic, and every-nth schedules;
- long-wave workbench;
- every-third-wave radius case;
- performance and sampling tests at 10–20 foot analytical lengths.

Implementation status:
- Batch 008 adds reusable pattern-element and pattern-block records, compact repetition instances, per-repetition parameter assignments, exact expansion to the existing bend-program route, and repetition/local-element provenance.
- Batch 008 adds the `THREE_SEGMENT_S_WAVE` topology and Wave Pattern Customizer. Constant, periodic, or exact arrays may independently control the three straight families. Radius schedules resolve once per wave, so waves 3, 6, 9, and so on can assign 5 mm to all local bends while other waves use 1.6 mm.
- The 30-wave reference expands to 180 commands and approximately 15.6 feet along the finished-inside-edge analytical reference. Its contract also exercises bounded diagnostic sampling.
- Broader pattern libraries, very-high-repetition stress profiling, and fixture segmentation remain later bounded work.

## Phase 4 — strap and forming calibration

- exact ULINE strap record;
- radius calibration fixture or coupons;
- measurement records;
- target-to-tool radius mapping;
- neutral-axis and cut-length correction evaluation.

Implementation status:
- Batch 009 adds a versioned physical strap product record, exact-name registry, validation, reporting, and report-only Strap Profile workbench for confirmed ULINE S-1655 black PET polyester strapping. Vendor nominal values remain distinct from future measured and calibration data.
- Batch 010 adds the radius-observation evidence record, strap-material provenance validation, direct springback delta/ratio reporting, and exact-name support. Contract values are synthetic and are not registered as physical calibration evidence.
- Batch 011 adds the first printable calibration tooling: open inside-form coupons with explicit designed tool radius, signed bend angle, tangent legs, material-linked form height, base geometry, and bounded chordal tool-surface tessellation. R1.6 and R5 reference coupons remain experimental Laboratory geometry.
- Batch 012 adds a guarded Radius Observation workbench and a calibration-trial provenance wrapper. A ready trial derives material, signed bend angle, and designed tool radius from one exact named coupon, embeds the user-entered physical observation, and validates that the observation remains consistent with the source tool. No physical observation is registered by the batch.
- Batch 013 adds the persistent Laboratory calibration-trial registry, unique-name/full-provenance registry validation, and a report-only Calibration Evidence audit workbench. The initial registry is deliberately empty; transient or synthetic values are never promoted automatically.
- Real measurement population, target-to-tool mapping, neutral-axis evaluation, and cut-length correction remain later bounded work.

## Phase 5 — first fixture family

- select the physical fixture topology;
- implement target-path-to-fixture planning;
- strap clearance and retention;
- print-envelope and segmentation rules;
- component labels and assembly datums;
- physical tests on small shapes.

## Phase 6 — long-form fixture strategy

- tiled, modular, or sequential long-path tooling;
- cumulative station control;
- repeated-wave assembly and verification;
- component manifests and setup instructions.

## Phase 7 — accepted objects and Catalog

- versioned public API;
- immutable shape and fixture recipes;
- exact strap and calibration provenance;
- physically accepted Catalog registrations;
- associated slicer and manufacturing records.
