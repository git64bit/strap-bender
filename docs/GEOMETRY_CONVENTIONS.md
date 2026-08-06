# Geometry conventions

## Units and plane

- All design dimensions use millimetres.
- The target analytical reference path lies in the XY plane.
- Positive X is the default starting heading.
- Positive signed turn is counter-clockwise / left.
- Negative signed turn is clockwise / right.
- Z is reserved for strap width, fixture height, retention features, and assembly geometry.

## Strap orientation

The PET strap is treated as a ribbon whose width is normal to the shape plane and whose thickness lies across the in-plane bend. Exact orientation will be confirmed against the selected ULINE product and fixture method before implementation.

## Phase 1 analytical reference axis

The first analytical path kernel uses the **desired finished inside edge** as its explicit geometric reference axis. Therefore, a bend command with a 5 mm desired finished inside radius compiles to an analytical circular arc with a 5 mm radius on that reference path.

This choice does not equate the inside edge with the strap centerline or neutral axis. Centerline geometry, neutral-axis developed length, forming compensation, and cut length remain separate later derivations that require the physical strap specification and calibration record.

## Straight-segment length

A specified straight length is the distance between neighboring bend tangent points. It excludes both circular arcs.

For a path beginning or ending with a straight, the distance is measured from the free end to the nearest bend tangent point.

## Radius layers

The following radii are distinct:

### Desired finished inside radius

The user-facing bend target measured on the inside surface of the relaxed finished strap.

### Nominal path radius

The analytical radius used to place the strap reference path. Its relationship to inside radius depends on strap thickness and the selected reference axis.

### Neutral-axis radius

The effective material radius used for developed-length calculation. It may require a calibrated neutral-axis factor rather than a simple half-thickness assumption.

### Fixture or mandrel radius

The printed-tool radius used while forming. Springback, heat, dwell, restraint, and material lot may make this different from the desired finished radius.

These values must never share one field or be substituted without a named conversion.

## Bend angle

A bend angle is the signed change in tangent heading through one circular arc. Primitive bend magnitude must be greater than zero and less than one full revolution. Larger intended turns are represented by multiple primitives.

## Developed strap length

Nominal developed length is the ordered sum of:

- all tangent-to-tangent straight lengths;
- all neutral-axis arc lengths.

For one arc:

```text
arc length = neutral-axis radius × absolute bend angle in radians
```

Until a neutral-axis calibration exists, reports must label the result as a nominal estimate rather than an exact cut length.

## Cutting length

Cut length is derived from developed length plus separately named allowances, such as:

- end trimming;
- handling tails;
- closure overlap;
- joining process allowance;
- calibration correction.

No allowance receives an undocumented default.

## Tangency and continuity

Every straight-to-arc and arc-to-straight transition is tangent continuous. A deliberate cusp or kink is represented as a zero-radius or fold operation only if a future physical process explicitly supports it. It must not be approximated by an arbitrarily small circular radius.

## Closure

A closed path must satisfy both:

- endpoint distance within an explicit positional tolerance;
- final heading within an explicit angular tolerance of the starting heading.

The closure seam remains identifiable for fixture access and manufacturing instructions.

## Intersection policy

The analytical path must detect and report non-neighboring intersections and near-intersections. Initial fixture implementations may reject self-crossing paths. Deliberate crossings require an explicit future policy for vertical separation, strap overlap, and forming order.

## Bounds

Path bounds derive from exact line and arc extrema, not only from sampled display points. Fixture segmentation, print-bed packing, and material-length reports use analytical bounds whenever practical.

## Sampling and diagnostic preview

Exact lines and circular arcs remain authoritative. A line contributes only its endpoints to the sampled display path. A circular arc is divided into equal angular chords so that both of the following limits are respected:

- requested maximum chord error;
- requested maximum angular step.

The first and last point of every primitive are retained exactly, while shared primitive boundaries appear only once in the sampled point list. The resulting chordal polyline is expected to be slightly shorter than the exact curved path. Its length, bounds, and point count are diagnostic values only.

The Batch 004 renderer shows a thin extrusion of the sampled **finished inside-edge reference path** and optional markers at analytical primitive boundaries. It is not a strap solid, neutral-axis representation, mandrel, or production fixture.
