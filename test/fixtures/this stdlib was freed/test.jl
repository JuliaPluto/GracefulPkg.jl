result = go(@__DIR__)
@test test_max_severity(result, GracefulPkg.StrategyRemoveManifest)
strats = [r.strategy for r in result.strategy_reports]

@test strats == [GracefulPkg.StrategyDoNothing()]

proj, man = final_project_manifest_parsed(result)


@test sort(collect(keys(proj["deps"]))) == ["Statistics"]

# should not get added
@test !haskey(proj, "compat")
