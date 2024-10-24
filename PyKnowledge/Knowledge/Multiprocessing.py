# pi = 4(1 - 1/3 + 1/5 - 1/7...)


def calculate_pi(start: int, end: int):
    result = 0.0
    positive = True if start % 2 == 0 else False
    for i in range(start, end):
        temp = 1 / (float(2 * i) + 1)
        if positive:
            result += temp
        else:
            result -= temp
        positive = not positive
    return result * 4


import time
import multiprocessing as mp

iter_round = 100_000_000


### 父进程没有办法直接获取子进程数据
def multi_process():
    step = iter_round // 4
    procs = []
    for start in range(0, iter_round, step):
        p = mp.Process(target=calculate_pi, args=[start, start + step])
        p.start()
        procs.append(p)

    for p in procs:
        p.join()


### 手动建立共享内存和包装函数
def calculate_pi_wrapper(result, start, end):
    result.value = calculate_pi(start, end)


def multi_process_result():
    step = iter_round // 4
    procs = []
    for start in range(0, iter_round, step):
        result = mp.Value("d")
        p = mp.Process(target=calculate_pi_wrapper, args=[result, start, start + step])
        p.start()
        procs.append((p, result))

    pi = 0.0
    for p, v in procs:
        p.join()
        pi += v.value

    return pi


### 使用mp标准库中的内容
def multi_process_pool():
    step = iter_round // 4
    params = [(start, start + step) for start in range(0, iter_round, step)]
    with mp.Pool(4) as pool:
        pi = pool.starmap(calculate_pi, params)
    return sum(pi)


def main():
    start = time.time()
    result = calculate_pi(0, iter_round)
    print(f"time used {time.time()-start}")
    print("pi is ", result)

    start = time.time()
    result = multi_process_result()
    print(f"multiprocessing time used {time.time()-start}")
    print("pi is ", result)

    start = time.time()
    result = multi_process_pool()
    print(f"multiprocessing time used {time.time()-start}")
    print("pi is ", result)


if __name__ == "__main__":
    main()
