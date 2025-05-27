result = go(@__DIR__)
@test test_max_severity(result, GracefulPkg.StrategyInstantiateIfNeeded)
strats = [r.strategy for r in result.strategy_reports]

@test GracefulPkg.StrategyDoNothing() in strats
@test GracefulPkg.StrategyInstantiateIfNeeded() in strats

fixed_it = last(result.strategy_reports)

@test fixed_it.strategy isa GracefulPkg.StrategyInstantiateIfNeeded

@test !fixed_it.project_changed
@test !fixed_it.manifest_changed
@test !fixed_it.registry_changed
