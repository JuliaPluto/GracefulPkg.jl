result = go(@__DIR__)
strats = [r.strategy for r in result.strategy_reports]


@test GracefulPkg.StrategyLoosenCompat() ∈ strats
@test GracefulPkg.StrategyUpdateRegistry() ∈ strats

@test last(strats) == GracefulPkg.StrategyLoosenCompat()
