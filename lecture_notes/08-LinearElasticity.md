# Linear heat flow to elasticity
In this section, we will look at the heatflow example and modify that example to solve linear elasticity instead. 
## Weak form
**Heat flow**; temperature $T$, conductivity tensor, $\bm{k}$, heat source, $b$, boundary flux, $q_\mathrm{n}$:
$$
\int_\Omega \bm{\nabla}\delta T \cdot \bm{k} \cdot \bm{\nabla}T \ \mathrm{d}\Omega = \int_\Omega \delta T\ b \ \mathrm{d}\Omega + 
\int_\Gamma \delta T\ q_\mathrm{n} \ \mathrm{d}\Gamma
$$

**Linear elasticity**; Displacements $\bm{u}$, stiffness tensor, $\bm{\mathsf{C}}$, body load, $\bm{b}$, and boundary traction, $\bm{t}$:
$$
\int_\Omega \left[\bm{\delta u} \otimes \bm{\nabla}\right]^\mathrm{sym} : \bm{\mathsf{C}} : \left[\bm{u} \otimes \bm{\nabla}\right]^\mathrm{sym}\ \mathrm{d}\Omega = \int_\Omega \bm{\delta u} \cdot \bm{b} \ \mathrm{d}\Omega + 
\int_\Gamma \bm{\delta u} \cdot \bm{t} \ \mathrm{d}\Gamma
$$

## FE form
**Heat flow**: $T(\bm{x}) \approx N_j(\bm{x}) a_j$ and $\delta T(\bm{x}) \approx \delta N_j(\bm{x}) \delta a_j$ 
$$
\underbrace{\left[\int_\Omega \bm{\nabla}\delta N_i \cdot \bm{k} \cdot \bm{\nabla} N_j \ \mathrm{d}\Omega\right]}_{K_{ij}} a_j = \underbrace{\int_\Omega \delta N_i\ b \ \mathrm{d}\Omega + 
\int_\Gamma \delta N_i\ q_\mathrm{n} \ \mathrm{d}\Gamma}_{f_i}
$$

**Elasticity**: $\bm{u}(\bm{x}) \approx \bm{N}_j(\bm{x}) a_j$ and $\bm{\delta u}(\bm{x}) \approx \bm{\delta N}_j(\bm{x}) \delta a_j$ 
$$
\underbrace{\left[\int_\Omega \left[\bm{\delta N}_i \otimes \bm{\nabla}\right]^\mathrm{sym} : \bm{\mathsf{C}} : \left[\bm{N}_j \otimes \bm{\nabla}\right]^\mathrm{sym} \ \mathrm{d}\Omega\right]}_{K_{ij}} a_j = \underbrace{\int_\Omega \bm{\delta N}_j \cdot \bm{b} \ \mathrm{d}\Omega + 
\int_\Gamma \bm{\delta N}_j \cdot \bm{t}\ \mathrm{d}\Gamma}_{f_i}
$$

## Differences
* $T$ is a scalar field, $\bm{u}$ is a vector
  * Shape functions, go from scalars, $N$, to vectors, $\bm{N}$.
* $\bm{k}$ is a 2nd order tensor, $\bm{\mathsf{C}}$ is a 4th order tensor
* Heat source, $b$, becomes a vector load, $\bm{b}$ (same for $q_\mathrm{n}$ to $\bm{t}$)
* We need the double contraction instead of single contraction to calculate the stiffness

## What needs to be changed?
1. Tell `Ferrite` that we have a vector field (more dofs per node)
2. Tell `Ferrite` the `Dirichlet` boundary conditions for all vector components
3. Our shape functions should be vectors - `CellScalarValues → CellVectorValues`
4. Define $\bm{\mathsf{C}}$ and $\bm{b}$
5. Change type of product, i.e. use single and double contractions

## What tools do we need?
`Tensors.jl` provide `Ferrite.jl` with the required tensor operations (but is very useful for standalone applications, such as material modeling as well!)

```julia
using Tensors
# Tensor{order,dim}, i.e. 2nd order, 3d: Tensor{2,3}

dim = 3 # Spatial dimension we are working in
I2 = one(SymmetricTensor{2,dim}) # 2nd order identity tensor
I4 = one(SymmetricTensor{4,dim}) # 4th order identity tensor
v = rand(Vec{dim}) # Random vector 
a = rand(SymmetricTensor{2,dim})
b = rand(Tensor{2,dim})
v⊗v
a⊡a # a:a
a⋅v
I4⊡a # I4:a=a
a⋅b
a⋅inv(b)
```

## Making the changes
With these tools, we can actually make the changes, see [from_heatflow.jl](./08-LinearElasticity/from_heatflow.jl) in `08-LinearElasticity/`