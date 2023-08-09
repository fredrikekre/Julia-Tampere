module MyPackage
using ForwardDiff

export newtonsolver

"""
    newtonsolver(f, x0::Number; maxiter=10, tol=1e-6)

Solve the nonlinear equation `f(x)=0` by using the Newton-Raphson algorithm.
`x0` is the initial guess for `x`. Return `x` when `abs(f(x)) < tol`. 
If `abs(f(x))>tol` after `maxiter` iterations, return `nothing`
"""
function newtonsolver(f::Function, x0::Number; maxiter=10, tol=1e-6)
    x = x0
    fx = f(x)
    for _ in 1:maxiter
        abs(fx) < tol && return x
        x -= fx/ForwardDiff.derivative(f, x)
        fx = f(x)
    end
    fx < tol && return x
    return nothing
end

end # module MyPackage
