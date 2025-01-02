repeater(f) = function (args...)
    f(args...)
    f(args...)
end

multiply(a, b) = println(a, b)

repeater(multiply)(1, 2)

(sqrt ∘ +)((x -> x^2).((3, 6))...)


macro repeating(expr)
    @assert expr.head in [:function, :(=)] "Expected a function definition"
    @assert expr.args[1].head == :call "Expected a function definition"

    func_name = expr.args[1].args[1]
    func_args = expr.args[1].args[2:end]
    func_body = expr.args[2].args

    # 插入的代码，可以自定义为任何你想要插入的表达式
    pre_code = quote
        println("Entering function $($func_name)")
    end

    after_code = quote
        println("Exiting function with result: ",result)
    end

    # 创建新的函数体，将插入的代码放在函数体开头
    new_body = quote
        $pre_code
        result = begin
            $(func_body[1:end-1]...)
        end  # 执行原函数体
        $after_code
        $(func_body[end])
    end
    return :($func_name($(func_args...)) = $new_body)
end


@repeating multiply(a::Int, b::Float64) = println(a, b)

@repeating function testt(a::Vector, b::Int)
    push!(a, b)
    println(a .+ b)
    return a
end

Meta.@dump function testt(a::Vector, b::Int)
    push!(a, b)
    println(a .+ b)
    return a
end

testt([3, 4], 5)

multiply(1, 3.0)


Meta.@dump multiply(a::Int, b) = println(a, b)

Meta.@dump function multiply(a, b)
    println(a, b)
    print(a, a + 1)
end

@repeating function test_badkwarg(a, b=[])
    push!(b, 1)
    @show b
end

methods(test_badkwarg)
test_badkwarg(1, [3])
test_badkwarg(1)

