# Validation contract

## Principle

Validation protects the authored contract. It must reject invalid records and report unsupported conditions rather than silently changing dimensions, radii, angles, repetition counts, or closure.

## Record validation

- required record type and schema version are present;
- numeric fields are finite;
- lengths and radii are positive where required;
- bend angle is nonzero and within the primitive domain;
- repetition counts are positive integers;
- value schedules are nonempty and resolve deterministically;
- exact-name registry lookup returns exactly one match.

## Value-schedule validation

- record type, schema version, kind, and label are valid;
- constant schedules contain exactly one finite value;
- explicit schedules contain exactly the consumer count;
- periodic schedules contain a nonempty finite cycle;
- every-nth schedules contain finite default and selected values;
- interval is a positive integer;
- first selected position is one-based and lies from 1 through interval;
- a radius consumer additionally requires every resolved value to be positive;
- resolution never changes the compact source record.

## Strap material validation

Batch 009 requires every strap product record to have:

- the exact strap-material record type and current schema version;
- non-empty stable name, manufacturer, product number, and material family;
- positive finite nominal width, thickness, break strength, and coil length;
- nominal thickness smaller than nominal width;
- non-empty color, surface, source title, source checked date, and source locator;
- recycled content between zero and one hundred percent;
- notes stored as a string.

The ULINE S-1655 contract also verifies reversible conversions for 5/8 inch width, .020 inch thickness, 750 lbf break strength, and 2,850 ft coil length. These checks validate vendor nominal identity only. They do not establish measured dimensions, forming temperature, springback, neutral-axis position, or cut length.

## Radius-observation validation

Batch 010 requires each physical bend observation to have:

- the exact radius-observation record type and current schema version;
- a non-empty observation name and specimen ID;
- exactly one referenced strap material in the supplied material registry;
- positive finite measured specimen width and thickness, with thickness smaller than width;
- a valid nonzero bend angle below 360 degrees;
- positive finite tool and measured finished inside radii;
- a recognized forming method and cooling-restraint state;
- finite recorded forming temperature;
- nonnegative dwell and post-release rest times;
- non-empty measurement method and measurement date;
- finite nonnegative stated measurement uncertainty;
- notes stored as a string.

Direct springback delta and radius ratios may be calculated from a valid observation. Those quantities do not establish an interpolation, regression, or target-to-tool compensation model.

## Radius-calibration coupon validation

Batch 011 requires each printable calibration coupon to have:

- the exact coupon record type and current schema version;
- a non-empty stable name and exactly one referenced strap material;
- positive finite designed tool radius, tangent lengths, form depth and height, base thickness, and base margin;
- a finite nonzero signed bend angle with magnitude no greater than 180 degrees;
- form height at least the referenced strap product's nominal width;
- positive tool-surface chord error smaller than the designed radius;
- a valid positive maximum angular facet step;
- a resolved circular-arc facet count whose ideal-circle sagitta does not exceed the requested chord-error bound;
- notes stored as a string.

These checks validate CAD geometry, not printer accuracy or PET behavior. A valid coupon still carries no claim about the relaxed finished radius.

## Calibration-trial validation

Batch 012 requires each coupon-linked calibration trial to have:

- the exact calibration-trial record type and current schema version;
- a non-empty stable trial name and source coupon name;
- one valid embedded radius observation;
- exactly one matching source coupon in the supplied coupon registry;
- observation strap material identical to the source coupon material;
- observation signed bend angle equal to the source coupon angle within the named angular tolerance;
- observation tool inside radius equal to the source coupon designed radius within the named position tolerance;
- notes stored as a string.

The Radius Observation workbench defaults to `Observation ready = false`. In that state the selected coupon is validated and reported, but no observation or calibration-trial evidence record is constructed. When `Observation ready = true`, a non-fatal completeness check reports all missing or invalid worksheet fields first. The strict evidence validators run only after that list is empty. Enabling the gate does not certify the values as physical truth.

## Persistent calibration-evidence registry

A persistent trial registry must:

- be a list of calibration-trial records;
- contain unique stable trial names;
- revalidate every trial against the active strap-material and coupon registries;
- never treat a transient Customizer-ready state as automatic persistence;
- remain empty rather than inventing measurements when no physical evidence has been supplied.

Synthetic contract fixtures may exercise registry validation locally but must not appear in the physical Laboratory calibration-trial registry.

## Pattern validation

- pattern blocks contain at least one valid local element;
- local element labels are nonempty and unique within the block;
- distance, angle, and radius parameter roles use disjoint names;
- repetition count is a positive integer;
- every required parameter is assigned exactly once and no extra parameter is accepted;
- each numeric source resolves to exactly one finite value per repetition;
- resolved straight distances and radii are positive;
- every local angle multiplier produces a valid nonzero bend below 360 degrees;
- expansion emits exactly `repetition count × local element count` commands;
- command source indexes remain contiguous;
- one provenance record exists for every expanded command.

