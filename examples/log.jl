using AnimatedPlots

log_graph = Graph(log, 3, SFML.red)

log_graph.accuracy = 1

window = PlotWindow("Plot", 800, 600)
add_graph(window, log_graph)

redraw(window)

while AnimatedPlots.isopen(window)
	check_input(window)
	draw(window)
end
