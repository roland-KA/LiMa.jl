# execute this file from the `docs` folder using: `julia --project="." --color=yes make.jl`

using Documenter
using LiMa

push!(LOAD_PATH,"../src/")

makedocs(
    modules = [LiMa],
    sitename="LiMa - A Library Manager",
    format = Documenter.HTML(
        edit_link = nothing,
        prettyurls = false,                         # for local use 
        assets = ["assets/custom.css",]),          # custom fonts & colors
    pages = [
        "Introduction" => "index.md",
        "AppCore" => Any[
            "AppCore Overview" => "AppCore/AppCore.md",
            "AppCore/UserManager.md"],
        "StorageManager" => "StorageManager.md"],
    authors = "Dr. Roland Schätzle",
    doctest = false
)
