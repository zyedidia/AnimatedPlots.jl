module AnimatedPlots

importall SFML

include("types.jl")
include("graph.jl")
include("plotwindow.jl")
include("axis.jl")
include("gifmaker.jl")

windows = PlotWindow[]

function plot(graph::Graph, name, width, height)
	window = create_window(name=name, width=width, height=height)
	add_graph(window, graph)
	redraw(window)
	t = open_window(window)
	window.task = t
	nothing
end
function plot(fun::Function, name, width, height)
	plot(StaticGraph(fun), name, width, height)
end

function plot(graph::Graph; new_window=false)
	if length(windows) > 0 && !new_window
		add_graph(windows[end], graph)
		redraw(windows[end])
		nothing
	else
		plot(graph, "Plot", 800, 600)
	end
end
function plot(fun::Function; new_window=false)
	if length(windows) > 0 && !new_window
		plot(StaticGraph(fun))
	else
		plot(fun, "Plot", 800, 600)
	end
end

function remove(graph::Graph)
	splice!(windows[end].graphs, find(windows[end].graphs .== graph)[1])
	nothing
end

function create_window(window::RenderWindow)
	plotwindow = PlotWindow(window)
	redraw(plotwindow)
	push!(windows, plotwindow)
	return plotwindow
end

function create_window(; name="Plot", width=800, height=600)
	window = PlotWindow(name, width, height)
	redraw(window)
	push!(windows, window)
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

function follow(graph::AnimatedGraph)
	follow(current_window(), graph)
end

function unfollow()
	unfollow(current_window())
end

function screenshot(filename::String)
	image = capture(current_window().renderwindow)
	save_to_file(image, filename)
	println("Saved plot to '$filename'")
end

function make_gif(width, height, duration, filename="plot.gif", delay="0.06")
	make_gif(current_window(), width, height, duration, filename, delay)
end

function set_zoom(zoom::Real)
	current_window().ppu = zoom
	redraw(current_window(), true)
end

export open_window, create_window, plot, remove, current_window, get_window, 
follow, unfollow, screenshot, make_gif, set_zoom

end
