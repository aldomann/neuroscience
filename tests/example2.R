## =======================================================================
## Example2: Substrate-Producer-Consumer Lotka-Volterra model
## =======================================================================

## Note:
## Function sigimp passed as an argument (input) to model
##   (see also lsoda and rk examples)

rm(list = ls())

library(deSolve)

SPCmod <- function(t, x, parms, input)  {
	with(as.list(c(parms, x)), {
		import <- input(t)
		dS <- import - b*S*P + g*C    # substrate
		dP <- c*S*P  - d*C*P          # producer
		dC <- e*P*C  - f*C            # consumer
		res <- c(dS, dP, dC)
		list(res)
	})
}

## The parameters
parms <- c(b = 0.001, c = 0.1, d = 0.1, e = 0.1, f = 0.1, g = 0.0)

## vector of timesteps
times <- seq(0, 200, length = 101)

## external signal with rectangle impulse
signal <- data.frame(times = times,
										 import = rep(0.1, length(times)))

signal$import[signal$times >= 10 & signal$times <= 11] <- 0.2

sigimp <- approxfun(signal$times, signal$import, rule = 2)

## Start values for steady state
xstart <- c(S = 1, P = 1, C = 1)

## Solve model
out <- ode(y = xstart, times = times,
					 func = SPCmod, parms = parms, input = sigimp)

## Default plot method
plot(out)

## User specified plotting
mf <- par(mfrow = c(2, 1))
matplot(out[,1], out[,2:4], type = "l", xlab = "time", ylab = "state")
legend("topright", col = 1:3, lty = 1:3, legend = c("S", "P", "C"))
plot(out[,"P"], out[,"C"], type = "l", lwd = 2, xlab = "producer",
		 ylab = "consumer")
par(mfrow = mf)
