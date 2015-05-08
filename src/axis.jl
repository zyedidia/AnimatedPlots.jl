function Axis(view::View, xaxis::Bool)
	axis = RectangleShape()

	set_fillcolor(axis, Color(128, 128, 128))
	set_size(axis, Vector2f(get_size(view).x, 2))
	set_origin(axis, Vector2f(get_size(view).x/2, 1))
	if !xaxis
		set_rotation(axis, 90)
	end

	marks = RectangleShape[]
	numbers = RenderText[]

	tic = RectangleShape()
	set_fillcolor(tic, Color(128, 128, 128))
	set_size(tic, Vector2f(10, 1))
	set_origin(tic, Vector2f(5, 0.5))

	number = RenderText()
	set_charactersize(number, 15)
	set_scale(number, Vector2f(1, -1))
	set_color(number, Color(128, 128, 128))

	Axis(axis, marks, numbers, xaxis, number, tic, 5)
end

function update(axis::Axis, window::PlotWindow)
	if axis.xaxis
		set_position(axis.axis, Vector2f(get_center(window.view).x, 0))
	else
		set_position(axis.axis, Vector2f(0, get_center(window.view).y))
	end
	ppu = window.ppu
	view = window.view
	empty!(axis.marks)
	empty!(axis.numbers)
	center = get_center(view)
	# axis.tic_period = round(1/ppu * 100)
	tic_period = axis.tic_period

	if axis.xaxis
		right = Int(round((center.x + get_size(view).x/2)/ppu))
		left = Int(round((center.x - get_size(view).x/2)/ppu))
		while left % tic_period != 0
			left += 1
		end
		for i = left:tic_period:right
			if i % axis.tic_period == 0
				tic = copy(axis.tic)
				set_rotation(tic, 90)

				number = copy(axis.number)
				set_string(number, "$i")
				bounds = get_globalbounds(number)
				set_origin(number, Vector2f(bounds.width / 2, bounds.height / 2))

				set_position(number, Vector2f(i*ppu, 20))
				if center.y < 0
					ypos = min(center.y - get_size(view).y/2, 0)
					set_position(tic, Vector2f(i*ppu, ypos))
					set_position(number, Vector2f(i*ppu, -20+ypos))
				else
					ypos = max(center.y + get_size(view).y/2, 0)
					set_position(tic, Vector2f(i*ppu, ypos))
					set_position(number, Vector2f(i*ppu, 20+ypos))
				end
				push!(axis.marks, tic)
				push!(axis.numbers, number)
			end
		end
	else
		up = Int(round((center.y - get_size(view).y/2)/ppu))
		down = Int(round((center.y + get_size(view).y/2)/ppu))
		while down % tic_period != 0
			down += 1
		end
		for i = down:tic_period:up
			if i % axis.tic_period == 0
				tic = copy(axis.tic)

				number = copy(axis.number)
				set_string(number, "$i")
				bounds = get_globalbounds(number)
				set_origin(number, Vector2f(bounds.width / 2, bounds.height / 2))

				if center.x < 0
					xpos = min(center.x + get_size(view).x/2, 0)
					set_position(tic, Vector2f(xpos, i*ppu))
					set_position(number, Vector2f(-20+xpos, i*ppu))
				else
					xpos = max(center.x - get_size(view).x/2, 0)
					set_position(tic, Vector2f(xpos, i*ppu))
					set_position(number, Vector2f(20+xpos, i*ppu))
				end
				push!(axis.marks, tic)
				push!(axis.numbers, number)
			end
		end
	end
end

function draw(window::PlotWindow, axis::Axis)
	SFML.draw(window.renderwindow, axis.axis)
	for i = 1:length(axis.marks)
		SFML.draw(window.renderwindow, axis.marks[i])
		SFML.draw(window.renderwindow, axis.numbers[i])
	end
end
