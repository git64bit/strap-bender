# Glossary

Analytical path — Ordered exact sequence of finite line and circular-arc primitives. It is independent of display sampling.

Authoring front end — User-facing description such as an explicit bend program, vertex polygon, regular polygon, or repeated wave. Every front end compiles to the same analytical path.

Bend — Circular change in strap heading defined by signed angle and a named radius reference.

Bend program — Primary ordered manufacturing description: straight, bend, straight, bend, and supported pattern operations.

Chord error — Maximum geometric deviation permitted when a circular arc is converted to display or solid-generation points.

Closed path — One continuous path whose end position and tangent return to the starting pose within explicit tolerances.

Closure allowance — Additional strap length required by the joining method. It is not part of geometric closure or analytical path length.

Command station — Cumulative developed distance from the beginning of the strap to a command or primitive location.

Compensated fixture radius — Tool radius selected through a forming calibration to produce the desired relaxed bend radius.

Developed length — Length measured along the selected strap reference or neutral axis through all straights and bends.

Desired finished inside radius — User-facing target radius measured on the inside surface of the relaxed finished strap.

Fixture family — One physical tooling strategy, such as full-form channel, tiled form, modular bend stations, or sequential jig.

Fixture planner — Code that consumes a target analytical path, strap specification, calibration, and fixture settings to create printable components.

Forming calibration — Recorded relationship between target geometry and tool geometry for one strap and forming process.

Free end — Beginning or ending of an open strap path.

Inside radius — Radius measured to the inner surface of the bent strap in the shape plane.

Nominal path radius — Analytical radius assigned to the chosen strap reference path before physical compensation.

Normalized primitive — One exact line or circular arc produced by compilation and traceable to its source command.

Open path — One continuous path with two free ends and no closure requirement.

Pattern definition — Reusable ordered bend-program block with parameter slots.

Pattern instance — Use of a pattern definition with a repetition count and value schedules.

Every-nth schedule — Compact rule using a default value except at recurring one-based source positions, such as positions 3, 6, 9, and so on.

Explicit schedule — Exact finite list containing one value for every consumer.

Periodic schedule — Finite value cycle repeated as required, such as `[1.6, 1.6, 5.0]` for every-third-bend radius control.

Sampled path — Derived point list approximating the analytical path for preview, sweep, offset, or fixture solid construction.

Segment length — Finished straight tangent-to-tangent distance between neighboring bends.

Shape specification — Authoritative identity and source records describing one continuous target strap path.

Springback — Change from restrained forming geometry to relaxed geometry after load or heat is removed.

Strap specification — Exact physical product identity and measured or nominal dimensions used by geometry and calibration.

Tangent point — Point where a straight meets a circular bend with continuous heading.

Target path — Desired finished strap geometry before fixture compensation and manufacturing details.

Tool radius — Radius physically present on the forming fixture or mandrel.

Unbranched path — Ordered path with exactly one predecessor and successor through its interior; it contains no network junction.

Value schedule — Compact constant, explicit, periodic, or every-nth numeric rule resolved for a known consumer count before geometry is compiled.
