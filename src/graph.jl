type Graph
	fun::Function
	points::Dict{Integer, CircleShape}
	circle::CircleShape
	accuracy::Integer
end

function Graph(fun::Function, thickness = 2, color = SFML.red)
	points = Dict{Integer, CircleShape}()
	circle = CircleShape()
	g = Graph(fun, points, circle, 1)
	set_origin(g.circle, Vector2f(thickness/2, thickness/2))
	set_color(g, color)
	set_thickness(g, thickness)
	return g
end

function add_point(graph::Graph, index::Integer)
	point_circle = copy(graph.circle)
	try
		set_position(point_circle, Vector2f(index, ppu*graph.fun(index/ppu)))
		graph.points[index] = point_circle
	catch DomainError
		destroy(point_circle)
	end
end

function add_point(graph::Graph, shape::CircleShape)
	point_circle = copy(graph.circle)
	set_position(point_circle, get_position(shape))
	graph.points[get_position(shape).x] = point_circle
	destroy(shape)
end

function set_color(graph::Graph, color::Color)
	set_fillcolor(graph.circle, color)
end

function get_color(graph::Graph)
	get_fillcolor(graph.circle)
end

function set_thickness(graph::Graph, thickness::Real)
	set_radius(graph.circle, thickness/2)
end

function get_thickness(graph::Graph)
	get_radius(graph.circle) * 2
end

function draw(window::RenderWindow, graph::Graph)
	last_circle = 0
	points = graph.points
	sortedpoints = sort(collect(keys(graph.points)))
	for key in sortedpoints
		if last_circle != 0
			global l = Line(get_position(points[key]), get_position(last_circle), get_thickness(graph))
			set_fillcolor(l, get_color(graph))
			SFML.draw(window, l)
		end
		# SFML.draw(window, points[key])
		last_circle = points[key]
	end
end

function remove_points_outside(graph::Graph, size::Vector2f)
	for keyval in graph.points
		if !(size.x < keyval[1] < size.y)
			destroy(graph.points[keyval[1]])
			delete!(graph.points, keyval[1])
		end
	end
end

export Graph, add_point, set_color, get_color, get_thickness, set_thickness, draw,
remove_points_outside
