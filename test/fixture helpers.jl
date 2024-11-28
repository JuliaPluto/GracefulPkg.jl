
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