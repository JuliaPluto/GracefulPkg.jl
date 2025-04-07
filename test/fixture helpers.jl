
import GracefulPkg
import Pkg



function go(original_dir)

    dir = tempname() * " grace " * basename(original_dir)

    cp(original_dir, dir)


    @assert isdir(dir)
    @assert !isempty(readdir(dir))

    result = Pkg.activate(dir) do
        GracefulPkg.resolve()
    end
end


function final_project_manifest_parsed(result)
    sa = result.strategy_reports[end].snapshot_after
    
    yo(x::Nothing) = nothing
    yo(x::String) = Pkg.TOML.parse(x)

    yo(sa.project), yo(sa.manifest)
end