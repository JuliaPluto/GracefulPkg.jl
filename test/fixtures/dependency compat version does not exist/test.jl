result = go(@__DIR__)
strats = [r.strategy for r in result.strategy_reports]

@test strats == [GracefulPkg.StrategyDoNothing(), GracefulPkg.StrategyUpdateRegistry(), GracefulPkg.StrategyLoosenCompat()]




# @test result isa GracefulPkg.