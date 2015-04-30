using AnimatedPlots

sin_graph = Graph(sin, 3, SFML.red)
sin_graph.accuracy = 5
cos_graph = Graph(cos, 3, SFML.blue)
sin_graph.accuracy = 5
tan_graph = Graph(x -> tan(0.1x), 3, SFML.green)
sin_graph.accuracy = 5

static_plot(sin_graph)
static_plot(cos_graph)
static_plot(tan_graph)

waitfor(current_window())
