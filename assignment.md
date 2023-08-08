# Julia course assignment 
In this assignment, you will create a julia package called `Shapes.jl`, with and abstract 
type `AbstractShape`. This package should then define two subtypes, `Rectangle` and `Circle`, 
and methods for calculating the area and perimeter of those shapes. 

## Specific tasks
1. Set up a new package, `Shapes`, see instructions below.
2. Define the required types and methods
3. For `Rectangle`, define an additional constructor with keyword arguments. The default rectangle height should be equal to its width.
4. Document the constructors and functions
5. Write tests in `test/runtests.jl` that checks that the functions work as they should. Test also for different float numbers, e.g. `Float32`
6. Write a script-file, `demo.jl`, which solves the following tasks by using the `sum` function. (Hint: use `sum(f::Function, v::Vector)`)
   * Create a `Vector` of `Circle`s with random radius (between 0 and 1) and calculate the total area of these circles
   * Create a `Vector` of both `Circle`s and `Rectangle`s with random dimensions (values between 0 and 1) and calculate the total area of these shapes
   * Using the same vector, also calculate the total perimeter of the shapes.
7. Add the package [`UnicodePlots.jl`](https://github.com/JuliaPlots/UnicodePlots.jl) to your dependencies, and write a function, `plot_shape` that takes in a shape and returns a plot that can be shown in the REPL.
8. Overload the method `Base.show` for `AbstractShape` such that
    * A `Circle` is printed as `Circle(r=<r>)` where `<r>` is the numerical value of the radius, and a `Rectangle` as `Rectangle(w=<w>, h=<h>)`. Below, the plot of the shape is shown. 
    * When part of a collection, such as a vector, no plot is shown. 
    
    See [Custom pretty-printing](https://docs.julialang.org/en/v1/manual/types/#man-custom-pretty-printing) for how to accomplish this by overloading two different versions of `Base.show`. To show the plot inside the `show` method, use `show(io, m, p)` where `p` is the output from `plot_shape` and `m` is the 2nd input (io context) to the the 3-argument `show` method. 
 
## Setting up a new package
For this assignment, we will only need a simplified package setup, that can be done following the lecture notes. 
We can set this up manually using `Pkg.generate("Shapes")`, but it is possible to use the package `PkgTemplates` to get a more complete package setup for those that are interested. 

## Setup package using PkgTemplates 
See [PkgTemplates.jl](https://juliaci.github.io/PkgTemplates.jl/stable/) for the full documentation.
The following should work if `git` is installed and you want to host the package in `github` via `ssh`.
```
using Pkg
Pkg.activate(;temp=true) # Activate a temporary environment
Pkg.add("PkgTemplates")
using PkgTemplates
t = Template(;user="<your_git_username>", authors="<your_name>", plugins=[
           Git(;ssh=true, ignore=["*.vscode"]),
           GitHubActions(;linux=true, extra_versions=["1"], coverage=true),
           Codecov(), Documenter{GitHubActions}(), !TagBot]);
t("<package_name>")
```
The new package is put in "$HOME/.julia/dev". You can also give an absolute path 
to get your package in a different location. 
This will produce a more complete package, including documentation and 
Continuous Integration (CI) that both builds the documentation and runs the tests. 
