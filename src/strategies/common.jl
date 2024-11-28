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




