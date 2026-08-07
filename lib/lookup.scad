//////////////////////////////////////////////////////////////////////
// LibFile: lookup.scad
// Project: Strap Bender
// FileGroup: Utilities
// FileSummary: Resolves one stable record name to exactly one record.
//////////////////////////////////////////////////////////////////////

function record_name(record) =
    record[0] == STRAP_BENDER_PROJECT_RECORD
        ? project_name(record)
        : record[0] == STRAP_BENDER_SHAPE_RECORD
            ? shape_name(record)
            : record[0] == STRAP_BENDER_VERTEX_POLYGON_RECORD
                ? vertex_polygon_name(record)
                : record[0] == STRAP_BENDER_REGULAR_POLYGON_RECORD
                    ? regular_polygon_name(record)
                    : record[0] == STRAP_BENDER_PATTERN_BLOCK_RECORD
                        ? pattern_block_name(record)
                        : record[0] == STRAP_BENDER_PATTERN_INSTANCE_RECORD
                            ? pattern_instance_name(record)
                            : record[0] ==
                                STRAP_BENDER_STRAP_MATERIAL_RECORD
                                ? strap_material_name(record)
                                : record[0] ==
                                    STRAP_BENDER_RADIUS_OBSERVATION_RECORD
                                    ? radius_observation_name(record)
                                    : undef;

function records_named(records, name) =
    [for (record = records) if (record_name(record) == name) record];

function named_record(records, name, record_kind = "record") =
    let(matches = records_named(records, name))
    assert(
        len(matches) == 1,
        str(
            "Expected exactly one ", record_kind,
            " named '", name, "'; found ", len(matches), "."
        )
    )
    matches[0];

function record_names(records) = [for (record = records) record_name(record)];
