result = go(@__DIR__)
strats = [r.strategy for r in result.strategy_reports]



@test GracefulPkg.StrategyDoNothing() ∈ strats
@test GracefulPkg.StrategyLoosenCompat() ∈ strats

@test last(strats) == GracefulPkg.StrategyLoosenCompat()
