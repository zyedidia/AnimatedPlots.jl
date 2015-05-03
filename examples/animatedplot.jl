using AnimatedPlots

animated_sin = AnimatedGraph(sin)

plot(animated_sin)
follow(current_window(), animated_sin)

waitfor(current_window())
