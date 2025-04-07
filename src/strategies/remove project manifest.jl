struct StrategyRemoveManifest <: Strategy end

action_text(::StrategyRemoveManifest) = "Removing Manifest.toml file"

condition(::StrategyRemoveManifest, ctx::StrategyContext) = isfile(manifest_file(ctx))

function action(::StrategyRemoveManifest, ctx::StrategyContext)
    m = manifest_file(ctx)
    isfile(m) && rm(m)
end





##############



struct StrategyRemoveProject <: Strategy end

action_text(::StrategyRemoveProject) = "Removing Project.toml and Manifest.toml files"

condition(::StrategyRemoveProject, ctx::StrategyContext) = isfile(manifest_file(ctx)) || isfile(project_file(ctx))

function action(::StrategyRemoveProject, ctx::StrategyContext)
    m = manifest_file(ctx)
    p = project_file(ctx)
    isfile(m) && rm(m)
    isfile(p) && rm(p)
    @assert !isfile(m)
    @assert !isfile(p)
end



