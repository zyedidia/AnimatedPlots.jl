using AnimatedPlots

log_graph = Graph(log, 3, SFML.magenta)

window = static_plot(log_graph)

waitfor(window)
