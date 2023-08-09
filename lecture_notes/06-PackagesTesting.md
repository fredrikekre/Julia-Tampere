# Julia packages
## Introduction
**Intended learning outcomes:** 
After completion of this block, the course participant will 
* Understand the structure of a julia packages
* Be able to create their own julia packages

## A typical package
Most julia packages have at least the following files and folders on their github page. For this example, we assume the package is called `MyPackage.jl`

```
├─ .github/workflows    # For Continuous Integration (excluded)
├─ docs                 # For creating documentation website with 
|  ├─ src               # Documenter.jl (excluded)
|  |  └─ index.md
|  ├─ make.jl 
|  ├─ Project.toml
|  ├─ Manifest.toml
├─ src                  # Actual julia code 
|  └─ MyPackage.jl
├─ test                 # Unit tests
|  └─ runtests.jl
├─ .gitignore           # For using git (excluded)
├─ LICENSE              # Use a LICENSE (excluded)
├─ Project.toml         # Specify dependencies and versions 
├─ README.md            # Brief package description (excluded)
```

## Scope of session
In this session we will focus on those parts that are **required** for creating a working package. Then we will add *docstrings* and *unit testing*. To create online documentation with julia's [`Documenter.jl`](https://documenter.juliadocs.org/stable/) is very easy, but that is not covered today. 

## Why and when to create packages instead of scripts
*This is my personal opinion, everyone have different preferences for code organization etc.*

Use packages when you have a set of functionality with limited scope that you would like to reuse. The advantages of using a package for this are
* **Scoped name-space**: Only the functions and objected intended to be used are available, so the name-space is not polluted. 
* Set up simple **unit tests** assures correctness of that piece of code, reduces the risk of bugs.
* When **re-using code** across projects, no need to copy scripts around, they are self-contained as a package that can be used in each project (especially if hosted in a repository like github)
* Add **docstrings** to your functions
* Forces you to **think software design** - what functionality can you provide and how to modularize your code = easier to reuse older code (especially if documentation and tests are there)

# Setting up your own package
To setup a working package, we will need the file `src/MyPackage.jl` together with the top-level `Project.toml` file. Note that a `Manifest.toml` is not required: We don't want to lock the versions of all dependencies, then it would not work to combine packages with the same dependencies. However, the `Project.toml` file will need some additional information (compared to just a regular environment), most importantly a unique identifier, `UUID`, for the package. To generate the bare-bone package, we can use `Pkg` by running the following from a julia session with the current working directory in the folder where we would like to place our new package
```julia
using Pkg
Pkg.generate("MyPackage")
```

This will generate the `src/MyPackage.jl` file as well as the `Project.toml` file.
The `Project.toml` file will contain information about the package, and look something like the following 
```TOML
name = "MyPackage"
uuid = "89d5c961-57e2-455f-bb0e-7cdbb0691447"
authors = ["Knut Andreas Meyer <my email address"]
version = "0.1.0"
```

To start developing the package, we open `src/MyPackage.jl` in `VSCode`, and start adding functions, objects, and other things we like to add to our package.
In order to add dependencies, we simply activate the package environment. 
When running `Pkg.instantiate()`, a `Manifest.toml` will be created. This is typically not part of the package, and should be ignored by the version control. 
The `Project.toml` file can be edited manually to include version restrictions 
on various packages, exactly as we did with `ForwardDiff.jl` earlier.

