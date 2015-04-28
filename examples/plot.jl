using AnimatedPlots

sin_graph = Graph(sin, 3, SFML.red)
cos_graph = Graph(cos, 3, SFML.blue)

window = static_plot(sin_graph)
static_plot(cos_graph, window)

waitfor(window)
