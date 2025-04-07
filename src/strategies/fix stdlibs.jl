
struct StrategyFixStdlibs <: Strategy end

action_text(::StrategyFixStdlibs) = "Fixing stdlib dependencies"



function condition(::StrategyFixStdlibs, ctx::StrategyContext)

    error()
end



function action(::StrategyFixStdlibs, ctx::StrategyContext)
    error()
end




# TODO i need to be repeated?


