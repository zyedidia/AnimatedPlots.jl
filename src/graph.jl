type Graph
	fun::Function
	points::Array{CircleShape}
	circle::CircleShape
	accuracy::Integer
end

function Graph(fun::Function, thickness = 2, color = SFML.red)
	points = CircleShape[]
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
	catch DomainError
		println("Domain Error; Ignoring")
	end
	push!(graph.points, point_circle)
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
	for i = 1:length(graph.points)
		if i > 1
			global l = Line(get_position(graph.points[i]), get_position(graph.points[i - 1]), get_thickness(graph))
			set_fillcolor(l, get_color(graph))
			SFML.draw(window, l)
		end
		SFML.draw(window, graph.points[i])
	end
end

export Graph, add_point, set_color, get_color, get_thickness, set_thickness, draw
