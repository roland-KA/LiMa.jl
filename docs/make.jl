# execute this file from the `docs` folder using: `julia --project="." --color=yes make.jl`

using Documenter
using LiMa

push!(LOAD_PATH,"../src/")

makedocs(
    modules = [LiMa],
    sitename="LiMa - A Library Manager",
    format = Documenter.HTML(
        edit_link = nothing,
        prettyurls = get(ENV, "CI", nothing) == "true",     # local/web use 
        assets = ["assets/custom.css",]),                   # custom fonts & colors
    pages = [
        "Introduction" => "index.md",
        "AppCore" => Any[
            "AppCore Overview" => "AppCore/AppCore.md",
            "AppCore/UserManager.md"],
        "StorageManager" => "StorageManager.md"],
    authors = "Dr. Roland Schätzle",
    doctest = false
)
deploydocs(
    repo = "github.com/roland-KA/LiMa.jl.git",
)
