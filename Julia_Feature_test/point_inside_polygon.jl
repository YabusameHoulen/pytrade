using CairoMakie

# 判断点是否在多边形内的函数
function point_in_polygon(point, polygon)
    x, y = point
    n = size(polygon, 1)
    inside = false

    p1x, p1y = polygon[1, :]
    for i in 1:n
        p2x, p2y = polygon[i, :]
        if y > min(p1y, p2y)
            if y <= max(p1y, p2y)
                if x <= max(p1x, p2x)
                    if p1y != p2y
                        xinters = (y - p1y) * (p2x - p1x) / (p2y - p1y) + p1x
                    end
                    if p1x == p2x || x <= xinters
                        inside = !inside
                    end
                end
            end
        end
        p1x, p1y = p2x, p2y
    end
    return inside
end

function point_in_polygon(point, polygon_points::Matrix{T}) where {T<:Real}
    ### point 
    @assert size(polygon_points, 2) == 2 "make sure the first two colons are position"
    x, y = point
    inside = false

    p1x, p1y = polygon_points[1, :]
    for (p2x, p2y) in eachrow(polygon_points[2:end, :])
        if min(p1y, p2y) < y <= max(p1y, p2y)
            if x <= max(p1x, p2x)
                xinters = (y - p1y) * (p2x - p1x) / (p2y - p1y) + p1x
                if p1x == p2x || x <= xinters
                    inside = !inside
                end
            end
        end
        p1x, p1y = p2x, p2y
    end

    return inside
end

### 区域能够围成一个Polygon
lon_saa = [-90.0, -79.0, -60.0, -30.0, 0.0, 30.0, 30.0, -90.0, -90.0]
lat_saa = [-20.0, -5.0, -1.0, 0.0, -10.0, -23.0, -30.0, -30.0, -20.0]
# 要检查的点

lon_saa_test = [-90, -90, 30, 30, -90]
lat_saa_test = [-20, -10, -10, -20, -20]

x = rand(-100:50, 5000)
y = rand(-35:0, 5000)
test_points = [x y]
# 判断点是否在多边形内

@time for (a,b) in eachrow(test_points[1000:end,:])
    a+b
end

@time for (a,b) in eachrow(@view test_points[1000:end,:])
    a+b
end

begin
    point_mask = [point_in_polygon(test_point, [lon_saa lat_saa]) for test_point in eachrow(test_points)]
    fig = lines(lon_saa, lat_saa)
    scatter!(test_points[point_mask, :], markersize=6)
    scatter!(test_points[.!point_mask, :], markersize=6)
    fig
end

begin
    point_mask = [point_in_polygon(test_point, [lon_saa_test lat_saa_test]) for test_point in eachrow(test_points)]
    fig = lines(lon_saa_test, lat_saa_test)
    scatter!(test_points[point_mask, :], markersize=5)
    scatter!(test_points[.!point_mask, :], markersize=5)
    fig
end
save("ray_casting.png", fig)

xx = [12,12,13,14]
Base.Iterators.take(eachindex(xx), 1)