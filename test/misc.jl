using Test
import GracefulPkg

@test GracefulPkg._find_stdlib_culprits("Dates, Statistics and 'Random'. But not CoolDownloads.") == ["Dates", "Random", "Statistics"]



@test GracefulPkg.stdlibs_past_present_future isa Vector{String}
@test GracefulPkg.stdlibs_past_future isa Vector{String}
@test GracefulPkg.stdlibs_present isa Vector{String}
