

function Base.showerror(io::IO, nw::GracefulPkg.NothingWorked)
    printstyled(io, "GracefulPkg.NothingWorked: Nothing worked...\n"; bold=true)
    
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
    
    if !isempty(reps)
        actions = unique!([action_text_not_empty(r.strategy) for r in reps])
        
        println(io, "I tried the following actions:")
        for action in actions
            println(io, " - $(action)")
        end
        println(io)
    
        
        last_shown_exception = Ref("asdf")
        
        for r in reps
            e_str = sprint(showerror, r.exception; context=io)
            printstyled(io, "-----------\n"; color=:light_black)
            printstyled(io, "Applying strategy: $(action_text_not_empty(r.strategy))...\n"; bold=true)
            # println(io)
            if r.success
                printstyled(io, "Task successfully completed.\n"; color=:green)
            else
                printstyled(io, "Task failed. "; color=:red)
                printstyled(io, "Captured exception: "; color=:light_black)
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