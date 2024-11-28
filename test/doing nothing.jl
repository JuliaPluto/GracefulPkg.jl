using Test
using GracefulPkg


@testset "do nothing" begin
    result = GracefulPkg.gracefully(() -> 4567)


    @test result isa GracefulPkg.GraceReport

    r = only(result.strategy_reports)

    @test r isa GracefulPkg.StrategyReport


    @test r.snapshot_before == r.snapshot_after
    @test !isempty(r.snapshot_before.project)
    @test !isempty(r.snapshot_before.manifest)

    @test !r.project_changed
    @test !r.manifest_changed
    @test !r.registry_changed

    @test r.return_value == 4567
    @test r.exception === nothing
    @test r.success
end






# @testset "crash" begin
#     result = GracefulPkg.gracefully(() -> error(9898))


#     @test result isa GracefulPkg.GraceReport

#     r = only(result.strategy_reports)

#     @test r isa GracefulPkg.StrategyReport


#     @test r.snapshot_before == r.snapshot_after
#     @test !isempty(r.snapshot_before.project)
#     @test !isempty(r.snapshot_before.manifest)

#     @test !r.project_changed
#     @test !r.manifest_changed
#     @test !r.registry_changed

# end


