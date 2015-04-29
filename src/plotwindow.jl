type PlotWindow
	renderwindow::RenderWindow
	graphs::Array{Graph}
	view::View
	event::Event
	last_mousepos::Vector2f
	xaxis::RectangleShape
	yaxis::RectangleShape
	task
end

function PlotWindow(plotname::String, width::Integer, height::Integer)
	settings = ContextSettings()
	settings.antialiasing_level = 4
	window = RenderWindow(VideoMode(width, height), plotname, settings, window_defaultstyle)
	set_framerate_limit(window, 60)

	graphs = Graph[]

	view = View(Vector2f(0, 0), Vector2f(width, -height))
	event = Event()

	xaxis = RectangleShape()
	set_fillcolor(xaxis, Color(128, 128, 128))
	set_size(xaxis, Vector2f(get_size(view).x, 2))
	set_origin(xaxis, Vector2f(get_size(view).x/2, 1))

	yaxis = RectangleShape()
	set_fillcolor(yaxis, Color(128, 128, 128))
	set_size(yaxis, Vector2f(get_size(view).y, 2))
	set_origin(yaxis, Vector2f(get_size(view).y/2, 1))
	rotate(yaxis, 90)

	PlotWindow(window, graphs, view, event, Vector2f(0, 0), xaxis, yaxis, nothing)
end

function add_graph(window::PlotWindow, graph::Graph)
	push!(window.graphs, graph)
end

function redraw(window::PlotWindow)
	update_xaxis(window.renderwindow, window.view, window.xaxis)
	update_yaxis(window.renderwindow, window.view, window.yaxis)

	center = get_center(window.view)
	i = Int(center.x - get_size(window.view).x/2)
	while i <= center.x + get_size(window.view).x/2
		for j = 1:length(window.graphs)
			if i % window.graphs[j].accuracy == 0
				if haskey(window.graphs[j].points, i)
					add_point(window.graphs[j], window.graphs[j].points[i])
				else
					add_point(window.graphs[j], i)
				end
			end
		end

		i += 1
	end
	points_copies = 0
end

function check_input(window::PlotWindow)
	while pollevent(window.renderwindow, window.event)
		if get_type(window.event) == EventType.CLOSED
			close(window)
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
				redraw(window)
			end
		end
	end
end

function garbagecollect(window::PlotWindow)
	center = get_center(window.view)
	width = Vector2f(center.x - get_size(window.view).x/2, center.x + get_size(window.view).x/2)
	for i = 1:length(window.graphs)
		remove_points_outside(window.graphs[i], width)
	end
end

function isopen(window::PlotWindow)
	SFML.isopen(window.renderwindow)
end

function draw(window::PlotWindow)
	clear(window.renderwindow, SFML.white)
	set_view(window.renderwindow, window.view)
	SFML.draw(window.renderwindow, window.xaxis)
	SFML.draw(window.renderwindow, window.yaxis)
	for i = 1:length(window.graphs)
		draw(window.renderwindow, window.graphs[i])
	end
	display(window.renderwindow)
end

function close(window::PlotWindow)
	println("close")
	SFML.close(window.renderwindow)
end

function waitfor(window::PlotWindow)
	Base.wait(window.task)
end

export PlotWindow, add_graph, redraw, check_input, isopen, draw, close, waitfor
