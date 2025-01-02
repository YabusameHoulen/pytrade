abstract type a end
for name in [:b, :c, :d]
    @eval struct $name <: a end
end

subtypes(a)[1]|>typeof
a() = subtypes(a)
a()
test_f(a, z::Type{<:a}) = print("struct as enum test")
test_f(a, z::Type{b}=b) = print("this is for b type")

@which test_f(3, b)
a()
test_f(3, a)
test_f(3, b)
test_f(3)

b == b

methods(test_f)

@enum DD DF DE
struct mmt
    sa::Type{<:a}
    te::DD
end

@code_lowered mmt(b)

@code_warntype mmt(c)

mmt(b, DE).sa in [ c, d]
"time compare between $(mmt(b, DE).te )"

abstract type SomeType end
struct First <: SomeType end
struct Second <: SomeType end
struct Third <: SomeType end
struct Fourth <: SomeType end

Base.Integer(T::Type{<:SomeType}) = Integer(T())
Base.Integer(::First) = 1
Base.Integer(::Second) = 2
Base.Integer(::Third) = 3
Base.Integer(::Fourth) = 4

const SomeTypeSet = subtypes(SomeType)
function Base.convert(::Type{SomeType}, x::Integer)
    for e in SomeTypeSet
        x == Integer(e) && return e()
    end
end
SomeType(x::Integer) = convert(SomeType, x)

Base.isless(x1::SomeType, x2::SomeType) = isless(Integer(x1), Integer(x2))
Base.isless(x1::Type{<:SomeType}, x2::Type{<:SomeType}) = isless(x1(), x2())


First() < Fourth()
First < Fourth
SomeType(3) == Third()


get_trait(::Type{a}) = First()


get_trait(a) isa First

