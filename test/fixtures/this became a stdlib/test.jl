result = go(@__DIR__)
strats = [r.strategy for r in result.strategy_reports]

@test last(strats) == GracefulPkg.StrategyFixStdlibs()

proj, man = final_project_manifest_parsed(result)

@test sort(collect(keys(proj["deps"]))) == ["Artifacts", "PlutoPkgTestA"]

# there should be only one compat entry left
@test proj["compat"] == Dict("PlutoPkgTestA" => "~0.2.2")
