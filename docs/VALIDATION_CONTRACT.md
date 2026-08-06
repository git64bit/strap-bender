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
