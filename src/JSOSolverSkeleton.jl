module JSOSolverSkeleton

# standard lib
using LinearAlgebra

# JSO packages
using NLPModels
using SolverCore
import SolverCore.solve!
export solve!

include("simple-unc-solver.jl")

end
