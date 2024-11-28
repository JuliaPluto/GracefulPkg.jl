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






@testset "crash" begin

    destroy_me = tempname()
    mkpath(destroy_me)
    write(joinpath(destroy_me, "Project.toml"), "nfsdfdse\"")
    write(joinpath(destroy_me, "Manifest.toml"), "whatever")

    i = Ref(100)

    ex = try
        GracefulPkg.gracefully(; env_dir=destroy_me) do
            i[] += 1
            throw(i[])
        end
        nothing
    catch e
        e
    end

    @test ex isa Exception
    @test ex isa GracefulPkg.NothingWorked


    result = ex.report

    @test result isa GracefulPkg.GraceReport

    @test length(result.strategy_reports) > 1


    f = first(result.strategy_reports)
    @test f.strategy isa GracefulPkg.StrategyDoNothing
    @test !f.success
    @test f.exception == 101

    @test f.snapshot_before.manifest == "whatever"

    r = last(result.strategy_reports)
    @test typeof(r.strategy) !== GracefulPkg.StrategyDoNothing

    @test r.return_value === nothing
    @test r.exception > 101
    @test !r.success
end


