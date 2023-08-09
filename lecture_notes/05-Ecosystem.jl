# # Julia package Ecosystem - an incomplete and biased overview
#
# ## Tooling
#
#  - [OhMyREPL.jl](https://github.com/KristofferC/OhMyREPL.jl): Enhanced Julia REPL
#  - [TimerOutputs.jl](https://github.com/KristofferC/TimerOutputs.jl): Time/allocation intstrumentation
#    ```julia
#    using TimerOutputs
#
#    function f(n)
#       reset_timer!()
#       @timeit "generate random matrix" A = rand(n, n)
#       for i in 1:10
#           @timeit "generate random vector" b = rand(n)
#           @timeit "solving linear system" A \ b
#       end
#       print_timer()
#    end
#    ```
#  - [BenchmarkTools.jl](https://github.com/JuliaCI/BenchmarkTools.jl): Micro benchmarking
#    ```julia
#    using BenchmarkTools
#
#    function sort_v1(n)
#        x = rand(n)
#        y = sort(x)
#        return y
#    end
#    function sort_v2(n)
#        x = rand(n)
#        sort!(x)
#        return y
#    end
#
#    @benchmark sort_v1(10)
#    @benchmark sort_v2(10)
#
#    @benchmark sort_v1(1000000)
#    @benchmark sort_v2(1000000)
#    ```
#  - [Revise.jl](https://github.com/timholy/Revise.jl): Auto-reloading code on file change
#  - [JET.jl](https://github.com/aviatesk/JET.jl): Static code analyzer
#  - [Debugger.jl](https://github.com/JuliaDebug/Debugger.jl): Terminal debugger
#    ```julia
#    using Debugger
#
#    @enter sum([1, 2, 3])
#    ```
#  - [JuliaFormatter.jl](https://github.com/domluna/JuliaFormatter.jl): Code formatter
#  - [Cthulhu.jl](https://github.com/JuliaDebug/Cthulhu.jl): Hunt performance issues
#    ```julia
#    using Cthulhu
#
#    @descend game(10)
#    ```
#
# ## Arrays and collections
#
#  - [SparseArrays.jl](https://docs.julialang.org/en/v1/stdlib/SparseArrays/): sparse matrices
#  - [StaticArrays.jl](https://github.com/JuliaArrays/StaticArrays.jl): fixed-size (small) arrays
#    ```julia
#    using StaticArrays, BenchmarkTools
#
#    function regular_array()
#        A = rand(3, 3)
#        b = rand(3)
#        return A * b
#    end
#
#    function static_array()
#        A = @SMatrix rand(3, 3)
#        b = @SVector rand(3)
#        return A * b
#    end
#
#    @btime regular_array()
#    @btime static_array()
#    ```
#  - [OffsetArrays.jl](https://github.com/JuliaArrays/OffsetArrays.jl): why not 2-based indexing?
#    ```julia
#    using OffsetArrays
#
#    x = OffsetVector([1, 2, 3], 1)
#
#    x[2]
#    x[3]
#    x[4]
#
#    x[1]
#    ```
#  - [DataStructures.jl](https://github.com/JuliaCollections/DataStructures.jl): Ordered dicts, circular buffers, queue, dequeu
#  - [DataFrames.jl](https://dataframes.juliadata.org/stable/): tables
#
# ## Machine learning
#  - [Flux.jl](https://github.com/FluxML/Flux.jl)
#  - [MLJ.jl](https://alan-turing-institute.github.io/MLJ.jl/dev/)
#
# ## Numerical computing
#  - [DifferentialEquations.jl](https://github.com/SciML/DifferentialEquations.jl): Solving differential equations (in time)
#  - [IterativeSolvers.jl](https://github.com/JuliaLinearAlgebra/IterativeSolvers.jl): Iterative solvers for linear systems
#  - [LinearSolve.jl](https://github.com/SciML/LinearSolve.jl): All the linar solvers collected into a common interface
#  - [Measurements.jl](https://juliaphysics.github.io/Measurements.jl/stable/): compute with uncertainties
#    ```julia
#    using Measurements
#
#    x = 0.5 ± 0.2 # mean value and standard deviation
#
#    sin(x)
#    x^2
#    ```
#  - [GPU programming](https://juliagpu.org/) (CUDA (Nvidia), oneAPI (Intel),
#    AMD, Apple GPU): Run Julia on your GPU!
#  - [ForwardDiff.jl](https://juliadiff.org/ForwardDiff.jl/stable/): Automatic differentiation
#
# ## Web development
#  - [HTTP.jl](https://github.com/JuliaWeb/HTTP.jl): HTTP client/server library
#    ```julia
#    using HTTP
#
#    HTTP.listen() do http
#       HTTP.setstatus(http, 200)
#       HTTP.setheader(http, "content-type" => "text/plain")
#       HTTP.startwrite(http)
#       HTTP.write(http, "Hello, Tampere")
#    end
#
#    ```
#  - [Genie.jl](https://genieframework.com/): Web framework
#
# ## Misc
#  - [PythonCall.jl](https://github.com/cjdoris/PythonCall.jl): Call python
#
# # Documentation
#  - [Documenter.jl](https://documenter.juliadocs.org/stable/): documentation generator
#  - [Franklin.jl](https://franklinjl.org/): static site generator
