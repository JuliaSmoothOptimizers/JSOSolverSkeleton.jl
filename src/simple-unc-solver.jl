export simple_unc_solver, SimpleUncSolver

"""
    simple_unc_solver(nlp; options...)

Template for an unconstrained solver using the first order conditions

    ‖∇f(xₖ)‖ ≤ ϵₐ + ϵᵣ‖∇f(x₀)‖,

where ϵₐ is an absolute tolerance and ϵᵣ is a relative tolerance.

For advanced usage, create a `SimpleUncSolver` to preallocate the memory used in the algorithm, and then call `solve!`.

    solver = SimpleUncSolver(nlp)
    solve!(solver, nlp; kwargs...)

# Arguments

- `nlp::AbstractNLPModel{T, V}` represents the model to solve, see `NLPModels.jl`.
The keyword arguments may include
- `x::V = nlp.meta.x0`: the initial guess.
- `atol::T = √eps(T)`: absolute tolerance.
- `rtol::T = √eps(T)`: relative tolerance, the algorithm stops when ‖∇f(xᵏ)‖ ≤ atol + rtol * ‖∇f(x⁰)‖.
- `max_eval::Int = -1`: maximum number of objective function evaluations.
- `max_time::Float64 = 30.0`: maximum time limit in seconds.
- `max_iter::Int = typemax(Int)`: maximum number of iterations.
- `verbose::Int = 0`: if > 0, display iteration details every `verbose` iteration.

# Output

The returned value is a `GenericExecutionStats`, see `SolverCore.jl`.

# Callback

The callback is called at each iteration.
The expected signature of the callback is `callback(nlp, solver, stats)`, and its output is ignored.
Changing any of the input arguments will affect the subsequent iterations.
In particular, setting `stats.status = :user` will stop the algorithm.
All relevant information should be available in `nlp` and `solver`.
Notably, you can access, and modify, the following:

- `solver.x`: current iterate;
- `solver.gx`: current gradient;
- `stats`: structure holding the output of the algorithm (`GenericExecutionStats`), which contains, among other things:
  - `stats.dual_feas`: norm of current gradient;
  - `stats.iter`: current iteration counter;
  - `stats.objective`: current objective function value;
  - `stats.status`: current status of the algorithm. Should be `:unknown` unless the algorithm has found a stopping criteria. Changing this to anything will stop the algorithm, but you should use `:user` to properly indicate the intention.
  - `stats.elapsed_time`: elapsed time in seconds.

# Examples

```jldoctest
using JSOSolverSkeleton, ADNLPModels
nlp = ADNLPModel(x -> sum(x.^2), ones(3))
stats = simple_unc_solver(nlp)

# output

"Execution stats: first-order stationary"
```

```jldoctest
using JSOSolverSkeleton, ADNLPModels
nlp = ADNLPModel(x -> sum(x.^2), ones(3))
solver = SimpleUncSolver(nlp)
stats = solve!(solver, nlp)

# output

"Execution stats: first-order stationary"
```
"""
mutable struct SimpleUncSolver{T, V} <: AbstractOptimizationSolver
  x::V
  xt::V
  gx::V
end

function SimpleUncSolver(nlp::AbstractNLPModel{T, V}) where {T, V}
  nvar = nlp.meta.nvar
  x = V(undef, nvar)
  xt = V(undef, nvar)
  gx = V(undef, nvar)

  return SimpleUncSolver{T, V}(x, xt, gx)
end

@doc (@doc SimpleUncSolver) function simple_unc_solver(
  nlp::AbstractNLPModel{T, V};
  x::V = nlp.meta.x0,
  kwargs...,
) where {T, V}
  solver = SimpleUncSolver(nlp)
  return solve!(solver, nlp; x = x, kwargs...)
end

function SolverCore.solve!(
  solver::SimpleUncSolver{T, V},
  nlp::AbstractNLPModel{T, V},
  stats::GenericExecutionStats{T, V};
  atol::T = √eps(T),
  rtol::T = √eps(T),
  max_eval::Int = -1,
  max_iter::Int = typemax(Int),
  max_time::Float64 = 30.0,
  x::V = nlp.meta.x0,
  callback = (args...) -> nothing,
  verbose::Int = 0,
) where {T, V}
  if !(nlp.meta.minimize)
    error("This solver only works for minimization")
  end
  if !unconstrained(nlp)
    error("Problem is not unconstrained")
  end

  reset!(stats)
  start_time = time()
  set_time!(stats, 0.0)

  # Set up workspace variables
  solver.x .= x # Copy value
  x = solver.x  # Change pointer
  xt = solver.xt
  ∇fx = solver.gx

  fx, ∇fx = objgrad!(nlp, x, ∇fx)

  ϵ = atol + rtol * norm(∇fx)

  set_iter!(stats, 0)
  set_objective!(stats, fx)
  set_dual_residual!(stats, norm(∇fx))

  optimal = norm(∇fx) < ϵ # First order stationary

  set_status!(
    stats,
    get_status(
      nlp,
      elapsed_time = stats.elapsed_time,
      optimal = optimal,
      max_eval = max_eval,
      iter = stats.iter,
      max_iter = max_iter,
      max_time = max_time,
    ),
  )

  callback(nlp, solver, stats)
  done = stats.status != :unknown

  verbose > 0 && @info log_header(
    [:iter, :fx, :ngx, :nf, :Δt],
    [Int, T, T, Int, Float64],
    hdr_override = Dict(:fx => "f(x)", :ngx => "‖∇f(x)‖", :nf => "#f"),
  )
  verbose > 0 && @info log_row(Any[iter, fx, norm(∇fx), neval_obj(nlp), Δt])

  while !done
    α = 1.0
    xt .= x .- α .* ∇fx
    ft = obj(nlp, xt)
    while !(ft ≤ fx - dot(∇fx, ∇fx) * 1e-4α)
      α *= 0.5
      xt .= x .- α .* ∇fx
      ft = obj(nlp, xt)
      if α < 1e-8
        break
      end
    end
    x .= xt
    fx = ft
    grad!(nlp, x, ∇fx)

    set_iter!(stats, stats.iter + 1)
    set_objective!(stats, fx)
    set_time!(stats, time() - start_time)
    set_dual_residual!(stats, norm(∇fx))
    optimal = norm(∇fx) < ϵ

    set_status!(
      stats,
      get_status(
        nlp,
        elapsed_time = stats.elapsed_time,
        optimal = optimal,
        max_eval = max_eval,
        iter = stats.iter,
        max_iter = max_iter,
        max_time = max_time,
      ),
    )

    callback(nlp, solver, stats)

    done = stats.status != :unknown

    verbose > 0 && @info log_row(Any[iter, fx, norm(∇fx), neval_obj(nlp), Δt])
  end

  set_solution!(stats, x)

  return stats
end
