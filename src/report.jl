using Compat

@compat public StrategyReport, GraceReport, is_success


Base.@kwdef struct StrategyReport
    strategy::Strategy

    success::Bool

    # logs::String

    return_value::Any = nothing
    exception::Any = nothing
    backtrace::Any = nothing

    snapshot_before::ProjectManifestSnapshot = ProjectManifestSnapshot()
    snapshot_after::ProjectManifestSnapshot = ProjectManifestSnapshot()

    project_changed::Bool
    manifest_changed::Bool
    registry_changed::Bool
end



struct GraceReport
    strategy_reports::Vector{StrategyReport}
end


is_success(rep::StrategyReport) = rep.success
is_success(rep::GraceReport) = any(Iterators.map(is_success, rep.strategy_reports))
