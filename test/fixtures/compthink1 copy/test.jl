result = go(@__DIR__)
@test test_max_severity(result, GracefulPkg.StrategyRemoveManifest)
strats = [r.strategy for r in result.strategy_reports]

if VERSION > v"1.11.9999"
    @test test_max_severity(result, GracefulPkg.StrategyRemoveManifest)
else
    @test test_max_severity(result, GracefulPkg.StrategyFixStdlibs)
end