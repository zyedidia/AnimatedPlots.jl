using AnimatedPlots

log_graph = Graph(log, 3, SFML.magenta)
exponential_graph = Graph(x -> 2^x, 3, SFML.cyan)
exponential_graph.accuracy = 10

plot(log_graph)
plot(exponential_graph)

waitfor(AnimatedPlots.windows[end])
