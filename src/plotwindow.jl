type PlotWindow
	renderwindow::RenderWindow
	graphs::Array{Graph}
	view::View
	event::Event
	last_mousepos::Vector2f
	xaxis::Axis
	yaxis::Axis
	ppu::Real
	followgraph::AnimatedGraph
	task
end

function PlotWindow(window::RenderWindow)
	width = get_size(window).x; height = get_size(window).y
	graphs = Graph[]

	view = View(Vector2f(0, 0), Vector2f(width, -height))
	event = Event()

	xaxis = Axis(view, true)
	yaxis = Axis(view, false)

	PlotWindow(window, graphs, view, event, Vector2f(0, 0), xaxis, yaxis, 20, AnimatedGraph(x -> 0), nothing)
end

function PlotWindow(plotname::AbstractString, width::Integer, height::Integer)
	settings = ContextSettings()
	settings.antialiasing_level = 4
	window = RenderWindow(VideoMode(width, height), plotname, settings, window_resize)
	# set_framerate_limit(window, 60)

	PlotWindow(window)
end

function add_graph(window::PlotWindow, graph::Graph)
	push!(window.graphs, graph)
end

function redraw(window::PlotWindow, fullredraw=false)
	center = get_center(window.view)
	left = Int(round(center.x - get_size(window.view).x/2))
	right = Int(round(center.x + get_size(window.view).x/2))

	if window.followgraph in window.graphs
		set_center(window.view, Vector2f(window.followgraph.xval - get_size(window.view).x/2 + 20, 0))
	end

	update(window.xaxis, window)
	update(window.yaxis, window)

	for j = 1:length(window.graphs)
		i = left
		if typeof(window.graphs[j]) == AnimatedGraph
			if window.graphs[j].xval > right
				advancex(window.graphs[j])
			else
				advance(window.graphs[j], window.ppu)
			end
		end
		while i <= right
			if typeof(window.graphs[j]) == AnimatedGraph
				if i > window.graphs[j].xval
					break
				end
			end
			# if typeof(window.graphs[j]) == StaticGraph
				if i % window.graphs[j].accuracy == 0
					if !fullredraw
						if haskey(window.graphs[j].points, i)
							add_point(window.graphs[j], i, window.graphs[j].points[i])
						else
							add_point(window.graphs[j], i, window.ppu)
						end
					else
						add_point(window.graphs[j], i, window.ppu)
					end
				end
				i += 1
			# else
			# 	break
			# end
		end
	end
	garbagecollect(window)
end

function check_input(window::PlotWindow)
	while pollevent(window.renderwindow, window.event)
		if get_type(window.event) == EventType.CLOSED
			SFML.close(window.renderwindow)
		end
		if get_type(window.event) == EventType.MOUSE_WHEEL_MOVED
			oldcenter = Vector2f(get_center(window.view).x / window.ppu, get_center(window.view).y / window.ppu)
			delta = get_mousewheel(window.event).delta
			window.ppu += delta / 10
			if window.ppu < 0
				window.ppu = 0.01
			end
			set_center(window.view, Vector2f(oldcenter.x*window.ppu, oldcenter.y*window.ppu))
			redraw(window, true)
		end
		if get_type(window.event) == EventType.MOUSE_BUTTON_PRESSED
			mouse_event = get_mousebutton(window.event)
			window.last_mousepos = Vector2f(mouse_event.x, mouse_event.y)
		end
		if get_type(window.event) == EventType.MOUSE_BUTTON_RELEASED
			garbagecollect(window)
		end
		if get_type(window.event) == EventType.MOUSE_MOVED
			if is_mouse_pressed(0)
				mouse_event = get_mousemove(window.event)
				mousepos = Vector2f(mouse_event.x, mouse_event.y)
				move(window.view, Vector2f(window.last_mousepos.x - mousepos.x, mousepos.y - window.last_mousepos.y))
				window.last_mousepos = mousepos
			end
		end
	end
end

function garbagecollect(window::PlotWindow)
	center = get_center(window.view)
	width = Vector2f(center.x - get_size(window.view).x/2, center.x + get_size(window.view).x/2)
	for i = 1:length(window.graphs)
		# if typeof(window.graphs[i]) == StaticGraph
			remove_points_outside(window.graphs[i], width)
		# end
	end
end

function isopen(window::PlotWindow)
	SFML.isopen(window.renderwindow)
end

function follow(window::PlotWindow, graph::Graph)
	window.followgraph = window.graphs[find(window.graphs .== graph)[1]]
	nothing
end

function unfollow(window::PlotWindow)
	window.followgraph = AnimatedGraph(x -> 0)
end

function draw(window::PlotWindow)
	set_view(window.renderwindow, window.view)
	draw(window, window.xaxis)
	draw(window, window.yaxis)
	for i = 1:length(window.graphs)
		draw(window.renderwindow, window.graphs[i])
	end
end

function close(window::PlotWindow)
	SFML.close(window.renderwindow)
end

function waitfor(window::PlotWindow)
	Base.wait(window.task)
end

export PlotWindow, add_graph, redraw, check_input, isopen, draw, close, waitfor, follow