Batch 008 resolves parameter values once per repetition. A local element may reuse that value, but expansion must not silently advance a schedule once per local bend.

## Ordered-path validation

- every command has a stable source index;
- no zero-length analytical primitive is emitted;
- consecutive primitives share the same endpoint within tolerance;
- line/arc transitions are tangent continuous;
- cumulative station increases monotonically;
- open paths retain two distinct free ends unless zero total length is explicitly prohibited;
- closed paths satisfy position and heading tolerances.

## Polygon-front-end validation

- vertices are ordered and finite;
- consecutive vertices are distinct;
- no edge has zero length;
- the radius source resolves to one finite positive value per vertex;
- the requested corner radius is compatible with both adjacent edges;
- neighboring tangent setbacks do not overlap;
- concave and convex turn directions are preserved;
- the compiler reports the source vertex for every derived bend.

Batch 005 implements the source and tangent-setback checks. Batch 014 adds a separate non-rejecting diagnostic for nonadjacent sharp-source edge crossings or touches and reports the exact source-edge pairs. Batch 020 adds the normalized analytical-path diagnostic after compilation. Radius infeasibility remains an asserting validation failure, while crossing policy remains unresolved.

## Regular-polygon validation

- side count is an integer of at least three;
- governing dimension kind is `side_length`, `circumradius`, or `apothem`;
- governing dimension and all requested radii are finite and positive;
- radius input is a scalar, exact list, or valid compact schedule;
- the resolved radius list contains exactly one positive value per side;
- center and first-vertex angle are finite;
- generated vertices share one circumradius and one edge length;
- generated order is counter-clockwise;
- the generated vertex polygon passes all existing tangent-setback and closure validations.

## Pattern validation

- pattern expansion terminates;
- nested repetition depth remains within an explicit supported limit;
- each schedule resolves for every requested repetition and local element;
- periodic schedules state their wrap behavior;
- expanded command count remains within an explicit implementation limit;
- compact and expanded developed lengths agree.

## Sampled-path validation

- sampling chord error is finite and positive;
- maximum angular step is finite, positive, and no greater than 180 degrees;
- sampled points are finite and remain within exact analytical bounds;
- the first and last sampled points equal the analytical endpoints within numerical tolerance;
- shared primitive boundaries are not duplicated as zero-length consecutive segments;
- sampled point count remains within an explicit implementation limit;
- chordal display length does not exceed exact analytical line-and-arc length;
- analytical measurements remain invariant when sampling parameters change.

## Geometric diagnostics

The analytical path should report:

- total straight length;
- total arc length;
- nominal developed length when that model exists;
- endpoint pose;
- bounds;
- self-intersections and near-intersections within a stated threshold;
- shortest retained straight where the authoring front end defines one;
- smallest and largest requested radius where applicable;
- source location of every reported interaction.

Batch 020 requires every nonadjacent primitive pair to be considered. Analytical bounds may safely reject a pair only when their exact bounds separation already exceeds the configured near threshold. Remaining candidates use exact finite line/line, line/arc, or arc/arc distance. Sequential primitive neighbors are intentional continuity contacts and are excluded; for closed paths the first and last primitives are also neighbors. Intersections and near passes are diagnostic records rather than assertion failures while crossing policy remains unresolved.

## Batch 021 nominal strap cut-plan validation

The cutting-policy source must have a non-empty name, resolve exactly one strap material, use development mode `nominal_mid_thickness` or `custom_fraction`, and carry a finite neutral-axis fraction from 0 through 1. Mid-thickness mode explicitly resolves to 0.5 rather than silently accepting another value.

Start/end, overlap, and joining allowances must be finite and nonnegative. Open analytical paths require closure mode `none` with zero overlap and joining allowance. Closed paths may use `none`, `butt`, or `overlap`; overlap mode requires a positive explicit overlap value, while non-overlap modes require overlap to remain zero. A closed `none` policy must not contain a joining allowance because the physical seam is intentionally unassigned.

The derived plan must reproduce the analytical path's exact inside-reference length, decompose that length into straight plus inside-arc length, calculate every nominal developed arc from the selected thickness fraction, and satisfy `cut length = nominal developed length + explicit allowance total`. Status must remain nominal/uncalibrated, with an additional closure-unassigned status for closed paths using no seam policy. These validations prove deterministic software arithmetic only and do not validate a physical PET neutral-axis location.

## Fixture validation

Batch 015 requires the bend-post fixture source and derived plan to check:

