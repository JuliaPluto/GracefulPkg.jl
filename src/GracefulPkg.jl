module GracefulPkg



include("./project manifest snapshot.jl")
abstract type Strategy end
include("./report.jl")
include("./context.jl")
include("./strategy.jl")








include("./strategies/nothing.jl")
include("./strategies/remove project manifest.jl")
include("./strategies/update registry.jl")
# include("./strategies/fix stdlibs.jl")


include("./apply strategies.jl")


include("./Pkg API.jl")




end