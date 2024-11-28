
Base.@kwdef struct StrategyContext
    env_dir::String
    previous_reports::Vector{StrategyReport}
    previous_exception
end

project_file(ctx::StrategyContext) = joinpath(ctx.env_dir, "Project.toml")
manifest_file(ctx::StrategyContext) = joinpath(ctx.env_dir, "Manifest.toml")