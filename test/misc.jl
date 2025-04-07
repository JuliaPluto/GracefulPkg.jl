using Test
import GracefulPkg

@test GracefulPkg._find_stdlib_culprits("Dates, Statistics and 'Random'. But not CoolDownloads.") == ["Dates", "Random", "Statistics"]
