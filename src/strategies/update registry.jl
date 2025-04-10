import Pkg


struct StrategyUpdateRegistry <: Strategy end
action_text(::StrategyUpdateRegistry) = "Updating registries"


# TODO: a condition here would be great!
# maybe compare the mtime of the Manifest with the mtime of the registry


function action(::StrategyUpdateRegistry, ctx::StrategyContext)
    Pkg.Registry.update()
end



