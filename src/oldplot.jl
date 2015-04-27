using SFML

f(x) = sin(x)
const thickness = 2
const max_point_distance = 10000^2
const movespeed = 0.5
pixels_per_unit = 20

settings = ContextSettings()
settings.antialiasing_level = 4
window = RenderWindow(VideoMode(800, 600), "Plot", settings, window_defaultstyle)
set_framerate_limit(window, 60)
event = Event()

view = View(Vector2f(0, 0), Vector2f(800, -600))

circle = CircleShape()
set_position(circle, Vector2f(-400, 0))
set_radius(circle, thickness/2)
set_origin(circle, Vector2f(thickness/2, thickness/2))
set_fillcolor(circle, SFML.red)

global points = CircleShape[]

xaxis = RectangleShape()
set_fillcolor(xaxis, Color(128, 128, 128))
set_size(xaxis, Vector2f(get_size(view).x, 2))
set_origin(xaxis, Vector2f(get_size(view).x / 2, 1))

yaxis = copy(xaxis)
rotate(yaxis, 90)

function redraw()
	set_position(xaxis, Vector2f(get_center(view).x, 0))
	set_position(yaxis, Vector2f(0, get_center(view).y))

	empty!(points)
	center = get_center(view)
	i = center.x - get_size(view).x/2
	while i <= center.x + get_size(view).x
		point = copy(circle)
		try
			set_position(point, Vector2f(i, pixels_per_unit * f(i / pixels_per_unit)))
		catch DomainError
			i += 1
			continue
		end
		push!(points, point)
		i += 1
	end
end

redraw()

old_mousepos = Vector2i(0, 0)
while isopen(window)
	# mousepos = pixel2coords(window, get_mousepos(window), view)
	# println("$(mousepos.x / pixels_per_unit) $(mousepos.y / pixels_per_unit)")
	sleep(0)
	while pollevent(window, event)
		if get_type(event) == EventType.CLOSED
			close(window)
		end
		if get_type(event) == EventType.MOUSE_MOVED
			if is_mouse_pressed(0)
				mousepos = get_mousemove(event)
				move(view, Vector2f(old_mousepos.x - mousepos.x, mousepos.y - old_mousepos.y))
				old_mousepos = mousepos
				redraw()
			end
		end
		if get_type(event) == EventType.MOUSE_BUTTON_PRESSED
			old_mousepos = get_mousebutton(event)
		end
		if get_type(event) == EventType.MOUSE_WHEEL_MOVED
			oldcenter = Vector2f(get_center(view).x / pixels_per_unit, get_center(view).y / pixels_per_unit)
			delta = get_mousewheel(event).delta
			pixels_per_unit += delta / 10
			if pixels_per_unit < 0
				pixels_per_unit = 0.01
			end
			# println(pixels_per_unit)
			set_center(view, Vector2f(oldcenter.x*pixels_per_unit, oldcenter.y*pixels_per_unit))
			redraw()
		end
	end

	set_view(window, view)

	clear(window, SFML.white)
	draw(window, xaxis)
	draw(window, yaxis)
	for i = 1:length(points)
		if i > 1
			global l = Line(get_position(points[i]), get_position(points[i - 1]), thickness)
			# if distance_squared(l.p1, l.p2)*pixels_per_unit < max_point_distance
			# set_fillcolor(l, SFML.red)
			draw(window, l)
			# end
		end
		draw(window, points[i])
	end

	display(window)
end
