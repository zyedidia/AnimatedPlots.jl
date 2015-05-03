using AnimatedPlots

sin_graph = StaticGraph(sin, color=SFML.red)
sin_graph.accuracy = 5
cos_graph = StaticGraph(cos, color=SFML.blue)
sin_graph.accuracy = 5
tan_graph = StaticGraph(x -> tan(0.1x), color=SFML.green)
sin_graph.accuracy = 5

plot(sin_graph)
plot(cos_graph)
plot(tan_graph)

waitfor(current_window())
