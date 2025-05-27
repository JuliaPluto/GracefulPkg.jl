result = go(@__DIR__)
@test test_max_severity(result, GracefulPkg.StrategyInstantiateIfNeeded)
strats = [r.strategy for r in result.strategy_reports]

@test GracefulPkg.StrategyDoNothing() in strats

fixed_it = last(result.strategy_reports)

@test (fixed_it.strategy isa GracefulPkg.StrategyInstantiateIfNeeded) || (fixed_it.strategy isa GracefulPkg.StrategyDoNothing)

@test !fixed_it.project_changed
@test !fixed_it.registry_changed

import Pkg
if isdefined(Pkg, :upgrade_manifest)
    @test first(result.strategy_reports).manifest_changed # upgraded to manifest v2
end
