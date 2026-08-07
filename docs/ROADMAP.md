# Development roadmap

The roadmap defines dependency order, not permission to implement all phases at once. Each phase is divided into bounded batches and reconciled against the user's commit SHA before continuing.

## Development priority

Application completion is the primary development dependency. Pending coupon tests do not block Phases 5–7. Until empirical PET evidence is available, fixture output may use explicitly nominal, uncompensated geometry and must identify that status without claiming a predicted relaxed radius. Calibration fitting and physical corrections are revisited after the application capabilities are complete.

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
- Batch 014 adds nonadjacent sharp-source edge-intersection detection and reporting. Detection is diagnostic only; it does not resolve the later fixture-policy decision about whether any self-crossing target may be supported.
- Batch 020 adds normalized analytical line/arc self-intersection and near-intersection diagnostics after every authoring front end reaches the shared analytical path. Adjacent continuity neighbors are excluded; nonlocal pairs are bounds-prefiltered and exact line/line, line/arc, and arc/arc distances are evaluated for candidates within the configured threshold.
- Arbitrary formula schedules remain later bounded work.

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
- Batch 021 adds the application-level nominal developed/cut-length route. It supports explicit mid-thickness or custom-fraction development assumptions plus separately named end, overlap, and joining allowances. Results remain `nominal_uncalibrated`; a closed path with no selected seam policy is marked `nominal_uncalibrated_closure_unassigned`.
- Real measurement population, target-to-tool mapping, calibrated neutral-axis evaluation, and empirical cut-length correction remain later bounded refinements. They do not block the remaining application architecture.

## Phase 5 — first fixture family

- select the physical fixture topology;
- implement target-path-to-fixture planning;
- strap clearance and retention;
- print-envelope and segmentation rules;
- component labels and assembly datums;
- physical tests on small shapes.

Implementation status:
- Batch 015 selects the first software fixture family: a full-form open-top base with one circular inside-form post for every analytical arc.
- Target centers, signed turns, target radii, global stations, and target entry/exit tangent points are copied from exact analytical primitives with source-command provenance. Separate tool-center and tool-tangent fields are retained; nominal mode makes them equal to the target datums.
- The first radius policy is `nominal_target`: tool radius equals requested finished inside radius and the plan status is always `experimental_uncompensated`. This policy exists so fixture software can be completed before empirical springback fitting.
- Base bounds cover the exact analytical path and complete post circles plus configurable margin. Configured print-envelope width/depth are asserting constraints.
- Post height is validated against nominal strap width, and post circular tessellation is bounded by both chord error and maximum angular step.
- Batch 016 adds exact post/post gap analysis and exact post/nonlocal-path clearance analysis. Local source arcs and their tangent neighbors are intentionally excluded. Unsafe full-form fixtures are rejected before rendering.
- Batch 017 adds optional `arc_follower` retention. Each follower is an open-top annular wall spanning exactly one signed bend sweep. Its nominal slot width is strap thickness plus configured clearance; wall thickness is explicit. Follower bounds are included in the base plan and retention-mode clearance uses a conservative full-circle envelope.
- Phase 5 fixture planning now feeds the Phase 6 segmentation and setup-aid layers; empirical physical refinement remains later.

## Phase 6 — long-form fixture strategy

- tiled, modular, or sequential long-path tooling;
- cumulative station control;
- repeated-wave assembly and verification;
- component manifests and setup instructions.

Implementation status:
- Batch 018 implements the first long-form strategy as deterministic sequential station modules. `auto` layout keeps a full-form fixture when it fits and otherwise partitions at exact stations located inside analytical straight primitives.
- The greedy partitioner chooses the farthest available straight-region split that keeps each component inside the configured XY print envelope. Long individual straight primitives receive additional deterministic internal candidates so segmentation is not limited to one midpoint per line.
- Every component preserves a stable zero-padded ID, complete station interval, exact start/end XY and heading datums, source-command identity, assigned bend stations, global base bounds, and local print-origin datum coordinates. No analytical bend or arc follower is split between components.
- The first strategy is explicitly sequential rather than a physical butt-jointed tile system. Component boundaries and margins may overlap in global XY coverage; the station/tangent manifest is the setup authority.
- Batch 019 adds physical sequential setup aids without changing the station partition: matching keyed registration-hole pairs are derived from exact shared split poses, and recessed zero-padded component marks are rendered in protected base-margin corners. Registration geometry is validated against the component base and complete analytical strap path.
- A true simultaneously assembled tiled/rail-connected fixture remains optional later work; Batch 019 registration is for sequential transfer/common-board setup and does not turn overlapping components into butt-jointed tiles.

## Phase 7 — accepted objects and Catalog

- versioned public API;
- immutable shape and fixture recipes;
- exact strap and calibration provenance;
- physically accepted Catalog registrations;
- associated slicer and manufacturing records.
