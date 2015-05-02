using AnimatedPlots

sin_graph = StaticGraph(sin, 3, SFML.red)
sin_graph.accuracy = 5
cos_graph = StaticGraph(cos, 3, SFML.blue)
sin_graph.accuracy = 5
tan_graph = StaticGraph(x -> tan(0.1x), 3, SFML.green)
sin_graph.accuracy = 5

plot(sin_graph)
plot(cos_graph)
plot(tan_graph)

waitfor(current_window())
