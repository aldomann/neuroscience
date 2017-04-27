library(tidyverse)
library(Rcpp)

# cppFunction('NumericVector get_eta () {
#
# NumericVector eta(10);
# srand((unsigned)time(0));
# for ( int n = 0; n < 10; n++ ) {
# 	eta(n) = tan(M_PI*(((double) rand() / (RAND_MAX))- 1/2 )) - 5;
# }
# return eta;
# }')
#
# eta <- data.frame(eta = get_eta())

sourceCpp("qif_solve2.cpp")

v.qif = data.frame(v.avg = get_v_avg())

ggplot(v.qif)+
	geom_line(mapping = aes(y = v.avg, x = seq(1, length(v.avg))),
						colour = "darkorange") +
	labs(x = "Time (s)", y = "v")
