import Pkg
using Compat

@compat public resolve, instantiate

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
