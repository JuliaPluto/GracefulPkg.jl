module GracefulPkg



include("./project manifest snapshot.jl")
abstract type Strategy end
include("./report.jl")
include("./context.jl")
include("./strategy.jl")








include("./strategies/common.jl")
include("./strategies/nothing.jl")
include("./strategies/instantiate if needed.jl")
include("./strategies/remove project manifest.jl")
include("./strategies/update registry.jl")
include("./strategies/loosen compat.jl")
include("./strategies/fix stdlibs.jl")


include("./apply strategies.jl")


include("./Pkg API.jl")

include("./io.jl")



end