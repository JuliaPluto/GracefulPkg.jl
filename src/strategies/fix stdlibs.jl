import Pkg

struct StrategyFixStdlibs <: Strategy end

action_text(::StrategyFixStdlibs) = "Fixing stdlib dependencies"


# You need to regenerate this list for every new Julia version. Just do sort(union(Pluto._stdlibs_including_former_stdlibs, Pluto._stdlibs_found)) |> repr |> clipboaard
const _stdlibs_including_former_stdlibs = ["ArgTools", "Artifacts", "Base64", "CRC32c", "CompilerSupportLibraries_jll", "Dates", "DelimitedFiles", "Distributed", "Downloads", "FileWatching", "Future", "GMP_jll", "InteractiveUtils", "JuliaSyntaxHighlighting", "LLD_jll", "LLVMLibUnwind_jll", "LazyArtifacts", "LibCURL", "LibCURL_jll", "LibGit2", "LibGit2_jll", "LibOSXUnwind_jll", "LibSSH2_jll", "LibUV_jll", "LibUnwind_jll", "Libdl", "LinearAlgebra", "Logging", "MPFR_jll", "Markdown", "MbedTLS_jll", "Mmap", "MozillaCACerts_jll", "NetworkOptions", "OpenBLAS_jll", "OpenLibm_jll", "OpenSSL_jll", "PCRE2_jll", "Pkg", "Printf", "Profile", "REPL", "Random", "SHA", "Serialization", "SharedArrays", "Sockets", "SparseArrays", "Statistics", "StyledStrings", "SuiteSparse", "SuiteSparse_jll", "TOML", "Tar", "Test", "UUIDs", "Unicode", "Zlib_jll", "dSFMT_jll", "libLLVM_jll", "libblastrampoline_jll", "nghttp2_jll", "p7zip_jll"]
const _stdlibs_found = sort(readdir(Sys.STDLIB))

const _stdlib_old_or_new = sort(union(_stdlibs_including_former_stdlibs, _stdlibs_found))


_find_stdlib_culprits(ctx::StrategyContext) = _find_stdlib_culprits(string(ctx.previous_exception))

function _find_stdlib_culprits(exception_string::String)
    clean_exception_string = replace(
        exception_string, 
        # Pkg.Resolver.whatever can show up in the error message, lets ignore it
        "Pkg." => "", 
        # not a TOML loading issue
        "TOML Parse" => "",
        # ANSI escape codes
        r"\\e\[[0-9;]*[a-zA-Z]" => "",
    )
    
    filter(_stdlib_old_or_new) do stdlib
        pattern = Regex("(^|[^\\w])$(stdlib)(\$|[^\\w])")
        occursin(pattern, clean_exception_string)
    end
end

function condition(::StrategyFixStdlibs, ctx::StrategyContext)
    if last(ctx.previous_reports).snapshot_after.project === nothing
        return false
    end
        
    # A stdlib name occurs in the error message
    !isempty(_find_stdlib_culprits(ctx))
end



function action(::StrategyFixStdlibs, ctx::StrategyContext)
    culprits = _find_stdlib_culprits(ctx)
    deps = let
        proj = TOML.parsefile(project_file(ctx))
        keys(get(proj, "deps", Dict()))
    end
    
    to_fix = intersect(culprits, deps)
    isempty(to_fix) && return
    
    @debug "Fixing stdlibs" to_fix culprits string(ctx.previous_exception)
    _delete_compat_entries(ctx, to_fix)
    # TODO this isnt it... they might not be direct deps
    # it's about updating
    Pkg.rm(to_fix)
    Pkg.add(to_fix)
    _delete_compat_entries(ctx, to_fix)

end




