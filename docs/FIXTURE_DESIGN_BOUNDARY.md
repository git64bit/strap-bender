# Fixture design boundary

## Purpose

A Strap Bender fixture exists to reproduce the target tangent locations, straight lengths, bend directions, and compensated tool radii as closely as practical for the specified PET strap and forming process.

This document defines fixture requirements. It does not select the first fixture topology.

## Required separation

The continuous strap path and the printable fixture are different objects:

- the strap path is one uninterrupted global sequence;
- the fixture may contain any practical number of printed components;
- changing fixture segmentation must not change the target path;
- local fixture coordinates must trace back to global path stations.

## Geometric responsibilities

A fixture family must define how it controls:

- bend center or bend datum;
- compensated fixture radius;
- tangent entry and exit positions;
- straight-segment distance between neighboring bends;
- left/right bend orientation;
- strap width and thickness clearance;
- insertion, retention, and removal;
- beginning, ending, and closure regions.

## Compensation responsibility

The fixture planner receives a forming calibration record. It must distinguish:

```text
desired finished radius
        ↓ calibration
required fixture radius
```

When no qualified calibration exists, the fixture and reports must be marked experimental. The system must not imply that a nominal mandrel radius guarantees the relaxed finished radius.

## Candidate fixture families

The following remain candidates for later discussion:

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

Printed coupons and measured relaxed results will establish the evidence needed for a future target-radius-to-tool-radius mapping for the exact strap and process. Batch 011 itself contains no such mapping and does not select the first production-shape fixture family.
