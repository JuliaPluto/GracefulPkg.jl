using Compat

@compat public ProjectManifestSnapshot, take_project_manifest_snapshot

"""
The contents of the Project.toml and Manifest.toml files at the time of recording. `nothing` if a file does not exist.
"""
Base.@kwdef struct ProjectManifestSnapshot
    project::Union{Nothing,String} = nothing
    manifest::Union{Nothing,String} = nothing
end


"""
```julia
take_project_manifest_snapshot(env_dir::String)::ProjectManifestSnapshot
```

Take a snapshot of the Project.toml and Manifest.toml files in the given environment directory. Returns a [`ProjectManifestSnapshot`](@ref) object.
"""
function take_project_manifest_snapshot(env_dir::String)
    p = joinpath(env_dir, "Project.toml")
    m = joinpath(env_dir, "Manifest.toml")

    ProjectManifestSnapshot(
        isfile(p) ? read(p, String) : nothing,
        isfile(m) ? read(m, String) : nothing,
    )
end