- exact fixture record type and current schema version;
- exactly one referenced strap material;
- supported radius policy (`nominal_target`) and retention policy (`none` or `arc_follower`);
- finite positive base thickness, post height, follower wall thickness, and printer-envelope dimensions;
- nonnegative base margin;
- post height at least the referenced strap's nominal width;
- positive tool-surface chord error and valid maximum angular step;
- exactly one bend station for every analytical arc and at least one bend;
- station source index, label, global station interval, target/tool centers, signed angle, target/tool radii, and target/tool tangent entry/exit points are valid;
- nominal mode preserves tool radius, center, and tangent datums equal to their target counterparts within the named position tolerance;
- resolved cylindrical tessellation stays within the requested ideal-circle sagitta bound;
- fixture plan preserves fixture identity, analytical-path identity, reference axis, and nominal strap thickness;
- nominal plans are explicitly marked `experimental_uncompensated`;
- base bounds are finite and fit within the configured printer envelope.

When `arc_follower` is active, validation additionally requires a positive radial slot outside every post, bounded follower tessellation, valid follower polygons, and base bounds that include the follower walls. The open-top follower has no overhanging cap, so vertical removal remains the current access policy. Segmentation and setup-aid validation remain separate from the full-form fixture record.

## Tolerances

Position, angle, chord error, closure, and assembly tolerances are separate named values. One generic epsilon must not be reused for every physical and numerical purpose.

## Contract tests

Tests should be opened directly and run with F5. Initial test families should cover:

- one straight;
- one left bend and one right bend;
- alternating radii;
- unequal segment lengths;
- regular triangle, square, and pentagon;
- concave polygon;
- periodic long wave;
- failed radius feasibility;
- failed closure;
- self-intersection detection;
- sampling invariance of analytical length.

## Batch 016 fixture-clearance validation

Before a bend-post fixture renders, the material router must expose the referenced strap-product registry to that render route regardless of which shape front end produced the analytical path. The application then validates a derived clearance report. With retention disabled, the Batch 016 post-gap and nominal strap-thickness-plus-clearance policy remains unchanged. With `arc_follower` enabled, Batch 017 expands the required post-pair gap by two follower radial extensions and expands the nonlocal-path requirement by the follower radial extension plus a second nominal strap slot. This treats each partial follower conservatively as a full-circle radial envelope. The post's own source arc and immediately tangent neighboring primitives remain excluded as intentional contact. Clearance violations are assertion failures; they are not silently rendered.

## Batch 017 arc-follower validation

For each retained bend, the follower inner radius equals tool radius plus nominal strap thickness plus configured clearance. The follower outer radius adds positive wall thickness. The partial annular wall spans the same signed sweep as the source bend, its outer chordal approximation must satisfy the configured tool-surface chord-error bound, and its exact analytical bounds participate in fixture base sizing.

## Long-form segmentation validation

A segmented fixture must cover station zero through the exact analytical path length with contiguous component intervals. IDs must derive deterministically from fixture identity and zero-based component index. Adjacent components must share the same split station, XY point, and heading; interior split datums must be `component_split` records generated inside straight primitives. Every original bend station must be assigned exactly once, and every component base must fit the configured print envelope independently. Full-path clearance validation remains global and is not weakened by segmentation.

## Batch 019 segmented setup-aid validation

A setup-aid source must use a supported registration mode (`none` or `pin_pair`) and label mode (`none` or `recessed_corner`). Nominal pin diameter, pair spacing, normal offset, label size, and label depth must be finite and positive; diametral hole clearance must be nonnegative. Pair spacing must exceed the resolved hole diameter, normal offset must exceed hole radius, and recessed mark depth must remain below base thickness.

For every segmented component, each registration-hole circle must lie completely inside that component's base bounds. Its edge must remain at least nominal strap thickness plus configured fixture clearance away from the complete analytical target path. At every adjacent component boundary, the previous component's end pair and the next component's start pair must resolve to identical global points within the named position tolerance. Component marks are deterministic zero-padded indexes and do not replace the full component ID.


## Batch 020 analytical path diagnostic validation

The near threshold must be finite and nonnegative. Every stored interaction must identify two ordered, distinct primitive indexes and their source-command provenance, use supported primitive kinds, have a finite nonnegative minimum distance no greater than the configured threshold, and classify as `intersection` only at the named numerical position tolerance or `near` otherwise. The path-level report must match the analytical path name and report candidate counts no larger than the total nonlocal pair count. Diagnostic calculations use analytical primitives only; sampled display chords are not valid evidence for an intersection result. The configurable near threshold is measured between finished-inside-edge analytical primitives and is not a substitute for physical strap-width, strap-thickness, or fixture-clearance validation.
