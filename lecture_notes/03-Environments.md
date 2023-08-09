# Julia's Package Manager (Pkg)
## Introduction
**Intended learning outcomes:** 
After completion of this block, the course participant will 
* Know how to install and use julia packages
* Be able to make their julia code reproducible 

### Relevant parts of Julia's documentation
* [Brief intro](https://docs.julialang.org/en/v1/stdlib/Pkg/)
* [Getting started with package management](https://pkgdocs.julialang.org/v1/getting-started/)
* [Details on using packages (and modules)](https://docs.julialang.org/en/v1/manual/modules/)
* [Details on environments](https://pkgdocs.julialang.org/v1/environments/)
* [Details on Project.toml and Manifest.toml](https://pkgdocs.julialang.org/v1/toml-files/)

## Quick intro to using packages
When you open the julia REPL the first time, it looks like 
```julia
julia>
```

If you type, `]`, you will enter the `Pkg`-mode (Package manager mode)
```julia
(@v1.9) pkg>
```
where `(@v1.9)` indicates that the current active environment is `v1.9` (see [Environments](#environments)). To not pollute this environment by following this guide, let's create a temporary environment by running `activate --temp` (this will change `@v1.9` to some random string).

If we then would like to add some packages, say `Ferrite.jl`, we write `add Ferrite` in `Pkg`-mode:
```julia
(jl_7wJdpH) pkg> add Ferrite
```
This will download and install `Ferrite.jl` and all its dependencies on your computer. Running the `st` command (still in `Pkg`-mode), we can see all packages available in the current environment
```julia 
(jl_7wJdpH) pkg> st
Status `C:\Users\<username>\AppData\Local\Temp\jl_7wJdpH\Project.toml`
  [c061ca5d] Ferrite v0.3.14
```
Once these steps have been completed for the current environment, they do not need to be repeated.
Upon starting up julia again, it is just necessary to activate the specific environment, see [Environments](#environments) for further details. 

For every new session of julia with code that requires functionality provided by `Ferrite.jl`, we need to specify that we actually want to use `Ferrite.jl`. To do this, we first exit the `Pkg`-mode by pressing backspace. Then we are in the standard REPL mode (indicated by `julia>`). In this mode, running `using Ferrite` will make the functionality provided by `Ferrite.jl` available to us. 
```julia
julia> using Ferrite 
```
How to use `Ferrite.jl` specifically will be covered in the Wednesday workshop. 

## Using packages
In julia, all functions and objects defined in packages are available to the end user. However, some may be just internal functions that are not intended to be used. However, packages may `export` functions and objects, these are meant for users to call. Functions and objects that are not exported may still be meant for users to call, if they are documented in the documentation. The distinction between *public* and *private* API may vary from package to package (see [here](https://github.com/JuliaLang/julia/pull/50105) for potential future standardization)

There are two keywords for using a package, `using PackageName` and `import PackageName`. The most common is the `using` keyword, which will bring all exported objects into scope along with the package name itself. All objects can be accessed via there *qualified* name, i.e. `PackageName.object`. Exported objects can be accessed directly, with their *unqualified* name, i.e. `object`. 

<details>
<summary> The import keyword </summary> 

When using `import PackageName`, only `PackageName` is brought into scope, and all objects must be accessed via their qualified names. There are also variations of this, for example `import PackageName: object` will only bring the `object` name into scope (not even `PackageName`) and `import PackageName as PN` will do the same as `import PackageName` except that the symbol `PN` will refer to `PackageName` and the symbol `PackageName` will not be defined. 
</details>

## Environments
The environment specifices the exact packages (including) versions that can be used when running a specific code. 
* Described by `Project.toml` and `Manifest.toml` files
  * `Project.toml`: Describes direct dependencies with restrictions on versions
  * `Manifest.toml`: Describe all dependencies with exact versions
* 2 types of environments
  * Global: Always accessible in scripts/REPL, by default only `.julia/environments/v<major>.<minor>`
  * Local: The currently activated environment.
* General advice
  * Be restrictive about putting things in your global environment. 
  * This is good for workflow/profiling tools etc. 
  * If your scripts rely on packages here, they don't work for others without those packages in their global environment, even if share code along with the `Project.toml` and `Manifest.toml` for the local environment. 
  
By using local environments correctly, your simulations will be fully reproducible by someone else on their system. The simple rule is to make sure that all packages that you use via `using` or `import` are added to the local environment (even if they exist in your global environment).

### Setting up a local environment
In `Pkg`-mode, an environment is activated by running the command
```julia
(@v1.9) pkg> activate <path/to/folder>
```
If your current working directory already is in the folder that you would like to activate, you can simply run `activate .` (also in `Pkg`-mode). This will activate an existing environment or create a new environment if there is no `Project.toml` file in `folder`. 

## Environments when using VSCode
When you open a folder in `VSCode` and run code, the environment of that folder will be active. 
However, if you just start a `REPL` session, the global environment will be activated. To activate the so-called "parent"-environment of the currently open file (the first environment that is found by ascending the folder structure), press `Ctrl+Shift+P` and choose `>Julia: Activate Parent Environment` (if you start typing `>activate p` this option will pop up, note that `>` indicate that you want to run a command in `VSCode`). 

## Tasks
In this task, you should install a package and write a script that runs some calculation using that package. 

1. Create a new folder with a new environment
2. Create a script file `newtonsolver.jl` in that folder.
3. Install [`ForwardDiff.jl`](https://juliadiff.org/ForwardDiff.jl/stable/) to your new environment
4. Inspect the files `Project.toml` and `Manifest.toml` 
5. At the top of `Project.toml`, add 
    ```julia
    [compat]
    ForwardDiff="<0.10.34"
    ```
    This will limit the version of ForwardDiff to maximum v0.10.33
6. Enter `Pkg`-mode and run `up`. This will update the packages in the environment, in this case `ForwardDiff` will be downgraded to `v0.10.33` or lower. Packages may use these restrictions if they don't work after a dependency has been updated. Remove the added compat section, and re-run `up` to get back the latest version. 
7. `ForwardDiff.jl` provides the function `ForwardDiff.derivative` (not exported, but public). Use this to write a newton-raphson solver for scalar problems. The function signature should be
   ```julia
   function newtonsolver(f::Function, x0::Real; maxiter=10, tol=1e-6)
       # Create a loop that solves f(x)=0 using Newton's method, specifically taking the update
       # xᵢ₊₁ = xᵢ - f(xᵢ)/f'(xᵢ)
       # and stopping when abs(f(xᵢ)) < tol. 
       # Return nothing if convergence is not obtained after `maxiter` iterations 
       # code...
   end 
   ``` 
8. Test that the function work by calculating the solution to `cos(x)=0` with an initial guess `0<x0<π`, and check that you get x=π/2 as the output within the expected tolerance. 
9. Copy your script file and the `Project.toml` file to another folder on your computer (to simulate sending your code to a colleague). Start a new julia session and activate the environment and try to run the code. Follow the instructions to solve potential problems. Delete the folder.
10. Now try to copy both the `.toml` files along with the script to another folder. Do the same as above. In this case, the package versions do not change! (If you were at a different computer, they would get downloaded.)
