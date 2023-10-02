@testset "Basic tests for Unconstrained" begin
  @testset "Basic usage" begin
    nlp = ADNLPModel(x -> (x[1] - 1)^2 + (x[2] - 2)^2 / 4, zeros(2))
    output = with_logger(NullLogger()) do
      simple_unc_solver(nlp)
    end
    @test isapprox(output.solution, [1.0; 2.0], rtol = 1e-4)
    @test output.objective < 1e-4
    @test output.dual_feas < 1e-4
    @test output.status == :first_order
  end

  @testset "Expected failure to converge" begin
    # This checks that your solver is failing accordingly
    nlp = ADNLPModel(x -> exp(1e-4 * sum(x)), zeros(2))
    output = with_logger(NullLogger()) do
      simple_unc_solver(nlp, max_eval = 1)
    end
    @test output.status == :max_eval
    output = with_logger(NullLogger()) do
      simple_unc_solver(nlp, max_iter = 1)
    end
    @test output.status == :max_iter
    output = with_logger(NullLogger()) do
      simple_unc_solver(nlp, max_time = 1e-8)
    end
    @test output.status == :max_time
  end
end

@testset "SolverTest" begin
  SolverTest.unconstrained_nlp(simple_unc_solver)
  SolverTest.multiprecision_nlp(simple_unc_solver, :unc)
end
