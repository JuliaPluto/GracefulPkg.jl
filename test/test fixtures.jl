include("./fixture helpers.jl")

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