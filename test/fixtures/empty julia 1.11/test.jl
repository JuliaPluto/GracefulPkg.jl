result = go(@__DIR__)
strats = [r.strategy for r in result.strategy_reports]

@test strats == [GracefulPkg.StrategyDoNothing()]


