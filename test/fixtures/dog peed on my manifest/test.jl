result = go(@__DIR__)
@test test_max_severity(result, GracefulPkg.StrategyRemoveManifest)
strats = [r.strategy for r in result.strategy_reports]
@test !first(result.strategy_reports).success
@test last(result.strategy_reports).success

@test GracefulPkg.StrategyRemoveManifest() in strats
@test GracefulPkg.StrategyRemoveManifestAndCompat() ∉ strats
@test GracefulPkg.StrategyRemoveProject() ∉ strats
