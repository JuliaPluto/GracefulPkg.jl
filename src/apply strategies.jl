using Compat

@compat public StrategyDoNothing, StrategyFixStdlibs, StrategyUpdateRegistry, StrategyLoosenCompat, StrategyRemoveManifest, StrategyRemoveManifestAndCompat, StrategyRemoveProject

@compat public gracefully, DEFAULT_STRATEGIES, NothingWorked


struct NothingWorked <: Exception
    report::GraceReport
end


const DEFAULT_STRATEGIES = (
    StrategyDoNothing(),
    # many times, because you might need to fix stdlibs multiple times (first you get an error message about ExampleA, and fixing it reveals an error about ExampleB)
    StrategyFixStdlibs(),
    StrategyFixStdlibs(),
    StrategyFixStdlibs(),
    StrategyFixStdlibs(),
    StrategyFixStdlibs(),
    StrategyFixStdlibs(),
    StrategyFixStdlibs(),
    # TODO: StrategyPkgResolve(),
    StrategyUpdateRegistry(),
    StrategyLoosenCompat(),
    StrategyRemoveManifest(),
    StrategyRemoveManifestAndCompat(),
    StrategyRemoveProject(),
)

"""
```julia
gracefully(task::Function; strategies=collect(DEFAULT_STRATEGIES), throw=true, env_dir=dirname(Base.active_project()))::GraceReport
```

Execute the given `task` function, automatically fixing package environment issues if the task fails.

The function will try different strategies in sequence until the task succeeds. Each strategy attempts to fix common package environment issues, such as:
- Fixing stdlib compatibility issues
- Updating package registries
- Loosening version compatibility requirements
- Removing Manifest.toml or Project.toml files

# Arguments
- `task::Function`: The function to execute in the package environment

# Keyword Arguments
- `strategies::Vector{Strategy}=collect(DEFAULT_STRATEGIES)`: List of strategies to try, in order
- `throw::Bool=true`: If true, throws a `NothingWorked` exception when all strategies fail
- `env_dir::String=dirname(Base.active_project())`: Directory containing the package environment files

# Returns
A `GraceReport` containing details about which strategies were attempted and their results.

# Example
```julia
gracefully() do
    Pkg.instantiate()
end
```
"""
function gracefully(
    task::Function;
    strategies::Vector{Strategy}=collect(DEFAULT_STRATEGIES),
    throw::Bool=true,
    env_dir::String=dirname(Base.active_project()),
)::GraceReport
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
            @warn "Strategy condition failed to compute." exception = e
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
            @warn "Strategy failed to run." exception = e
        end

        snapshot_after = take_project_manifest_snapshot(env_dir)

        success, return_value, exception, backtrace = try
            # do the user task
            val = task()

            (true, val, nothing, nothing)
        catch e
            (false, nothing, e, catch_backtrace())
        end

        # TODO: restore the Project+Manifest?


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
