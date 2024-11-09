using Interpolations
using CairoMakie



# Lower and higher bound of interval
a = 1.0
b = 10.0
# Interval definition
x = a:1.0:b
# This can be any sort of array data, as long as
# length(x) == length(y)
y = @. cos(x^2 / 9.0) # Function application by broadcasting
# Interpolations
itp_linear = linear_interpolation(x, y)
intp_linear = scale(interpolate(y, BSpline(Linear())), x)
intp_nearest = interpolate(y, BSpline(Constant()))
itp_cubic = cubic_spline_interpolation(x, y)
# Interpolation functions
f_linear(x) = itp_linear(x)
f_linear2(x) = intp_linear(x)
f_cubic(x) = itp_cubic(x)
f_nearset(x) = intp_nearest(x)
# Plots
width, height = 1500, 800 # not strictly necessary
x_new = a:0.01:b # smoother interval, necessary for cubic spline

begin
    fig, ax, _ = scatter(x, y, markersize=10, label="Data points")
    lines!(ax, x_new, f_linear, label="Linear interpolation")
    lines!(ax, x_new, f_nearset, label="nearest interpolation2")
    lines!(ax, x_new, f_cubic, linestyle=:dash, label="Cubic Spline interpolation")
    axislegend(; position=:lb)
    save("test_interpolation.png",fig)
    fig

end