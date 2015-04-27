function update_xaxis(window::RenderWindow, view::View, axis::RectangleShape)
	set_position(axis, Vector2f(get_center(view).x, 0))
end

function update_yaxis(window::RenderWindow, view::View, axis::RectangleShape)
	set_position(axis, Vector2f(0, get_center(view).y))
end
