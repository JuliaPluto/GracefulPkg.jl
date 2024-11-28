import Pkg
import TOML


struct StrategyLoosenCompat <: Strategy end

action_text(::StrategyLoosenCompat) = "Loosening compatibility bounds"



function find_culprits(ctx::StrategyContext, d)
    error_str = string(ctx.previous_exception)

    filter(keys(d["compat"])) do package_name
        occursin(package_name, error_str)
    end
end


function condition(::StrategyLoosenCompat, ctx::StrategyContext)
    isfile(project_file(ctx)) || return false
    is_resolve_error(ctx) || return false

    p = project_file(ctx)
    d = try
        TOML.parsefile(p)
    catch
        return false
    end

    haskey(d, "compat") || return false

    # does one of the packages with a compat entry occur in the resolver error?
    return !isempty(find_culprits(ctx, d))
end



function action(::StrategyLoosenCompat, ctx::StrategyContext)
    m = manifest_file(ctx)
    isfile(m) && rm(m)


    p = project_file(ctx)
    d = TOML.parsefile(p)

    culprits = find_culprits(ctx, d)

    for culprit in culprits
        delete!(d["compat"], culprit)
    end

    # TODO: also delete sources! or is that another strat?

    write_project_toml(p, d)
end




