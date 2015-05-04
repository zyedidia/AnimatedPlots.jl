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

A `StaticGraph` object can also be passed to `plot` if you want to be able to modify the graph afterward (such as changing the color or line thickness)

```
julia> sin_graph = StaticGraph(sin, thickness=5, color=SFML.blue) # thickness and color
julia> plot(sin_graph)
julia> sin_graph.color = SFML.green
julia> plot(cos)
julia> close(current_window())
```

### Animated Plots

You can use the `AnimatedGraph` to make animated plots.

```
julia> animated_sin = AnimatedGraph(sin)
julia> plot(animated_sin)
julia> animated_cos = AnimatedGraph(cos, color=SFML.blue, startx=-10)
julia> animated_cos.speed = 100 # Speed in pixels per second
julia> plot(animated_cos)
```
