result = go(@__DIR__)
strats = [r.strategy for r in result.strategy_reports]
@test !first(result.strategy_reports).success
@test last(result.strategy_reports).success

@test GracefulPkg.StrategyRemoveManifest() in strats
@test GracefulPkg.StrategyRemoveProject() in strats


# TODO this should work