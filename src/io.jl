

function Base.showerror(io::IO, nw::GracefulPkg.NothingWorked)
    printstyled(io, "GracefulPkg.NothingWorked: The task failed, and no strategies from GracefulPkg could fix it...\n"; bold=true)
    
    report = nw.report
    
    show(io, MIME"text/plain"(), report)
end

function action_text_not_empty(action::Strategy)
    s = action_text(action)
    isempty(s) ? "Doing nothing" : s
end

function Base.show(io::IO, ::MIME"text/plain", report::GracefulPkg.GraceReport)
    reps = report.strategy_reports
    
    printstyled(io, "=== BEGIN GRACEFULPKG REPORT ===\n"; color=:light_black)
    
    if length(reps) == 1 && is_success(report) && reps[1].strategy isa StrategyDoNothing
        printstyled(io, "The task was successfully completed without any actions.\n"; color=:green)
    elseif !isempty(reps)
        actions = unique!([action_text_not_empty(r.strategy) for r in reps])
        
        println(io, "I tried the following actions:")
        for action in actions
            println(io, " - $(action)")
        end
        if is_success(report)
            printstyled(io, length(actions) == 1 ? "And it worked!\n" : "And the last one worked!\n"; color=:green)
        else
            print(io, "But in the end, ")
            printstyled(io, "nothing worked :( \n"; color=:light_red, bold=true)
            println(io, "Here is more information:")
        end
        
        println(io)
        
    
        
        last_shown_exception = Ref("asdf")
        
        for (i, r) in enumerate(reps)
            e_str = sprint(showerror, r.exception; context=io)
            if i == 1
                printstyled(io, "== More details per strategy: ==\n"; color=:light_black)
            else
                printstyled(io, "---------\n"; color=:light_black)
            end
            printstyled(io, "I applied the strategy: $(action_text_not_empty(r.strategy))...\n"; bold=true)
            # println(io)
            if is_success(r)
                printstyled(io, "✔ Task successfully completed.\n"; color=:light_green)
            else
                printstyled(io, "⨯ Task failed. "; color=:light_red)
                printstyled(io, "Captured exception:\n"; color=:light_yellow)
                printstyled(io, e_str == last_shown_exception[] ? "(same as previous)" : e_str)
                last_shown_exception[] = e_str
                println(io)
            end
            
            
            r.project_changed && printstyled(io, "(The Project.toml was changed.)\n"; color=:light_black)
            r.manifest_changed && printstyled(io, "(The Manifest.toml was changed.)\n"; color=:light_black)
            r.registry_changed && printstyled(io, "(The registry was changed.)\n"; color=:light_black)
        end
    
    end
    println(io)
    
    printstyled(io, "=== END GRACEFULPKG REPORT ===\n"; color=:light_black)
end