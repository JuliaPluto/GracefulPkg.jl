include("./fixture helpers.jl")

# We have our own registry for these test! Take a look at https://github.com/JuliaPluto/PlutoPkgTestRegistry#readme for more info about the test packages and their dependencies.

const pluto_test_registry_spec = Pkg.RegistrySpec(;
    url="https://github.com/JuliaPluto/PlutoPkgTestRegistry",
    uuid=Base.UUID("96d04d5f-8721-475f-89c4-5ee455d3eda0"),
    name="PlutoPkgTestRegistry",
)
if basename(homedir()) != "fons"
    Pkg.Registry.add(pluto_test_registry_spec)
end


for dotjulia in Base.DEPOT_PATH
    pptf = joinpath(dotjulia, "packages", "PlutoPkgTestF")
    isdir(pptf) && rm(pptf, recursive=true)
end





dir = joinpath(@__DIR__, "fixtures")



fixture_test_commands = Expr[]

for d in readdir(dir)
    file = joinpath(dir, d, "test.jl")

    inner = if !isfile(file)
        @warn "No test file for $(d)" file
        nothing
    else
        :(include($(file)))
    end
    push!(fixture_test_commands, :(@testset $(d) begin
        $(inner)
    end))

end

eval(:(
    @testset "fixtures" begin
    $(Expr(:block, fixture_test_commands...))
end
))