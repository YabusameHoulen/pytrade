using CairoMakie
using LinearAlgebra
using StaticArrays

const a = @SMatrix [
    √3/2 -√3/2 0;
    1/2 1/2 -1
]

const b = [a[:, 2] .- a[:, 3] a[:, 3] .- a[:, 1] a[:, 1] .- a[:, 2]]

### Pauli Matrices
σ₀ = @SMatrix [1 0.0im; 0 1]
σ_x = @SMatrix [0.0im 1; 1 0]
σ_y = @SMatrix [0 -1.0im; 1im 0]
σ_z = @SMatrix [1 0.0im; 0 -1]



struct Para{T<:Real}
    t1::T
    t2::T
    ϕ::T
    M::T
end

function cal_hk(p::Para, kx::Float64, ky::Float64)
    ϵk = dx = dy = dz = 0.0
    for ii in 1:3
        ϵk += cos(kx * b[1, ii] + ky * b[2, ii])
        dx += cos(kx * a[1, ii] + ky * a[2, ii])
        dy += sin(kx * a[1, ii] + ky * a[2, ii])
        dz += sin(kx * b[1, ii] + ky * b[2, ii])
    end
    ϵk *= 2 * p.t2 * cos(p.ϕ)
    dx *= p.t1
    dy *= p.t1
    dz = p.M - 2 * p.t2 * sin(p.ϕ) * dz

    H = @. ϵk * σ₀ + dx * σ_x + dy * σ_y + dz * σ_z
    return H
end

function eig_hk(p, kx, ky)
    ek = Array{Float64}(undef, 2, length(kx), length(ky))
    uk = Array{ComplexF64}(undef, 2, 2, length(kx), length(ky))
    Threads.@threads for iy in eachindex(ky)
        for ix in eachindex(kx)
            hk = cal_hk(p, kx[ix], ky[iy])
            ek[:, ix, iy], uk[:, :, ix, iy] = eigen(Hermitian(hk))
        end
    end
    return ek, uk
end

function cal_bcav(uk, ds)
    _, nb, nx, ny = size(uk)
    bcav = Array{Float64}(undef, nb, nx - 1, ny - 1)

    for ib in 1:nb
        @views for iy in 1:ny-1, ix in 1:nx-1
            tmp = dot(uk[:, ib, ix, iy], uk[:, ib, ix+1, iy])
            tmp *= dot(uk[:, ib, ix+1, iy], uk[:, ib, ix+1, iy+1])
            tmp *= dot(uk[:, ib, ix+1, iy+1], uk[:, ib, ix, iy+1])
            tmp *= dot(uk[:, ib, ix, iy+1], uk[:, ib, ix, iy])
            bcav[ib, ix, iy] = -angle(tmp) / ds
        end
    end
    return bcav
end

#
p = Para(1.0, 0.1, pi / 2, 0.2)
k = range(-pi, pi, 128)
@time ek, uk = eig_hk(p, k, k)
bcav = cal_bcav(uk, (k[2] - k[1])^2)

fig, _, hm = heatmap(k, k, bcav[1, :, :], axis=(; aspect=1))
Colorbar(fig[1, 2], hm)
fig