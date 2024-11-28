
"""
The contents of the Project.toml and Manifest.toml files at the time of recording.
"""
Base.@kwdef struct ProjectManifestSnapshot
    project::Union{Nothing,String} = nothing
    manifest::Union{Nothing,String} = nothing
end

function take_project_manifest_snapshot(env_dir::String)
    p = joinpath(env_dir, "Project.toml")
    m = joinpath(env_dir, "Manifest.toml")

    ProjectManifestSnapshot(
        isfile(p) ? read(p, String) : nothing,
        isfile(m) ? read(m, String) : nothing,
    )
end

