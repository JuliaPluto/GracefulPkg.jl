
# Default action: try the user task without changes

struct StrategyDoNothing <: Strategy end
action(::StrategyDoNothing, ::StrategyContext) = nothing
action_text(::StrategyDoNothing) = ""