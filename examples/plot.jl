using AnimatedPlots

sin_graph = Graph(sin, 3, SFML.red)
sin_graph.accuracy = 5
cos_graph = Graph(cos, 3, SFML.blue)
cos_graph.accuracy = 5
tan_graph = Graph(x -> tan(0.1x), 3, SFML.green)

window = PlotWindow("Plot", 800, 600)
add_graph(window, sin_graph)
add_graph(window, cos_graph)
add_graph(window, tan_graph)

redraw(window)

while isopen(window)
	check_input(window)

	draw(window)
end
