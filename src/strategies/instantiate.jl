struct InstantiateIfNeeded <: Strategy end

action_text(::InstantiateIfNeeded) = "Instantiating"


function action(ifn::InstantiateIfNeeded, ctx::StrategyContext)
    with_active_env(ctx.env_dir) do
        Pkg.instantiate()
    end
end


function condition(::InstantiateIfNeeded, ctx::StrategyContext)
    occursin(r"expected.+to exist at path"i, string(ctx.previous_exception))
end
