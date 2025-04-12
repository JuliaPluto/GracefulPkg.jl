result = go(@__DIR__)
@test test_max_severity(result, GracefulPkg.StrategyRemoveManifest)
strats = [r.strategy for r in result.strategy_reports]

if VERSION > v"1.10.9999"
    @test strats == [GracefulPkg.StrategyDoNothing()]
else
    @test last(strats) == GracefulPkg.StrategyFixStdlibs()
    # @test last(strats) == GracefulPkg.StrategyRemoveManifest()
end

