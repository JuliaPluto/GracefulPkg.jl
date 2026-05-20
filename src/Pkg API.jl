import Pkg
using Compat

@compat public resolve, instantiate, addname

"""
```julia
resolve(args...; kwargs...)
```

Like `Pkg.resolve`, but *gracefully*.
"""
resolve(args...; kwargs...) =
    gracefully() do
        Pkg.resolve(args...; kwargs...)
    end


"""
```julia
instantiate(args...; kwargs...)
```

Like `Pkg.instantiate`, but *gracefully*.
"""
instantiate(args...; kwargs...) =
    gracefully() do
        Pkg.instantiate(args...; kwargs...)
    end

"""
```julia
addname(args...; kwargs...)
```

Like `Pkg.add`, but *gracefully*. Just adds the dependency
in Project.toml and then calls instantiate. May fail.
"""
addname(name, kwargs...) = begin
    project = Pkg.project()
    registries = Pkg.Registry.reachable_registries()
    elem = vcat([Pkg.Registry.uuids_from_name(reg, name) for reg in registries]...)
    toml = Pkg.TOML.parse(read(project.path, String))
    push!(toml["deps"], name => string(elem[1]))
    println(toml)
    f = open(project.path, "w")
    Pkg.TOML.print(f, toml)
    close(f)
    Pkg.activate(dirname(project.path))
    gracefully() do
        Pkg.resolve()
    end
end
