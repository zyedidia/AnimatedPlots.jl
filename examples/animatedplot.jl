using AnimatedPlots

animated_sin = AnimatedGraph(sin, startx=0)
animated_cos = AnimatedGraph(cos, color=SFML.blue)

plot(animated_cos)
plot(animated_sin)
follow(animated_sin)

waitfor(current_window())
