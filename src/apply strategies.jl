
using Compat

@compat public gracefully


struct NothingWorked <: Exception
    report::GraceReport
end







const DEFAULT_STRATEGIES = (
    StrategyDoNothing(),
    StrategyFixStdlibs(),
    StrategyFixStdlibs(),
    StrategyFixStdlibs(),
    StrategyUpdateRegistry(),
    StrategyLoosenCompat(),
    StrategyRemoveManifest(),
    StrategyRemoveProject(),
)

"""


# Keyword arguments:
- `throw::Bool=true`: If nothing worked, throw?
"""
function gracefully(
    task::Function;
    strategies::Vector{Strategy}=collect(DEFAULT_STRATEGIES),
    throw::Bool=true,
    env_dir::String=dirname(Base.active_project()),
)
    reports = StrategyReport[]

    for strategy in strategies
        @debug "Starting strat" strategy
        snapshot_before = take_project_manifest_snapshot(env_dir)

        context = StrategyContext(;
            env_dir,
            previous_reports=reports,
            previous_exception=isempty(reports) ? nothing : last(reports).exception,
        )

        skip = try
            !condition(strategy, context)
        catch e
            @warn "Strategy condition failed to compute." exception=e
            true
        end
        
        if skip
            continue
        end

        text = action_text(strategy)
        isempty(text) || @warn "Pkg operation failed. $(text) and trying again..."

        # try to fix it!
        try
            action(strategy, context)
        catch e
            @warn "Strategy failed to run." exception=e
        end

        snapshot_after = take_project_manifest_snapshot(env_dir)

        success, return_value, exception, backtrace = try
            # do the user task
            val = task()

            (true, val, nothing, nothing)
        catch e
            (false, nothing, e, catch_backtrace())
        end


        report = StrategyReport(;
            strategy,
            success,

            #
            return_value,
            exception,
            backtrace,

            #
            snapshot_before,
            snapshot_after,

            #
            project_changed=snapshot_before.project != snapshot_after.project,
            manifest_changed=snapshot_before.manifest != snapshot_after.manifest,
            registry_changed=can_change_registry(strategy),
        )

        push!(reports, report)

        if success
            break
        end
    end


    report = GraceReport(
        reports,
    )

    if throw && !last(reports).success
        Base.throw(NothingWorked(report))
    end

    report
end
