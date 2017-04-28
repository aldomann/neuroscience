# library(deSolve)
library(tidyverse)
library(rPython)

# Load/run the main Python script
python.load("qif_solve.py")
# system.time(python.load("qif_solve.py"))

# Get the v variable and put it in a dataframe
v_avg <- python.get("v_avg")
v_avg <- data.frame(v_avg)

# eta <- python.get("eta")

# v <- python.get("v")
# v <- data.frame(v)

ggplot(v_avg)+
	geom_line(mapping = aes(y = v_avg, x = seq(1, length(v_avg))),
						colour = "darkorange") +
	labs(x = "Time (s)", y = "v")
