import Pkg


function is_resolve_error(ctx::StrategyContext)
    ctx.previous_exception isa Pkg.Resolve.ResolverError
end




# for writing TOML files

function write_project_toml(project_path::String, toml)
    write(project_path, sprint() do io
        Pkg.TOML.print(io, toml; sorted=true, by=(key -> (_project_key_order(key), key)))
    end)
end

const _project_key_order_list = ["name", "uuid", "keywords", "license", "desc", "deps", "weakdeps", "sources", "extensions", "compat"]
_project_key_order(key::String) =
    something(findfirst(x -> x == key, _project_key_order_list), length(_project_key_order_list) + 1)



function with_active_env(f::Function, env_dir::String)
    original_LP = copy(LOAD_PATH)
    original_AP = Base.ACTIVE_PROJECT[]
    
    
    new_LP = ["@", "@stdlib"]
    new_AP = env_dir
    try
        # Activate the environment
        copy!(LOAD_PATH, new_LP)
        Base.ACTIVE_PROJECT[] = new_AP
        
        f()
    finally
        # Reset the pkg environment
        copy!(LOAD_PATH, original_LP)
        Base.ACTIVE_PROJECT[] = original_AP
    end
end