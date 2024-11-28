# GracefulPkg.jl *(WIP)*


GracefulPkg can `resolve` or `instantiate` an environment, and automatically fix issues when they happen! 

For example, when resolving an environment that was originally created in another Julia version, Pkg might fail. GracefulPkg will automatically deploy strategies to fix it, until the resolve worked.


## Use in Pluto.jl
*(TODO)* GracefulPkg.jl is used by [Pluto.jl](https://plutojl.org/) when launching a notebook with an embedded package environment. Pluto will try to reproduce the environment used to write the notebook. If this does not work, the strategies from GracefulPkg are used to make sure that the notebook can still launch.

TODO this code is currently still in the Pluto codebase as the function `with_auto_fixes`.

## Strategies
GracefulPkg comes with the following strategies as defaults:
1. Do nothing
1. *(TODO)* Run `Pkg.build` on packages that asked for it
1. Update registries
1. *(TODO)* Fix any stdlib compat issues (from "freed" stdlibs like Statistics or new stdlibs like StyledStrings)
1. Remove the Manifest.toml file, leaving only the Project.toml and *(TODO)* automatically add missing compat entries generated from the Manifest.toml
1. Remove the Manifest.toml and Project.toml files



# Test
*(TODO)* This package is tested against a library of Project.toml + Manifest.toml files that we found in the wild, or that we hand-crafted to simulate a possible tricky situation.

