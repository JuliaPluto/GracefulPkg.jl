struct StrategyInstantiateIfNeeded <: Strategy end

action_text(::StrategyInstantiateIfNeeded) = "Instantiating"

function action(ifn::StrategyInstantiateIfNeeded, ctx::StrategyContext)
    with_active_env(ctx.env_dir) do
        Pkg.instantiate()
    end
end

function condition(::StrategyInstantiateIfNeeded, ctx::StrategyContext)
    occursin(r"expected.+to exist at path"i, string(ctx.previous_exception))
end
