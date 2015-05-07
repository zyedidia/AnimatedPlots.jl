abstract Graph

type StaticGraph <: Graph
	fun::Function
	points::Dict{Integer, Vector2f}
	accuracy::Integer
	color::Color
	thickness::Real
end

type AnimatedGraph <: Graph
	fun::Function
	points::Dict{Integer, Vector2f}
	accuracy::Integer
	xval::Real
	startx::Real
	speed::Real
	clock::Clock
	rtime::Real
	color::Color
	thickness::Real
end

function StaticGraph(fun::Function; thickness=2, color=SFML.red)
	points = Dict{Integer, Vector2f}()
	StaticGraph(fun, points, 1, color, thickness)
end

function AnimatedGraph(fun::Function; thickness = 2, color = SFML.red, speed = 2, startx = 0)
	points = Dict{Integer, Vector2f}()
	clock = Clock()
	AnimatedGraph(fun, points, 1, startx, startx, speed, clock, 0, color, thickness)
end

function advance(graph::AnimatedGraph, ppu::Real)
	if graph.xval == graph.startx
		graph.startx *= ppu
		graph.xval *= ppu
		restart(graph.clock)
		advancex(graph)
	end
	elapsedtime = as_seconds(get_elapsed_time(graph.clock)) + graph.rtime
	interval = 1/graph.speed * graph.accuracy / ppu
	while elapsedtime >= interval
		try
			restart(graph.clock)
			result = graph.fun(graph.xval/ppu)
			pos = Vector2f(0, 0)
			if typeof(result) <: Real
				pos = Vector2f(graph.xval, ppu*result)
			else
				pos = Vector2f(ppu*result[1], ppu*result[2])
			end
			graph.points[graph.xval] = pos
		catch exception
			println(exception)
		end
		advancex(graph)
		elapsedtime -= interval
	end
	graph.rtime = elapsedtime
end

function advancex(graph::AnimatedGraph)
	graph.xval += graph.accuracy
end

function add_point(graph::Graph, index::Integer, ppu::Real)
	try
		pos = Vector2f(0, 0)
		result = graph.fun(index/ppu)
		if typeof(result) <: Real
			pos = Vector2f(index, ppu*result)
		else
			pos = Vector2f(ppu*result[1], ppu*result[2])
		end
		graph.points[index] = pos
	catch exception
	end
end

function add_point(graph::Graph, index::Integer, pos::Vector2f)
	graph.points[index] = pos
end

function draw(window::RenderWindow, graph::Graph)
	last_pos = 0
	points = graph.points
	sortedkeys = sort(collect(keys(graph.points)))
	for key in sortedkeys
		if last_pos != 0
			l = Line(points[key], last_pos, graph.thickness)
			set_fillcolor(l, graph.color)
			SFML.draw(window, l)
			destroy(l)
		end
		last_pos = points[key]
	end
end

function remove_points_outside(graph::Graph, size::Vector2f)
	for keyval in graph.points
		if !(size.x < keyval[1] < size.y)
			delete!(graph.points, keyval[1])
		end
	end
end

export Graph, StaticGraph, AnimatedGraph
