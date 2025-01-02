test_f = [sin, cos, tan, sec, csc, cot]
h(t) = map(f -> f(t), test_f)

macro test_mycode(ex)
    invokelatest(eval, :(@code_warntype h(2)))
    println(lpad("this is a helper macro", 50, '*'))
    println()
    invokelatest(eval, :(@code_typed h(2)))
end


@test_mycode h(2)

h(2)

@btime h(1);
@btime h(1:10000);

function test_h(t)
    [func.(t) for func in test_f]

end

@btime test_h(1:10000);
@btime test_h(1);

@btime map(x -> x > 0 ? 1 : x < 0 ? -1 : 0, -100:100);



using Distributions
function random_dist()
    if rand() < 0.5
        return Normal(randn(), exp(randn()))
    else
        return Gamma(exp(randn()), exp(randn()))
    end
end
vdist = [random_dist() for ii in 1:1000]
tdist = Tuple(vdist)

@btime map(mean, tdist);
@btime map(mean, vdist);
@btime broadcast(mean, tdist);
@btime broadcast(mean, vdist);
@btime mean.(tdist);
@btime mean.(vdist);


@code_lowered broadcast(mean, vdist)
@code_lowered mean.(vdist)