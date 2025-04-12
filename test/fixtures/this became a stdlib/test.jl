result = go(@__DIR__)
@test test_max_severity(result, GracefulPkg.StrategyRemoveManifest)
strats = [r.strategy for r in result.strategy_reports]


proj, man = final_project_manifest_parsed(result)

@test sort(collect(keys(proj["deps"]))) == ["Artifacts", "PlutoPkgTestA"]


if VERSION > v"1.9.99999" || VERSION < v"1.6.9999"
    @test last(strats) == GracefulPkg.StrategyFixStdlibs()
    # there should be only one compat entry left
    @test proj["compat"] == Dict("PlutoPkgTestA" => "~0.2.2")
else
    @test last(strats) == GracefulPkg.StrategyDoNothing()
    # there should be only one compat entry left
    @test sort(collect(keys(proj["compat"]))) == ["Artifacts", "PlutoPkgTestA"]
end