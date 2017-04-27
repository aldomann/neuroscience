b <- ggplot(mtcars, aes(wt, mpg)) +
	geom_point()

df <- data.frame(x1 = 2.62, x2 = 3.57, y1 = 21.0, y2 = 15.0)
b +
	geom_curve(aes(x = x1, y = y1, xend = x2, yend = y2, colour = "curve"), data = df) +
	geom_segment(aes(x = x1, y = y1, xend = x2, yend = y2, colour = "segment"), data = df)

b + geom_curve(aes(x = x1, y = y1, xend = x2, yend = y2), data = df, curvature = -0.2)
b + geom_curve(aes(x = x1, y = y1, xend = x2, yend = y2), data = df, curvature = 1)
b + geom_curve(
	aes(x = x1, y = y1, xend = x2, yend = y2),
	data = df,
	arrow = arrow(length = unit(0.03, "npc"))
)

ggplot(seals, aes(long, lat)) +
	geom_segment(aes(xend = long + delta_long, yend = lat + delta_lat),
							 arrow = arrow(length = unit(0.1,"cm"))) +
	borders("state")

# You can also use geom_segment to recreate plot(type = "h") :
counts <- as.data.frame(table(x = rpois(100,5)))
counts$x <- as.numeric(as.character(counts$x))
with(counts, plot(x, Freq, type = "h", lwd = 10))

ggplot(counts, aes(x, Freq)) +
	geom_segment(aes(xend = x, yend = 0), size = 10, lineend = "butt")
