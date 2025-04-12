result = go(@__DIR__)
strats = [r.strategy for r in result.strategy_reports]

if VERSION > v"1.8.9999"
    @test test_max_severity(result, GracefulPkg.StrategyLoosenCompat)

    @test GracefulPkg.StrategyLoosenCompat() ∈ strats
    @test GracefulPkg.StrategyUpdateRegistry() ∈ strats
end