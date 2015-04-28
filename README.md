# AnimatedPlots

Animated plots currently only supports static plots. It is built on top of [SFML.jl] (https://github.com/zyedidia/SFML.jl) and allows for fast static plotting of functions.

# Installation

AnimatedPlots supports the same operating systems as SFML.jl: Mac OS X and Linux.

```
julia> Pkg.clone("https://github.com/zyedidia/AnimatedPlots.jl")
```

# Usage

The easiest way to plot a function is to use the `static_plot` function:

```
julia> window = static_plot(sin)
julia> close(window)
```

A graph object can also be passed to `static_plot` if you want to be able to modify the graph afterward (such as changing the color or line thickness)

```
julia> sin_graph = Graph(sin, 5, SFML.blue) # thickness and color
julia> window = static_plot(sin_graph)
julia> static_plot(cos, window)
julia> close(window)
```
