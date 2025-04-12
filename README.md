# GracefulPkg.jl

GracefulPkg can `resolve` or `instantiate` an environment, and automatically fix issues when they happen! 

For example, when resolving an environment that was originally created in another Julia version, Pkg might fail. GracefulPkg will automatically deploy strategies to fix it, until the resolve worked. Deleting the Manifest.toml file is one of the strategies, but it will try less invasive strategies first.

> **Why?**
> The problem that this package solves is to be able to instantiate **any environment** without user intervention, even if it was created at a different time, on a different Julia version, in a different reality, whatever.
> 
> You can always just delete Manifest.toml and delete `[compat]` from Project.toml, but this package tries to keep as much of the original environment as possible.


```julia
import GracefulPkg
import Pkg
Pkg.activate("path/to/your/project")


Pkg.resolve() # fails!

GracefulPkg.resolve() # works!
```


## Use in Pluto.jl
*(TODO after release)* GracefulPkg.jl is used by [Pluto.jl](https://plutojl.org/) when launching a notebook with an embedded package environment. Pluto will try to reproduce the environment used to write the notebook. If this does not work, the strategies from GracefulPkg are used to make sure that the notebook can still launch.

TODO this code is currently still in the Pluto codebase as the function `with_auto_fixes`.

> 🙋 GracefulPkg is based on experiences from the Pluto developers, seeing countless notebooks "in the wild". Pluto notebooks should **always run**, trying to maintain as much of the original environment as possible. The strategies in GracefulPkg were found to fix most environments in the least invasive way possible.

## Strategies
GracefulPkg comes with the following strategies as defaults:
1. Do nothing
1. Fix any stdlib compat issues (from "freed" stdlibs like Statistics or new stdlibs like StyledStrings)
1. *(TODO)* Run `Pkg.build` on packages that asked for it
1. Update registries
1. Remove Manifest.toml
1. Remove Manifest.toml and loosen any version compat entries from Project.toml, leaving only `[deps]`.


# Test
This package is tested against [a library](https://github.com/JuliaPluto/GracefulPkg.jl/tree/main/test/fixtures) of Project.toml + Manifest.toml files that we found in the wild, or that we hand-crafted to simulate a possible tricky situation.


This package is also tested with some older Julia versions (1.6, 1.8 and 1.9). This increases the number of tricky Julia combinations that we can test against, which hopefully means the package is more robust (for future Julia versions).
