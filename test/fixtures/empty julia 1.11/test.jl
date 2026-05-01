result = go(@__DIR__)
@test test_max_severity(result, GracefulPkg.StrategyRemoveManifest)
strats = [r.strategy for r in result.strategy_reports]

@test strats == [GracefulPkg.StrategyDoNothing()]

function get_julia_version(snap::GracefulPkg.ProjectManifestSnapshot)
    s = snap.manifest
    if s !== nothing
        try
            TOML.parse(s)["julia_version"]
        catch e
            @warn "Could not parse manifest for julia_version" exception = (e, catch_backtrace())
            nothing
        end
    end
end

@test get_julia_version(result.strategy_reports[1].snapshot_before) == "1.11.987234987"
@test get_julia_version(result.strategy_reports[1].snapshot_after) == string(VERSION)


