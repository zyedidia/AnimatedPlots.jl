using AnimatedPlots

log_graph = StaticGraph(log, color=SFML.magenta)
exponential_graph = StaticGraph(x -> 2^x, color=SFML.cyan)
exponential_graph.accuracy = 10

plot(log_graph)
plot(exponential_graph)

waitfor(current_window())
