struct Dual{T}
    x::T
    ϵ::T
end

Base.:*(m, a::Dual) = Dual(m * a.x, m * a.ϵ)
Base.:+(a::Dual, b::Dual) = Dual(a.x + b.x, a.ϵ + b.ϵ)
Base.:/(a::Dual, b::Dual) = Dual(a.x / b.x, (b.x * a.ϵ - a.x * b.ϵ) / b.x^2)

function mysqrt(a)
    x = a
    for k in 1:100
        x = 0.5 * (x + a / x)
    end
    return x
end

mysqrt(2)

mysqrt(Dual(2,1))

1/2√2

