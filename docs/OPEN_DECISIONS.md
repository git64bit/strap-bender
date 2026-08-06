# Open decisions

## Resolved design decisions

- Every shape uses one continuous strap.
- Disconnected elements, multiple loops, internal holes, and branched networks are outside the project contract.
- Straight lengths and bend radii are primary controlled quantities.
- The bend program is the primary authoring model.
- Polygon, regular-polygon, and wave descriptions are front ends to one analytical line-and-arc path.
- Sampled points are derived rendering data, not authoritative shape data.
- Long paths must support compact repetition and independent value schedules.
- Target shape, forming calibration, and fixture geometry remain separate.
- The project follows the self-contained Grid Stack / Polygon Stack framework and bounded batch workflow.

## Physical inputs still required

### Exact ULINE strap product

Record the product number, nominal width, nominal thickness, roll length, surface texture, and any published material grade. Measure actual width and thickness when practical.

### Forming process

Select and test cold forming, local heating, global heating, or another controlled process. Record temperature measurement, dwell, restraint, cooling, and handling method.

### Finished-radius measurement

Define the practical measurement method for small radii, including whether the reported inside radius is measured immediately after release or after a stated rest period.

### Neutral-axis model

Determine whether nominal centerline length is sufficient or whether a calibrated neutral-axis factor is required for accurate cutting length.

### End and closure policy

Decide how open-path tails are handled and how closed paths are joined. Required overlap, trimming, welding, fastening, or interlocking allowance must remain separate from geometric path length.

## Fixture decisions still required

- first fixture family to prototype;
- strap insertion and retention method;
- minimum practical printed tool radius;
- fixture height relative to strap width;
- printer build envelope;
- fixture mounting surface and available fasteners;
- alignment system for segmented tools;
- whether long shapes are formed in place, in sections, or sequentially;
- whether bends may be split across fixture components;
- acceptable fixture deflection and dimensional tolerance;
- removal strategy for closed and concave shapes.

## Software decisions still required

### BOSL2 dependency

Decide whether Strap Bender requires BOSL2, vendors a fixed compatible subset, or uses native OpenSCAD mathematics. The public data model remains library-independent.

### First workbench boundary

Choose whether the first executable workbench is:

- explicit bend program;
- regular polygon;
- radius-calibration coupon;
- a minimal combination of the above.

### Pattern schedule syntax

Select the smallest schedule grammar that supports constants, explicit lists, periodic lists, and the every-third-bend requirement without introducing an opaque expression evaluator.

### Self-intersections

Decide whether all self-intersecting paths are rejected initially or whether a narrowly defined crossing fixture will be supported later.

### Part and object numbering

Define project prefixes only after the first stable object families are known. Do not encode mutable process data into a geometry identifier without an explicit reason.
