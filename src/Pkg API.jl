import Pkg

public resolve

"""
```julia
resolve()
```

Like `Pkg.resolve`, but *gracefully*.
"""
resolve() = gracefully(Pkg.resolve)
