# Shape description

## Primary authoring language: bend program

The primary shape description is an ordered bend program. It follows the strap from its first end to its second end, or back to its starting point for a closed loop.

Conceptually:

```text
start at position and heading
straight 120 mm
left bend 90 degrees at finished inside radius 1.6 mm
straight 75 mm
right bend 45 degrees at finished inside radius 5 mm
straight 40 mm
...
```

The final OpenSCAD syntax will use indexed records with named constructors and index constants. The text above defines semantics, not source syntax.

## Primitive commands

### Start pose

A path has an initial XY position and heading. The default design pose is the origin with heading along positive X. Pose affects placement, not intrinsic shape or developed length.

### Straight

A straight command specifies the finished tangent-to-tangent distance from the exit of the preceding bend to the entry of the next bend.

The distance is not a polygon vertex-to-vertex distance and is not allowed to become negative after corner rounding.

### Bend

A bend command specifies:

- signed turn angle;
- desired finished inside radius;
- optional identity or note for reporting.

Positive angle turns left. Negative angle turns right. A zero-angle bend is invalid. A primitive bend remains a circular arc; changing curvature requires multiple bends or a future approximation front end.

## Normalized analytical path

The bend program compiles to an ordered analytical path containing only:

- finite straight-line primitives;
- finite circular-arc primitives.

Each primitive retains exact start pose, end pose, length, tangent direction, and source-command identity. This analytical path is the common boundary between shape authoring, validation, measurement, preview, and fixture planning.

## Compact numeric schedules

Batch 007 defines four schedule kinds shared by current polygon front ends and future patterns:

```text
constant(value)
explicit([value for every consumer])
periodic([cycle values])
every_nth(default, selected, interval, first position)
```

`every_nth` uses one-based source positions. With interval 3 and first position 3, selected values occur at positions 3, 6, 9, and so on. The schedule resolves to an explicit list before any tangent setback or bend geometry is calculated. For polygons, positions refer to the ordered source vertices and do not change when a different start vertex changes command traversal.

## Authoring front ends

### Explicit bend sequence

Best for direct manufacturing control and one-off shapes. Every straight and bend is listed in order.

### Vertex polygon with per-corner radii

Best for triangles, squares, pentagons, stars, shields, arrows, and similar contours. The front end accepts ordered vertices and a radius assignment, then derives tangent points, retained straight lengths, and circular corner arcs.

The polygon front end must reject a radius that consumes more of an adjacent edge than is available. It must support convex and concave corners without changing turn direction silently.

Batch 005 implements this for named closed vertex polygons. Sharp source vertices are ordered clockwise or counter-clockwise; orientation is derived from signed area. Each local signed turn is classified relative to that orientation, tangent setback is `radius × tan(abs(turn)/2)`, and every retained edge must remain strictly positive. The selected start vertex identifies the final closing bend, while source edge and vertex numbers are preserved in the normalized command mapping.

### Regular polygon generator

Batch 006 defines side count, one governing sharp dimension (`side_length`, `circumradius`, or `apothem`), center, first-vertex angle, start vertex, and corner-radius source. It generates counter-clockwise sharp vertices, then compiles through the same rounded vertex-polygon, bend-program, and analytical-path route as explicitly entered vertices. Batch 007 allows scalar, explicit, periodic, or every-nth radius assignment. The Customizer exposes constant and every-nth modes; full explicit and periodic schedules remain available in Laboratory records.

### Repeated pattern and wave generator

Long forms use a named pattern block plus a repetition count. Pattern parameters may be supplied by:

- one constant value;
- an explicit list;
- a periodic list;
- an index-derived schedule supported by the workbench.

The Batch 007 schedule foundation can represent the stated bend-radius assignment either as periodic `[1.6, 1.6, 5.0]` or as every-nth with default 1.6, selected 5.0, interval 3, and first position 3. The future wave compiler will apply that schedule to expanded bend positions. Segment lengths may use an independent schedule and need not be equal.

### Imported line-and-arc path

A future import front end may accept already normalized line and circular-arc records. A sampled polyline may be imported only as an approximation source with an explicit tolerance and must not be presented as exact-radius manufacturing intent.

## Open and closed paths

An open path has two free ends. A closed path requests positional and tangent closure.

Closing a path is not implemented by drawing an extra arbitrary line between its ends. The authored commands must produce closure within explicit positional and angular tolerances, or validation must fail.

Joining overlap, splice length, weld allowance, or fastener allowance is separate from geometric closure and remains an explicit manufacturing allowance.

## Point paths and BOSL2

OpenSCAD `polygon()` point lists and BOSL2 paths are useful for preview, offsets, sweeps, and fixture construction. They are derived representations.

The public Strap Bender records must not depend on a sampled-point layout or expose a BOSL2-specific object as the canonical shape. A later implementation may use BOSL2 internally without changing the shape contract.

## Sampling

Circular arcs are sampled only when a consumer requires points. Sampling uses an explicit chord-error or angular tolerance. Changing display resolution must not change:

- analytical bend radius;
- analytical bend angle;
- straight length;
- developed strap length;
- fixture datum locations.
