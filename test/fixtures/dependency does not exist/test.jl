result = go(@__DIR__)
strats = [r.strategy for r in result.strategy_reports]

@test strats == [GracefulPkg.StrategyDoNothing(), GracefulPkg.StrategyUpdateRegistry(), GracefulPkg.StrategyLoosenCompat()]


@test_broken false # huh why does this work without removing the Project?

# @test result isa GracefulPkg.