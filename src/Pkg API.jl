import Pkg
using Compat

@compat public resolve

"""
```julia
resolve()
```

Like `Pkg.resolve`, but *gracefully*.
"""
resolve() = gracefully(Pkg.resolve)
