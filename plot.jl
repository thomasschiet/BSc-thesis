include("quantum.jl")

using Gadfly
using DataFrames

# Range over wernerstates with p between 0 and 1
ps = 0:0.01:1
F = zeros(ps)

ks = 1:4

# Make the actual states
ρ = map(wernerState, ps)
# Do the optimisation
Fs(K) = map((state) -> Rains(state, 2, 2, K)[2], ρ)

df = DataFrame(p = ps)

df[:F1] = Fs(1)
df[:F2] = Fs(2)
df[:F3] = Fs(3)
df[:F4] = Fs(4)
df[:F5] = Fs(5)

# Plot Fidelity vs p and save it
FidelityvsP = plot(df,
  Coord.cartesian(xmin=0, xmax=1, ymin=0, ymax=1),
  layer(x="p", y="F1", Geom.line),
  layer(x="p", y="F2", Geom.line),
  layer(x="p", y="F3", Geom.line),
  layer(x="p", y="F4", Geom.line),
  layer(x="p", y="F5", Geom.line),
  Theme (
    panel_fill=color("#FFFFFF")
  ),
  Stat.xticks(ticks=[0:0.1:1]),
  Stat.yticks(ticks=[0:0.1:1]),
  Guide.XLabel("p"),
  Guide.YLabel("Fidelity"),
  Guide.Title("Fidelity of Werner states (K ranges from 1 to 5)")
)
draw(PNG("plots/wernerstates.png", 4inch, 3inch), FidelityvsP)
