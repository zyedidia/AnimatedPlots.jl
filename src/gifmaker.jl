function make_gif(window::PlotWindow, width, height, duration, filename="plot.gif", delay=0.06)
	SFML.make_gif(window.renderwindow)
end

export make_gif
