using JSOSolverSkeleton
using Documenter

DocMeta.setdocmeta!(JSOSolverSkeleton, :DocTestSetup, :(using JSOSolverSkeleton); recursive = true)

makedocs(;
  modules = [JSOSolverSkeleton],
  doctest = true,
  linkcheck = true,
  authors = "Abel Soares Siqueira <abel.s.siqueira@gmail.com> and contributors",
  repo = "https://github.com/JuliaSmoothOptimizers/JSOSolverSkeleton.jl/blob/{commit}{path}#{line}",
  sitename = "JSOSolverSkeleton.jl",
  format = Documenter.HTML(;
    prettyurls = get(ENV, "CI", "false") == "true",
    canonical = "https://JuliaSmoothOptimizers.github.io/JSOSolverSkeleton.jl",
    assets = ["assets/style.css"],
  ),
  pages = [
    "Home" => "index.md",
    "Contributing" => "contributing.md",
    "Dev setup" => "developer.md",
    "Reference" => "reference.md",
  ],
)

deploydocs(; repo = "github.com/JuliaSmoothOptimizers/JSOSolverSkeleton.jl", push_preview = true)
