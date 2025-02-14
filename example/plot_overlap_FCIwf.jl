# using released version
using PairingHamiltonians

# using a local version for development
#include("src/PairingHamiltonians.jl")
#using .PairingHamiltonians

using Glob
using HDF5
using LaTeXStrings
using LinearAlgebra 
using Plots

function plot_overlap(Data)
    x = sort(collect(keys(Data)))
    mesh = zeros(Float64, length(x), length(x))
    for i = 1:length(x)
        g = x[i]; ψL = Data[g]
        for j = 1:length(x)
            gp = x[j]; ψR = Data[gp]
            overlap = abs(dot(ψL, ψR))
            mesh[i,j] = overlap
        end
    end
    p = heatmap(x, x, mesh, c=:magma,
        aspect_ratio=1, xlims=(-2,2), ylims=(-2,2),
        xlabel=L"g", ylabel=L"g'", title=L"|  \langle \psi(g)|\psi(g') \rangle |")
    savefig(p, "overlap.pdf")
    display(p)

end

function main()
    Norb = 8; Nocc = 4
    fns = glob("eigenstates_fullCI/eigenstate_Norb$(Norb)_Nocc$(Nocc)_g*.h5")

    if length(fns) == 0
        println("No files found")
        return
    end

    Data = Dict{Float64, Vector{Float64}}()
    for fn in fns
        h5open(fn, "r") do file
            gval = read(file, "gval")
            evec = read(file, "evec")
            Data[gval] = evec        
            println("evec $evec")
        end
    end

   plot_overlap(Data)

end
main()
