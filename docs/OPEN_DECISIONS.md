# Open decisions

## Resolved design decisions

- Every shape uses one continuous strap.
- Disconnected elements, multiple loops, internal holes, and branched networks are outside the project contract.
- Straight lengths and bend radii are primary controlled quantities.
- The bend program is the primary authoring model.
- Polygon, regular-polygon, and wave descriptions are front ends to one analytical line-and-arc path.
- Sampled points are derived rendering data, not authoritative shape data.
- Long paths use named pattern blocks, compact repetition instances, and independent value schedules resolved once per repetition.
- The initial schedule grammar is constant, explicit, periodic, and every-nth; no opaque expression evaluator is required.
- Target shape, forming calibration, and fixture geometry remain separate.
- The project follows the self-contained Grid Stack / Polygon Stack framework and bounded batch workflow.

## Physical inputs still required

### Forming process

Select and test cold forming, local heating, global heating, or another controlled process. Record temperature measurement, dwell, restraint, cooling, and handling method.

### Finished-radius measurement

Batch 010 can record the method, stated uncertainty, and post-release rest interval for each observation, but the practical measurement method for small radii still must be selected before real data are registered.

### Neutral-axis model

Determine whether nominal centerline length is sufficient or whether a calibrated neutral-axis factor is required for accurate cutting length.

### End and closure policy

Decide how open-path tails are handled and how closed paths are joined. Required overlap, trimming, welding, fastening, or interlocking allowance must remain separate from geometric path length.

## Fixture decisions still required

Batch 011 resolves only the small calibration-tool topology: an open inside-form coupon without integrated retention. It does not select a production-shape fixture family.

- first production fixture family to prototype;
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

### Self-intersections

Decide whether all self-intersecting paths are rejected initially or whether a narrowly defined crossing fixture will be supported later.

### Part and object numbering

Define project prefixes only after the first stable object families are known. Do not encode mutable process data into a geometry identifier without an explicit reason.

The physical product identity is now fixed as ULINE S-1655 black, smooth, 5/8 inch x .020 inch PET polyester strapping. Vendor nominal values are not substitutes for the measurements above.

## Calibration evidence boundary

Batch 010 defines how a real radius observation will be preserved but intentionally registers no physical observation. Batch 011 supplies experimental printable tool geometry for producing those observations. Test records use future-dated synthetic values and explicit TEST DATA notes so they cannot be mistaken for empirical PET behavior. A target-to-tool mapping must not be introduced until real observations exist for a defined forming process and measurement method.
