import Pkg
import TOML


struct StrategyLoosenCompat <: Strategy end

action_text(::StrategyLoosenCompat) = "Loosening compatibility bounds"



function _find_compat_culprits(ctx::StrategyContext, d)
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
    return !isempty(_find_compat_culprits(ctx, d))
end



function action(::StrategyLoosenCompat, ctx::StrategyContext)
    m = manifest_file(ctx)
    isfile(m) && rm(m)

    p = project_file(ctx)
    d = TOML.parsefile(p)
    culprits = _find_compat_culprits(ctx, d)

    _delete_compat_entries(ctx, culprits)
    # TODO: also delete sources! or is that another strat? or maybe that should never be done?
end

function _delete_compat_entries(ctx::StrategyContext, culprits)
    p = project_file(ctx)
    d = TOML.parsefile(p)
    for culprit in culprits
        delete!(d["compat"], culprit)
    end
    write_project_toml(p, d)
end






################


struct StrategyRemoveManifestAndCompat <: Strategy end

action_text(::StrategyRemoveManifestAndCompat) = "Removing Manifest.toml file and all compat entries"

condition(::StrategyRemoveManifestAndCompat, ctx::StrategyContext) = isfile(manifest_file(ctx)) || isfile(project_file(ctx)) # TODO check if has compat

function action(::StrategyRemoveManifestAndCompat, ctx::StrategyContext)
    m = manifest_file(ctx)
    p = project_file(ctx)

    isfile(m) && rm(m)
    @assert !isfile(m)

    p = project_file(ctx)
    d = TOML.parsefile(p)
    haskey(d, "compat") && delete!(d, "compat")
    write_project_toml(p, d)
end



