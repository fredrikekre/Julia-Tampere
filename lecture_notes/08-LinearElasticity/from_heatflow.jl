# Changes from the heatflow examples are indicated 
# by lines starting with "#old: ", which have been 
# replaced by the code below that line. 

using Ferrite, SparseArrays

grid = generate_grid(Quadrilateral, (20, 20));

dim = 2
ip = Lagrange{dim, RefCube, 1}()
qr = QuadratureRule{dim, RefCube}(2)
#old: cellvalues = CellScalarValues(qr, ip);
cellvalues = CellVectorValues(qr, ip);

dh = DofHandler(grid)
#old: add!(dh, :u, 1)
add!(dh, :u, 2)
close!(dh);

K = create_sparsity_pattern(dh)

ch = ConstraintHandler(dh);

∂Ω = union(
    getfaceset(grid, "left"),
    getfaceset(grid, "right"),
    getfaceset(grid, "top"),
    getfaceset(grid, "bottom"),
);

#old: dbc = Dirichlet(:u, ∂Ω, (x, t) -> 0)
dbc = Dirichlet(:u, ∂Ω, (x, t) -> Vec((0,0)))
add!(ch, dbc);

close!(ch)

function assemble_element!(Ke::Matrix, fe::Vector, cellvalues::CellVectorValues)
    n_basefuncs = getnbasefunctions(cellvalues)
    # Reset to 0
    fill!(Ke, 0)
    fill!(fe, 0)
    #old: 
    I4 = one(SymmetricTensor{4,2})
    I2 = one(SymmetricTensor{2,2})
    G = 80e3    # Shear modulus
    K = 160e3   # Bulk modulus
    C = 2G*(I4 - I2⊗I2/3) + K*I2⊗I2 # Stiffness tensor 
    b = Vec((1.0, 2.0))               # Body load
    # Loop over quadrature points
    for q_point in 1:getnquadpoints(cellvalues)
        # Get the quadrature weight
        dΩ = getdetJdV(cellvalues, q_point)
        # Loop over test shape functions
        for i in 1:n_basefuncs
            δu  = shape_value(cellvalues, q_point, i)
            #old: ∇δu = shape_gradient(cellvalues, q_point, i)
            ∇δu = shape_symmetric_gradient(cellvalues, q_point, i)
            # Add contribution to fe
            #old: fe[i] += δu * dΩ
            fe[i] += (δu ⋅ b) * dΩ
            # Loop over trial shape functions
            for j in 1:n_basefuncs
                #old: ∇u = shape_gradient(cellvalues, q_point, j)
                ∇u = shape_symmetric_gradient(cellvalues, q_point, j)
                # Add contribution to Ke
                #old: Ke[i, j] += (∇δu ⋅ ∇u) * dΩ
                Ke[i, j] += (∇δu ⊡ C ⊡ ∇u) * dΩ
            end
        end
    end
    return Ke, fe
end

#old: function assemble_global(cellvalues::CellScalarValues, K::SparseMatrixCSC, dh::DofHandler)
function assemble_global(cellvalues::CellValues, K::SparseMatrixCSC, dh::DofHandler)
    # Allocate the element stiffness matrix and element force vector
    n_basefuncs = getnbasefunctions(cellvalues)
    Ke = zeros(n_basefuncs, n_basefuncs)
    fe = zeros(n_basefuncs)
    # Allocate global force vector f
    f = zeros(ndofs(dh))
    # Create an assembler
    assembler = start_assemble(K, f)
    # Loop over all cels
    for cell in CellIterator(dh)
        # Reinitialize cellvalues for this cell
        reinit!(cellvalues, cell)
        # Compute element contribution
        assemble_element!(Ke, fe, cellvalues)
        # Assemble Ke and fe into K and f
        assemble!(assembler, celldofs(cell), Ke, fe)
    end
    return K, f
end

K, f = assemble_global(cellvalues, K, dh);

apply!(K, f, ch)
u = K \ f;

vtk_grid("linear_elasticity", dh) do vtk
    vtk_point_data(vtk, dh, u)
end