## Adding functionality
We'll take the `newtonsolver` function that we created earlier today as an example. 
Then, we need to (1) add `ForwardDiff.jl` to our dependencies and (2) copy that function into `src/MyPackage.jl`. If we activate the environment for `MyPackage`,
we can directly do `using MyPackage` (we don't have to add a package to its own environment). It is now possible to call 
```julia
julia> x = MyPackage.newtonsolver(cos, 0.5)
```

But for our package, it might make sense to `export` the function, because we 
want our users to have it more convenient. After adding `export newtonsolver` in
`src/MyPackage.jl`, it is possible to simply type
```julia
julia> x = newtonsolver(cos, 0.5)
```

## Adding docstrings
In the Julia REPL, if you type `?`, you enter the help mode. 
Then we can get the docstrings for functions and objects, for example,
```julia
help?> sin
```
to get the docstring for the `sin` function.
But if we try to get the docstring for `newtonsolver`, it just shows the list of methods, currently only one without any explanation. But we can add a docstring by 
enclosing it in tripple quotation marks directly above the function:
```julia
"""
    newtonsolver(f, x0::Number; maxiter=10, tol=1e-6)

Solve the nonlinear equation `f(x)=0` by using the Newton-Raphson algorithm.
`x0` is the initial guess for `x`. Return `x` when `abs(f(x)) < tol`. 
If `abs(f(x))>tol` after `maxiter` iterations, return `nothing`
"""
function newtonsolver(f, x0::Number; maxiter=10, tol=1e-6)
    # ...
```
After doing this, the docstring will be available in the help-mode. 

## Adding unit tests
To add unit testing, we create the file (and folder) `test/runtests.jl`.
Then, we need to have the package `Test` available, which is done via the `extras`
option in `Project.toml`. The easiest way is just to write `add Test` in `Pkg`-mode.
Then, add a new header `[extras]` at the bottom and move the newly added `Test = "8df..."` entry to that header. Finally, add a last row with `targets = ["Test"]`. Your Project.toml file should then look something like 
```TOML
name = "MyPackage"
uuid = "89d5c961-57e2-455f-bb0e-7cdbb0691447"
authors = ["Knut Andreas Meyer <knutam@gmail.com>"]
version = "0.1.0"

[deps]
ForwardDiff = "f6369f11-7733-5829-9624-2563aa707210"

[extras]
Test = "8dfed614-e22c-5e08-85e1-65c5234f0b40"
```

Then, in `test/runtest.jl` we need to to use the required packages, so we write 
```julia
using MyPackage
using Test

@testset "test newtonsolver" begin
    tol = 1e-10
    x = newtonsolver(cos, 0.5; tol=tol)
    @test x ≈ π/2
end
```
To run the test(s), go to `Pkg`-mode and simply type `test`.
In this specific case, just running the `test/runtests.jl` works, since `Test` is available in the global environment (bundled with Julia), but in general, this will 
not work if there are test-specific dependencies that are required for testing, but that we don't want to be dependencies of our package.

We have now created a package that contains a function, with a docstring and testing🎉

## How to use your package from another environment
If it is local on your computer, use 
```julia
(env) pkg> dev "<path/to/your/package>"
```
If you host your package on github, you can more easily use your packages accross computers and share with coworkers (if they have access to the repository). Then you can simply add by doing
```julia
(env) pkg> add https://github.com/<gh_username>/MyPackage.jl
```
The packages that we have added so far, are registered in Julia's general registry. Such packages, that are available from a registry, can be added simply by their name. 


## Useful links for creating packages
* [`PkgTemplates.jl`](https://juliaci.github.io/PkgTemplates.jl/stable/): Complete and customizable generation of a new package, including what we got from `Pkg.generate`, but can also provide the `test` folder with corrected `Project.toml`, the `docs` folder setup nicely with documentation environment, Continuous Integration (CI) with e.g. github action setup (i.e. run tests and build documentation when pushing changes to github), code test coverage analysis, and much more!
* [`Documenter.jl`](https://documenter.juliadocs.org/stable/): How to build a documentation webpage. *TIP: Learn from existing packages.*
* [`Literate.jl`](https://fredrikekre.github.io/Literate.jl/v2/) for creating examples in your documentation, see how it is used in e.g. [`Ferrite.jl`](https://ferrite-fem.github.io/Ferrite.jl/stable/examples/heat_equation/)
