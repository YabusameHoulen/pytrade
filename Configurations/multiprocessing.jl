Threads.nthreads()

slow_add(x,y)=(sleep(0.001); x+y) # 暂停一段时间再相加
function arr_add(A, B)
    C = similar(A)
    for i in eachindex(A)
        C[i] = slow_add(A[i], B[i])
    end
    return C
end

function arr_add_par(A, B)
    C = similar(A)
    Threads.@threads for i in eachindex(A)
        C[i] = slow_add(A[i], B[i])
    end
    return C
end

A = rand(100)
arr_add(A, A);     # 先执行一遍 arr_add 函数
arr_add_par(A, A); # 先执行一遍 arr_add_par 函数

@time arr_add(A,A);
@time arr_add_par(A,A);


using Base.Threads # 多线程的函数都是Threads.xxx，这里using 就不用写前面部分了
function test1()
    id = 0
    @threads for _ in 1:5
        id = threadid() # threadid()会返回线程编号
        sleep(0.01)
        println(threadid()," ",id) # 输出线程编号和变量id
    end
end

function test2()
    @threads for _ in 1:5
        id = threadid()
        sleep(0.01)
        println(threadid()," ",id)
    end
end


test1()
test2()



function test3(N)
    A = Array{Int}(undef,N)
    for i in 1:N
        arr_tmp = [i, 2i]    # 循环内部生成临时数组
        A[i] = sum(arr_tmp)
    end
    return A
end

function test4(N)
    A = Array{Int}(undef,N)
    arr_tmp = zeros(Int,2)  # 循环外部先生成临时数组
    for i in 1:N
        arr_tmp[1] = i      # 循环里只修改数组
        arr_tmp[2] = 2i
        A[i] = sum(arr_tmp)
    end
    return A
end

test3(10);test4(10); # 先执行一遍以消去编译时间
@time test3(1000);
# 0.000019 seconds (2.00 k allocations: 86.062 KiB)
@time test4(1000);
# 0.000006 seconds (5 allocations: 8.016 KiB)




using LinearAlgebra
# BLAS.set_num_threads(1)   # 设置线形代数库的线程数为1
using Base.Threads
using ChunkSplitters
using CairoMakie

function cal_H!(H, v, N)   # 计算H矩阵
    for i in 1:2:2N-2
        H[i,i+1] = v
        H[i+1,i+2] = 1.0   # w = 1 
    end
    H[end-1,end] = v
    nothing
end

function eig_ssh(vlist,N)   # 不并行版本
    en = Array{Float64}(undef, 2*N, length(vlist))
    ev = Array{Float64}(undef, 2*N,2*N, length(vlist))
    H = zeros(Float64, 2*N,2*N) # 先生成个 H 矩阵
    for i in eachindex(vlist)
        cal_H!(H, vlist[i], N)  # 修改 H 矩阵
        en[:,i],ev[:,:,i] = eigen(Hermitian(H))
    end
    return en,ev
end

function eig_ssh_par(vlist,N)   # 并行版本，N为系统大小, vlist为v组成的列表(数组)
    en = Array{Float64}(undef, 2*N, length(vlist))
    ev = Array{Float64}(undef, 2*N,2*N, length(vlist))
    chunk = chunks(eachindex(vlist), n=nthreads())
    @threads for ch in chunk
        H = zeros(Float64, 2*N,2*N) # 每个线程先生成个 H 矩阵
        for i in ch
            cal_H!(H, vlist[i], N)  # 修改 H 矩阵
            en[:,i],ev[:,:,i] = eigen(Hermitian(H))
        end
    end
    return en,ev
end

vlist = range(0, 3, 64)
@time en,ev = eig_ssh(vlist, 20)
f = Figure(size=(650,400))
series(f[1:3,1],vlist,en,solid_color=:blue,axis=(limits=(0,3,-3,3),))
barplot(f[1,2],ev[:,20,9])  # 边界态
barplot(f[2,2],ev[:,21,9])  # 边界态
barplot(f[3,2],ev[:,24,9])  # 体态
f