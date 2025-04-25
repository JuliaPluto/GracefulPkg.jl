import Pkg
import TOML



# Default action: try the user task without changes

struct StrategyDoNothing <: Strategy
    auto_upgrade_old_manifest_format::Bool
end

StrategyDoNothing() = StrategyDoNothing(true)


action_text(::StrategyDoNothing) = ""
function action(strat::StrategyDoNothing, ctx::StrategyContext)
    if strat.auto_upgrade_old_manifest_format
        m = manifest_file(ctx)
        if isfile(m)
            mdata = try
                TOML.parsefile(m)
            catch e
                @debug "Failed to parse Manifest.toml" exception=(e, catch_backtrace())
                Dict{String,Any}()
            end
            
            is_old = get(mdata, "manifest_format", "1.0") == "1.0"
            if is_old
                try
                    @debug "Upgrading Manifest.toml to new format"
                    # TODO ENV
                    Pkg.upgrade_manifest()
                catch e
                    @debug "Failed upgrade manifest" exception=(e, catch_backtrace())
                end
                        
            end
        end
    end
    
end