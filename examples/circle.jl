using AnimatedPlots

function circle(x)
	10cos(x), 10sin(x)
end

g = StaticGraph(circle)

plot(g)

waitfor(current_window())
