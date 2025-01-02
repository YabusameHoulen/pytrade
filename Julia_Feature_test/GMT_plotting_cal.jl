using GMT

lat_saa = [-20.0, -5.0, -1.0, 0.0, -10.0, -23.0, -30.0, -30.0, -20.0]
lon_saa = [-90.0, -79.0, -60.0, -30.0, 0.0, 30.0, 30.0, -90.0, -90.0]
test = GMT.scatter(lat_saa, lon_saa, mc="#0072BD", show=true)

I = mosaic([-80, 60], [-80.0, 80])
viz(I)
plot!(cosd.(linspace(0, 360, 360)), lw=3,show=true)

coast(region=:global360, xaxis=(annot=60,), yaxis=(annot=30,), title="Hotspot Islands and Hot Cities",
      land=:darkgreen, water=:lightblue, area=5000, proj=:Win, figsize=15,show=true)

using GMT
basemap(
    region=(0, 360, -1.25, 1.75),
    frame=(axes=:WS, title="Two Trigonometric Functions"),
    xaxis=(annot=90, ticks=30, suffix="@."),
    yaxis=(annot=0.5, grid=10),
    par=(MAP_FRAME_TYPE=:graph, MAP_VECTOR_SHAPE=0.5),
    figsize=(20, 15),
    portrait=false,
)

# Draw sine an cosine curves
plot!(cosd.(linspace(0, 360, 360)), lw=3)
plot!(sind.(linspace(0, 360, 360)),
 pen="3p,0_6:0", par=(:PS_LINE_CAP, :round),show=true)

# Indicate the x-angle = 120 degrees
plot!([120 -1.25; 120 1.25], pen=(0.5, :dash))

T = mat2ds([360 1; 360 0; 120 -1.25; 370 -1.35; -5 1.85],
    ["18p,Times-Roman RB x = cos(@%12%a@%%)", "18p,Times-Roman RB y = sin(@%12%a@%%)",
        "14p,Times-Roman LB 120@.", "24p,Symbol LT a", "24p,Times-Roman RT x,y"])

text!(T, offset=(away=true, shift=0.2), noclip=true, font="", justify="")

# Draw a circle and indicate the 0-70 degree angle
plot!([0 0], region=(-1, 1, -1, 1), proj=:linear, figscale=3.81, marker=:circle, ms=5.1, ml=1, noclip=true, xshift=9, yshift=7)
plot!(lw="",
    [NaN NaN
        #     > x-gridline  -Wdefault
        -1 0
        1 0
        NaN NaN
        #     > y-gridline  -Wdefault
        0 -1
        0 1
        NaN NaN
        #     > angle = 0
        0 0
        1 0
        NaN NaN
        #     > angle = 120
        0 0
        -0.5 0.866025])
plot!(lw=2,
    [NaN NaN
        #     > x-gmt projection -W2p
        -0.3333 0
        0 0
        NaN NaN
        #     > y-gmt projection -W2p
        -0.3333 0.57735
        -0.3333 0], show=true)




G = gmtread("@earth_relief_15m");

# A polygon
pol = [-58 13; -58 37; -20 37; -20 13; -58 13];

# Compute the mask. Here the ``inc`` and ``registration`` should be 
# automatically assigned via the ``G`` argument in ``region`` but some bug ...
# Anyway, understanding *pixel vs grid* registration is fundamental
# https://docs.generic-mapping-tools.org/dev/cookbook/options.html#pixel-registration
mask = grdmask(pol, region=G, inc=G.inc, out_edge_in=(1,1,NaN), registration=:p);

# Now let's dig that hole
holed_earth = G * mask;

imshow(holed_earth, proj=:guess, shade=true)



