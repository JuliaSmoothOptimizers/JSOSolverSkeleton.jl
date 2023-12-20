# JSOSolverSkeleton

<!-- This check was disabled because these links don't exist until you push, create documentation, and create your first release -->
<!-- markdown-link-check-disable -->
[![Stable Documentation](https://img.shields.io/badge/docs-stable-blue.svg)](https://JuliaSmoothOptimizers.github.io/JSOSolverSkeleton.jl/stable)
[![In development documentation](https://img.shields.io/badge/docs-dev-blue.svg)](https://JuliaSmoothOptimizers.github.io/JSOSolverSkeleton.jl/dev)
[![Build Status](https://github.com/JuliaSmoothOptimizers/JSOSolverSkeleton.jl/workflows/Test/badge.svg)](https://github.com/JuliaSmoothOptimizers/JSOSolverSkeleton.jl/actions)
[![Test workflow status](https://github.com/JuliaSmoothOptimizers/JSOSolverSkeleton.jl/actions/workflows/Test.yml/badge.svg?branch=main)](https://github.com/JuliaSmoothOptimizers/JSOSolverSkeleton.jl/actions/workflows/Test.yml?query=branch%3Amain)
[![Lint workflow Status](https://github.com/JuliaSmoothOptimizers/JSOSolverSkeleton.jl/actions/workflows/Lint.yml/badge.svg?branch=main)](https://github.com/JuliaSmoothOptimizers/JSOSolverSkeleton.jl/actions/workflows/Lint.yml?query=branch%3Amain)
[![Docs workflow Status](https://github.com/JuliaSmoothOptimizers/JSOSolverSkeleton.jl/actions/workflows/Docs.yml/badge.svg?branch=main)](https://github.com/JuliaSmoothOptimizers/JSOSolverSkeleton.jl/actions/workflows/Docs.yml?query=branch%3Amain)
[![Build Status](https://api.cirrus-ci.com/github/JuliaSmoothOptimizers/JSOSolverSkeleton.jl.svg)](https://cirrus-ci.com/github/JuliaSmoothOptimizers/JSOSolverSkeleton.jl)
[![Coverage](https://codecov.io/gh/JuliaSmoothOptimizers/JSOSolverSkeleton.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/JuliaSmoothOptimizers/JSOSolverSkeleton.jl)
[![DOI](https://zenodo.org/badge/DOI/FIXME)](https://doi.org/FIXME)
<!-- markdown-link-check-enable -->

--------------

*JSOSolverSkeleton* is a solver for constrained nonlinear problems, i.e.,
optimization problems of the form

```math
\begin{aligned}
\min \quad & f(x) \\
& c_L \leq c(x) \leq c_U \\
& \ell \leq x \leq u,
\end{aligned}
```

It uses other [JuliaSmoothOptimizers](https://jso.dev) packages for development.
In particular, [NLPModels.jl](https://github.com/JuliaSmoothOptimizers/NLPModels.jl) is used for defining the problem, and [SolverCore](https://github.com/JuliaSmoothOptimizers/SolverCore.jl) for the output.

## How to Cite

If you use JSOSolverSkeleton.jl in your work, please cite using the format given in [CITATION.cff](https://github.com/JuliaSmoothOptimizers/JSOSolverSkeleton.jl/blob/main/CITATION.cff).

## Installation

<p>
JSOSolverSkeleton is a &nbsp;
    <a href="https://julialang.org">
        <img src="https://raw.githubusercontent.com/JuliaLang/julia-logo-graphics/master/images/julia.ico" width="16em">
        Julia Language
    </a>
    &nbsp; package. To install JSOSolverSkeleton,
    please <a href="https://docs.julialang.org/en/v1/manual/getting-started/">open
    Julia's interactive session (known as REPL)</a> and press <kbd>]</kbd> key in the REPL to use the package mode, then type the following command
</p>

```julia
pkg> add JSOSolverSkeleton
```

## Example

```julia
using JSOSolverSkeleton, ADNLPModels

# Rosenbrock
nlp = ADNLPModel(x -> 100 * (x[2] - x[1]^2)^2 + (x[1] - 1)^2, [-1.2; 1.0])
stats = jsosolverskeleton(nlp)
```

## Contributing

If you think you found a bug, feel free to open an [issue](https://github.com/JuliaSmoothOptimizers/JSOSolverSkeleton.jl/issues).
Focused suggestions and requests can also be opened as issues. Before opening a pull request, start an issue or a discussion on the topic, please.

If you want to make contributions of any kind, please first that a look into our [contributing guide directly on GitHub](docs/src/contributing.md) or the [contributing page on the website](https://JuliaSmoothOptimizers.github.io/JSOSolverSkeleton.jl/dev/contributing/).

---

This repo was created with the [COPIERTemplate.jl](https://github.com/abelsiqueira/COPIERTemplate.jl) package.
