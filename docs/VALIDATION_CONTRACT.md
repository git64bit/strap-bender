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

The Radius Observation workbench defaults to `Observation ready = false`. In that state the selected coupon is validated and reported, but no observation or calibration-trial evidence record is constructed. Enabling the gate does not certify the values as physical truth; it only allows the normal evidence validators to run.

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

Batch 005 implements these checks except polygon self-intersection analysis, which remains a separate later diagnostic. Radius infeasibility is exposed both as a Boolean predicate for non-failing contract tests and as an asserting source-record validator for production routing.

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
- nominal developed length;
- endpoint pose;
- bounds;
- minimum non-neighboring separation;
- self-intersections and near-intersections;
- shortest retained straight;
- smallest and largest requested radius;
- source location of every failure.

A diagnostic may be a warning only when the path remains mathematically valid and the fixture policy explicitly allows continuation.

## Fixture validation

Once a fixture family exists, validation must check:

- compensated radius is within the fixture family's printable domain;
- strap fits the intended clearance and retention geometry;
- component bounds fit the configured printer envelope;
- segmentation joints do not alter the target station or tangent;
- component identifiers are unique;
- closure access and strap removal remain possible;
- unsupported self-crossings are rejected.

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
