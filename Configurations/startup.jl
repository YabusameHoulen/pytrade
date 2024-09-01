ENV["JULIA_PKG_SERVER"] = "https://mirrors.nju.edu.cn/julia/"
ENV["JULIA_EDITOR"] = "code.cmd"

import Pkg
Pkg.UPDATED_REGISTRY_THIS_SESSION[] = true
using Revise
using BenchmarkTools
using Weave


atreplinit() do repl
    try
        @eval using OhMyREPL
    catch e
        @warn "error while importing OhMyREPL" e
    end
end


############ my functions
function connect_laptop()
	@eval using Pluto
	Pluto.run(;port=1234,threads=12,require_secret_for_access=false,launch_browser=false)
end

"""
    super_types(T::Type, indent_level=0)

show all the supertypes
"""
function super_types(T::Type, indent_level=0)
    if T == Any
        println(" "^indent_level, T)
    else
        super_types(supertype(T), indent_level + 3)
        println(" "^indent_level, T)
    end
end


"""
    sub_types(T::Type, indent_level=0)

show all the subtypes
"""
function sub_types(T::Type, indent_level=0)
    println(" "^indent_level, T)
    for S in subtypes(T)
        sub_types(S, indent_level + 3)
    end
    return nothing
end

"clear terminal"
function clear()
    if Sys.iswindows()
        run(`powershell cls`)
        return nothing
    end
end

"show things in vscode table"
macro vsshow(expr)
    vscodedisplay(eval(expr))
end

# to_expr(x) = x 
# to_expr(t::Tuple) = Expr(to_expr.(t)...) # Recursive to_expr implementation courtesy of Mason Protter
# lisparse(x) = to_expr(eval(Meta.parse(x))) # Note that the `eval` in here means that any normal (non-s-expression) Julia syntax gets treated a bit like a preprocessor macro: evaluated _before_ the s-expression syntax is compiled and evaluated
# function lispmode()
#     # READ
#     printstyled("\nlisp> ", color=:magenta, bold=true)
#     l = readline()
#     while l !== "(:exit)"
#         try # So we don't get thrown out of the mode
#             # EVAL
#             result = eval(lisparse(l))
#             # PRINT, making sure that printed results are also in s-expression syntax where applicable
#             if isa(result, Expr)
#                 Meta.show_sexpr(result)
#                 println()
#             elseif isa(result, Tuple)
#                 Meta.show_sexpr(:($(result...),))
#                 println()
#             else
#                 display(result)
#             end
#         catch e
#             display(e)
#         end
#         # LOOP
#         printstyled("\nlisp> ", color=:magenta, bold=true)
#         l = readline()
#     end
# end