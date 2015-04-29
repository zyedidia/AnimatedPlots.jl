module AnimatedPlots

using Reexport
importall SFML

# Pixels per unit
global ppu = 20

include("graph.jl")
include("axis.jl")
include("plotwindow.jl")

windows = PlotWindow[]

function static_plot(graph::Graph, name, width, height)
	window = create_window(name, width, height)
	add_graph(window, graph)
	redraw(window)
	t = open_window(window)
	window.task = t
	push!(windows, window)

	# return window
end
function static_plot(fun::Function, name, width, height)
	static_plot(Graph(fun), name, width, height)
end

function static_plot(graph::Graph)
	if length(windows) > 0
		add_graph(windows[end], graph)
		redraw(windows[end])
	else
		static_plot(graph, "Plot", 800, 600)
	end
end
function static_plot(fun::Function)
	if length(windows) > 0
		static_plot(Graph(fun))
	else
		static_plot(fun, "Plot", 800, 600)
	end
end

function remove(graph::Graph)
	splice!(windows[end].graphs, find(windows[end].graphs .== graph)[1])
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
