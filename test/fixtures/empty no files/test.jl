result = go(@__DIR__)
strats = [r.strategy for r in result.strategy_reports]

@test strats == [GracefulPkg.StrategyDoNothing()]

proj, man = final_project_manifest_parsed(result)

@test proj == nothing
@test man == nothing
