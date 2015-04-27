module AnimatedPlots

using Reexport
@reexport using SFML

# Pixels per unit
global ppu = 20

include("graph.jl")
include("axis.jl")
include("plotwindow.jl")

end
