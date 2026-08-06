# Project scope

## Purpose

Strap Bender describes and manufactures planar shapes made from one continuous PET pallet strap. It must preserve the intended straight lengths and bend radii closely enough that printable bending fixtures can be derived from the same authoritative shape definition.

## In scope

- one continuous, ordered, unbranched strap path;
- open and closed paths;
- straight segments with independently specified lengths;
- circular bends with independently specified direction, angle, and radius;
- regular polygons such as triangles, squares, pentagons, and higher-sided polygons;
- concave and asymmetric contours that remain representable as one strap path;
- long repeated paths measured in feet rather than printer-bed dimensions;
- periodic, alternating, listed, or individually assigned segment lengths and radii;
- exact line-and-arc path normalization;
- shape preview and diagnostics;
- nominal developed strap length and explicit cutting allowances;
- material and springback calibration records;
- derivation of printable forming fixtures;
- segmentation of fixture geometry without segmentation of the strap path;
- promotion of physically accepted definitions into immutable Catalog objects.

## Out of scope

- disconnected elements;
- multiple strap pieces treated as one shape;
- internal holes or cutouts represented by additional loops;
- branching path networks;
- filled-silhouette reconstruction as the primary model;
- silently converting an impossible radius or length into a different shape;
- treating sampled polygon points as authoritative manufacturing data;
- assuming fixture radius equals the relaxed finished radius without calibration;
- structural load certification of the finished strap shape;
- closure hardware or joining methods until a closure contract is selected.

## Primary design requirements

### Preserve manufacturing intent

A bend must remain identifiable as a bend with a requested direction, angle, and radius. A straight must remain identifiable as a tangent-to-tangent distance. Converting the path to display points must not destroy these records.

### Scale without manual coordinate entry

Long paths must be expressible through named patterns, repetition counts, and value schedules. A user must not need to enter hundreds of XY coordinates to create a repeated wave.

### Separate target shape from forming compensation

The desired finished path, the nominal geometric path, and the compensated fixture geometry are separate layers. Material behavior may alter the fixture, but it must not rewrite the target shape.

### Fail explicitly

Impossible tangent geometry, invalid radii, failed closure, unintended self-intersection, and unsupported fixture conditions must produce explicit validation failures or diagnostics. Values must not be clamped or substituted silently.

## Physical acceptance boundary

OpenSCAD can validate mathematical consistency and generate tooling. It cannot prove the relaxed PET result. A geometry becomes accepted only after the fixture is printed, the specified strap is formed using a recorded process, and the resulting shape is measured and approved.
