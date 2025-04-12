result = go(@__DIR__)
strats = [r.strategy for r in result.strategy_reports]

@test last(strats) == GracefulPkg.StrategyRemoveProject()
