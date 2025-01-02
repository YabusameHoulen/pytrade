using GMT
function mandelbrot(z)
    w = z
    for n in 1:74
        abs2(w) < 4 ? w = w^2 + z : return n
    end
    75
end
x, y = range(-0.65, -0.45; length=1600), range(0.51, 0.71; length=1600);
imshow(-log.(mandelbrot.(x' .+ y .* im)), frame=:none, title="Mandelbrot painting", figsize=20)



using GMT

t = 0:0.1:2pi;
plot([t cos.(t) cos.(t .+ 0.1)], multi=true, inset=(zoom=(pi, pi / 4), box=(fill=:lightblue,)), show=true)


using DelimitedFiles


matrix::Matrix{Int}, dim::Int = read_data("test.txt")



function Djikstra(matrix, dim=size(matrix, 1))
    node_dict = Dict((1, 1) => matrix[1, 1]) ## 用小的字典动态增减，查找加速
    node_set = Set() ## 记录遍历过的值

    current = (1, 1)

    ### 记录路径需要记录中间状态值
    total = typemax(Int) ## 一个很大的数 >= 矩阵元素和
    cord = Iterators.product(1:dim, 1:dim) |> collect  ## 矩阵坐标
    recording_nodes = Dict(key => total for key in cord)
    previous_nodes = Dict(key => (dim, dim) for key in cord)

    while current != (dim, dim)
        for direction in [(-1, 0), (0, 1), (1, 0), (0, -1)]
            next = current .+ direction
            ### 坐标判断
            (next in node_set ||
             next[1] in [0, dim + 1] ||
             next[2] in [0, dim + 1]) && continue
            new_val = node_dict[current] + matrix[next...]
            ### 更新路径值
            node_dict[next] = next ∉ keys(node_dict) ?
                              new_val :
                              min(new_val, node_dict[next])
            ### 记录路径
            if new_val < recording_nodes[next]
                recording_nodes[next] = new_val
                previous_nodes[next] = current
            end
        end
        delete!(node_dict, current) ## 删掉不需要的node
        push!(node_set, current)
        current = findmin(values, node_dict) |> last
    end

    path_sum = node_dict[current]
    ### 得到经过的路径
    find_path = [(dim, dim)]
    while current !== (1, 1)
        current = get(previous_nodes, current, 1)#pr)evious_nodes[current]
        push!(find_path, current)
    end

    return path_sum, find_path |> reverse!
end


function Djikstra(matrix, dim)
    node_dict = Dict((1, 1) => matrix[1, 1]) ## 用小的字典动态增减，查找加速
    node_set = Set() ## 记录遍历过的值
    current = (1, 1)

    ### 记录路径需要记录中间状态值
    total = typemax(Int) ## 一个很大的数 >= 矩阵元素和
    cord = Iterators.product(1:dim, 1:dim) |> collect  ## 矩阵坐标
    recording_nodes = Dict(key => total for key in cord)
    previous_nodes = Dict(key => (dim, dim) for key in cord)

    while current != (dim, dim)
        for direction in [(-1, 0), (0, 1), (1, 0), (0, -1)]
            next = current .+ direction
            ### 坐标判断
            (next in node_set ||
             next[1] in [0, dim + 1] ||
             next[2] in [0, dim + 1]) && continue
            new_val = node_dict[current] + matrix[next...]
            ### 更新路径值
            node_dict[next] = next ∉ keys(node_dict) ?
                              new_val :
                              min(new_val, node_dict[next])
            ### 记录路径
            if new_val < recording_nodes[next]
                recording_nodes[next] = new_val
                previous_nodes[next] = current
            end
        end
        delete!(node_dict, current) ## 删掉不需要的node
        push!(node_set, current)
        current = findmin(values, node_dict) |> last
    end

    path_sum = node_dict[current]
    ### 得到经过的路径
    find_path = [(80, 80)]
    while current !== (1, 1)
        current = previous_nodes[current]
        push!(find_path, current)
    end

    return path_sum, find_path |> reverse!
end
@time path_sum, path = Djikstra(matrix)

using DelimitedFiles
matrix = readdlm("test.txt", ',', Int)

@code_warntype Djikstra(matrix, 80)

@benchmark Djikstra(matrix, 80) evals=10 samples = 100



# 定义一个示例函数
function my_function(x, y)
    return x^2 + y^2
end

# 基准测试，设置样本次数和运行次数
@benchmark my_function(3, 4) evals = 10 samples = 1000

# 显示基准测试结果
