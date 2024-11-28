result = go(@__DIR__)
strats = [r.strategy for r in result.strategy_reports]

@test GracefulPkg.StrategyDoNothing() in strats
@test GracefulPkg.StrategyLoosenCompat() in strats

fixed_it = last(result.strategy_reports)

@test fixed_it.strategy isa GracefulPkg.StrategyLoosenCompat

@test fixed_it.project_changed
@test fixed_it.manifest_changed
@test !fixed_it.registry_changed
