import Pkg


struct StrategyUpdateRegistry <: Strategy end
action_text(::StrategyUpdateRegistry) = "Updating registries"


# TODO: a condition here would be great!




function action(::StrategyUpdateRegistry, ctx::StrategyContext)
    Pkg.Registry.update()
end



