module AnimatedPlots

using Reexport
importall SFML

include("graph.jl")
include("axis.jl")
include("plotwindow.jl")

windows = PlotWindow[]

function plot(graph::Graph, name, width, height)
	window = create_window(name, width, height)
	add_graph(window, graph)
	redraw(window)
	t = open_window(window)
	window.task = t
	push!(windows, window)
	nothing
end
function plot(fun::Function, name, width, height)
	plot(StaticGraph(fun), name, width, height)
end

function plot(graph::Graph, new_window=false)
	if length(windows) > 0 && !new_window
		add_graph(windows[end], graph)
		redraw(windows[end])
		nothing
	else
		plot(graph, "Plot", 800, 600)
	end
end
function plot(fun::Function, new_window=false)
	if length(windows) > 0 && !new_window
		plot(StaticGraph(fun))
	else
		plot(fun, "Plot", 800, 600)
	end
end

function get_window(graph::Graph, name="Plot", width=800, height=600)
	window = create_window(name, width, height)
	add_graph(window, graph)
	redraw(window)
	return window
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
			redraw(window)
			clear(window.renderwindow, SFML.white)
			draw(window)
			display(window.renderwindow)
		end
		splice!(windows, find(windows .== window)[1])
	end
end

function current_window()
	return windows[end]
end

export open_window, create_window, plot, remove, current_window, get_window

end
