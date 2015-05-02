# AnimatedPlots

Animated plots currently only supports static plots (animated plots are being made). It is built on top of [SFML.jl] (https://github.com/zyedidia/SFML.jl) and allows for fast plotting of functions.

# Installation

AnimatedPlots supports the same operating systems as SFML.jl: Mac OS X and Linux.

```
julia> Pkg.clone("https://github.com/zyedidia/AnimatedPlots.jl")
```

# Usage

The easiest way to plot a function is to use the `plot` function:

### Static Plots

```
julia> plot(sin)
julia> close(current_window())
```

A graph object can also be passed to `static_plot` if you want to be able to modify the graph afterward (such as changing the color or line thickness)

```
julia> sin_graph = StaticGraph(sin, 5, SFML.blue) # thickness and color
julia> plot(sin_graph)
julia> set_color(sin_graph, SFML.green)
julia> plot(cos)
julia> close(current_window())
```

