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
- Application completion is not blocked by pending coupon measurements; empirical calibration is a later refinement.
- Batch 015 selects the first production-shape software fixture family: a full-form open-top bend-post base, with one cylindrical inside-form post per analytical bend.
- Batch 016 resolves the first fixture collision policy: exact post/post gaps and post/nonlocal-path gaps are checked before rendering.
- Batch 017 resolves the first production-shape retention topology: optional open-top arc followers surrounding each bend sweep with a nominal strap-thickness-plus-clearance slot and explicit follower wall thickness.
- Batch 018 resolves the first long-form software strategy: deterministic sequential components split only inside analytical straight regions, with exact global station/XY/heading setup datums and local print origins.
- Batch 019 resolves the first physical sequential alignment aid: matching keyed pin-pair holes derived from each exact interior split datum, plus a recessed zero-padded component index mark.
- Batch 020 resolves normalized path detection: nonadjacent exact analytical line/arc primitives are checked for intersections and configurable near passes with source-command provenance. Detection remains diagnostic rather than an automatic shape rejection.
- Batch 021 resolves the application-level cutting-policy software boundary: nominal mid-thickness or explicit custom-fraction development is separated from user-entered start/end, overlap, and joining allowances. Closed geometry may intentionally remain `closure_unassigned`; no physical seam method is invented.
- Batch 022 resolves the application-level manufacturing-package boundary: deterministic component manifests and Catalog-ready embedded recipes are available before physical acceptance, but only explicit immutable accepted recipes may enter `objects/` and the Catalog registry.

## Physical inputs still required

### Forming process

Select and test cold forming, local heating, global heating, or another controlled process. Record temperature measurement, dwell, restraint, cooling, and handling method.

### Finished-radius measurement

Batch 010 can record the method, stated uncertainty, and post-release rest interval for each observation. Batch 012 adds a guarded entry workbench, but the practical measurement method for small radii still must be selected before real data are registered.

### Neutral-axis model

Batch 021 supplies a nominal software model using either explicit mid-thickness (0.5) or a user-entered custom fraction of nominal thickness. Physical testing must still determine whether that approximation is adequate or whether a calibrated neutral-axis factor/correction is required for production accuracy.

### End and closure policy

Batch 021 keeps start allowance, end allowance, closure overlap, and joining allowance as separate explicit inputs. The remaining physical decision is how actual open-path tails and closed seams are trimmed, welded, fastened, overlapped, or interlocked and which numeric allowances those processes require. A closed path may remain explicitly unassigned until that decision is made.

## Fixture decisions still required

Batch 011 resolves the small calibration-tool topology. Batch 015 additionally selects the first production-shape software fixture family: a nominal full-form open-top bend-post base. The following implementation and physical decisions remain:

- whether the Batch 017 open-top arc follower remains the preferred retention method after physical handling tests;
- minimum practical printed tool radius;
- fixture height relative to strap width;
- printer build envelope;
- fixture mounting surface and available fasteners;
- final pin material, fit allowance, and common setup-board/mounting method for the Batch 019 registration holes;
- whether a later tiled or rail-connected strategy is also needed in addition to the Batch 018 sequential strategy;
- acceptable fixture deflection and dimensional tolerance;
- removal strategy for closed and concave shapes.

## Software decisions still required

### BOSL2 dependency

Decide whether Strap Bender requires BOSL2, vendors a fixed compatible subset, or uses native OpenSCAD mathematics. The public data model remains library-independent.

### Self-intersections

Batch 014 detects and reports nonadjacent intersections in the sharp source polygon. Batch 020 extends detection to the normalized exact line/arc path and reports both intersections and configurable near passes. The remaining policy decision is whether analytical self-intersections are categorically rejected or whether a narrowly defined crossing fixture/topology will ever be supported.

### Part and object numbering

Define project prefixes only after the first stable object families are known. Do not encode mutable process data into a geometry identifier without an explicit reason.

The physical product identity is now fixed as ULINE S-1655 black, smooth, 5/8 inch x .020 inch PET polyester strapping. Vendor nominal values are not substitutes for the measurements above.

## Calibration evidence boundary

Batch 010 defines how a real radius observation will be preserved but intentionally registers no physical observation. Batch 011 supplies experimental printable tool geometry for producing those observations. Batch 012 adds a coupon-linked calibration-trial wrapper and a Radius Observation workbench whose default state is deliberately not ready; no evidence record is emitted until the gate is explicitly enabled. Batch 013 adds the persistent calibration-trial registry and registry-audit route, but the initial registry is deliberately empty. Test records use future-dated synthetic values and explicit TEST DATA notes so they cannot be mistaken for empirical PET behavior. An empirical target-to-tool mapping must not be introduced until real observations exist for a defined forming process and measurement method and are explicitly registered. Until then, fixture planning may use an explicitly labeled nominal/uncompensated radius policy so the application can be completed without inventing PET behavior.
