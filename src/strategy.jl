

condition(::Strategy, ::StrategyContext) = true
action(t::Strategy, ::StrategyContext) = error("Not implemented for $(typeof(t))")
action_text(t::Strategy) = "Trying strategy $(typeof(t))"

can_change_registry(::Strategy) = false
