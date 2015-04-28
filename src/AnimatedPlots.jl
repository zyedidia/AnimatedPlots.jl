module AnimatedPlots

using Reexport
importall SFML

# Pixels per unit
global ppu = 20

include("graph.jl")
include("axis.jl")
include("plotwindow.jl")

function static_plot(graph::Graph, name="Plot", width=800, height=600)
	window = create_window(name, width, height)
	add_graph(window, graph)
	redraw(window)
	t = open_window(window)
	window.task = t

	return window
end
function static_plot(fun::Function, name="Plot", width=800, height=600)
	static_plot(Graph(fun), name, width, height)
end

function static_plot(graph::Graph, window::PlotWindow)
	add_graph(window, graph)
	redraw(window)
end
function static_plot(fun::Function, window::PlotWindow)
	static_plot(Graph(fun), window)
end

function remove(window, graph::Graph)
	splice!(window.graphs, find(window.graphs .== graph)[1])
end

function create_window(name="Plot", width=800, height=600)
	window = PlotWindow(name, width, height)
	redraw(window)
	return window
end

function open_window(window::PlotWindow)
	@async begin
		while isopen(window)
			sleep(0)
			check_input(window)
			draw(window)
		end
	end
end

export open_window, create_window, static_plot, remove

end
