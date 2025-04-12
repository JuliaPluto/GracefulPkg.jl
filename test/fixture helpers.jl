
import GracefulPkg
import Pkg
using Logging

function go(original_dir)

    dir = tempname() * " grace " * basename(original_dir)

    cp(original_dir, dir)


    @assert isdir(dir)
    @assert !isempty(readdir(dir))

    get_deps_safe() =
        try
            collect(keys(TOML.parsefile(joinpath(dir, "Project.toml"))["deps"]))
        catch
            String[]
        end

    deps_before = get_deps_safe()

    try
        result = Pkg.activate(dir) do
            GracefulPkg.resolve()
            # TODO:
            # GracefulPkg.instantiate(; update_registry=false, allow_autoprecomp=false)
        end
        # this should work
        Pkg.activate(@__DIR__) do
            Pkg.dependencies()
        end
        # this should work
        GracefulPkg.instantiate(; update_registry=false, allow_autoprecomp=false)


        @assert deps_before == get_deps_safe()

        result
    catch e
        if e isa GracefulPkg.NothingWorked
            rep = e.report
            for sr in rep.strategy_reports
                @error "Testsssss captured exceptions" sr.strategy exception = (sr.exception, sr.backtrace)
            end
        end
        rethrow()
    end
end


function final_project_manifest_parsed(result)
    sa = result.strategy_reports[end].snapshot_after

    yo(x::Nothing) = nothing
    yo(x::String) = Pkg.TOML.parse(x)

    yo(sa.project), yo(sa.manifest)
end



function test_max_severity(report::GracefulPkg.GraceReport, type::Type)
    types = [typeof(r.strategy) for r in report.strategy_reports]

    exceeds_severity = !(last(types) == type || type ∉ types)

    zzzzz = something(findfirst(x -> x == type, types), -1)

    if exceeds_severity
        @error "Severity check failed." max_severity_permitted = type found = last(types)
        for (i, sr) in enumerate(report.strategy_reports)
            level = i < zzzzz ? Logging.Info : i === zzzzz ? Logging.Error : Logging.Warn
            @logmsg level "Testsssss captured exceptions" sr.strategy exception = (sr.exception, sr.backtrace)
        end
    end

    !exceeds_severity
end