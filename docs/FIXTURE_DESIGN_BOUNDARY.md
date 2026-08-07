# Fixture design boundary

## Purpose

A Strap Bender fixture exists to reproduce the target tangent locations, straight lengths, bend directions, and compensated tool radii as closely as practical for the specified PET strap and forming process.

This document defines fixture requirements. Batch 015 selects the first software topology: a full-form open-top bend-post fixture. It is deliberately nominal and uncompensated until physical calibration is available.

## Required separation

The continuous strap path and the printable fixture are different objects:

- the strap path is one uninterrupted global sequence;
- the fixture may contain any practical number of printed components;
- changing fixture segmentation must not change the target path;
- local fixture coordinates must trace back to global path stations.

## Geometric responsibilities

A fixture family must define how it controls:

- bend center or bend datum;
- fixture radius, whether empirically compensated or explicitly nominal;
- tangent entry and exit positions;
- straight-segment distance between neighboring bends;
- left/right bend orientation;
- strap width and thickness clearance;
- insertion, retention, and removal;
- beginning, ending, and closure regions.

## Compensation responsibility

A calibrated fixture planner must distinguish:

```text
desired finished radius
        ↓ calibration
required fixture radius
```

When no qualified calibration exists, fixture development continues using an explicitly named nominal policy, but the fixture and reports must be marked experimental. The system must not imply that a nominal mandrel radius guarantees the relaxed finished radius. Calibration therefore gates physical accuracy claims, not application development.

## Batch 015 selected family — full-form bend posts

The first production-shape software family uses a rectangular base and one full cylindrical inside-form post per analytical bend. In nominal mode the post tool center is the exact analytical target arc center. Its source command, global station interval, signed turn, target/tool radii, and separate target/tool entry/exit tangent datums remain traceable in the derived fixture plan.

In `nominal_target` mode each tool radius equals the requested finished inside radius. This is an intentionally uncompensated construction used to complete fixture software before empirical PET correction exists. The base covers the analytical path and complete post circles plus margin, and validation rejects a base larger than the configured printer envelope. Posts are open at the top so the strap can be lifted vertically; no integral retention is claimed.

This family is suitable for small shapes that fit one print envelope. It is not the long-form solution and does not yet detect post/post or post/nonlocal-path interference.

## Other candidate fixture families

The following remain candidates for later phases:

- full-form channel or perimeter fixture;
- tiled full-form fixture with alignment keys;
- modular bend stations connected by length-setting rails;
- indexed baseboard with reusable radius blocks;
- sequential bending jig that advances one command at a time;
- hybrid system using dedicated complex regions and reusable straight spacers.

A 10–20 foot shape makes a single printed full-form tool impractical, but it does not by itself determine whether tiled, modular, or sequential tooling is best.

## Segmentation requirements

Any segmented fixture method must preserve:

- global path station at each joint;
- tangent direction at each joint;
- cumulative length without hidden gap or overlap;
- repeatable alignment after assembly;
- print-bed and printer-envelope constraints;
- a deterministic component ordering and labeling system.

Segmentation should prefer straight regions unless physical testing demonstrates a reliable way to split through a bend.

## Printing boundary

Fixture geometry may include printer-specific clearances, fastener holes, keys, and support choices. These belong to fixture and manufacturing records, not the target strap shape.

Slicer-only settings remain outside the OpenSCAD target-path definition.

## Physical process boundary

The fixture design must eventually record whether forming is:

- cold;
- heated locally;
- heated globally;
- restrained during cooling;
- formed in one pass or in ordered stages.

No geometry batch should assume a process that has not been selected and tested.

## Calibration tooling

Batch 011 implements the first calibration-tool family as an open inside-form coupon. The strap stands with its width along Z and contacts two tangent faces joined by a circular designed tool radius. A base supports the lower strap edge. The coupon intentionally has no integral outer retention, clamp, heating, or cooling feature; those process choices remain explicit experimental inputs.

Reference Laboratory coupons are provided for 90-degree R1.6 and R5 designed tool radii, and the workbench can author other nonzero signed angles through 180 degrees. Tool-surface facets obey a requested chord-error bound and maximum angular step. Tessellation error is reported separately from printer dimensional accuracy.

Printed coupons and measured relaxed results will establish the evidence needed for a future target-radius-to-tool-radius mapping for the exact strap and process. Batch 011 itself contains no such mapping. Batch 015 proceeds independently with nominal/uncompensated production-shape fixture software; later calibration replaces the radius mapping without redefining the target path.
