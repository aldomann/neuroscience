library("ggplot2")

#function
myfunc = function(x,a,b,c) {
	a*x*x+ b*x +c
}

#basic plot, fixed parameter a = 1, b=0, c=0
p = ggplot(data.frame(x = c(-10, 10)), aes(x))
p + stat_function(fun=function(x) { myfunc(x,1, 0, 0) } )

#this returns a function of x, given three parameters values
#(check currying on http://en.wikipedia.org/wiki/Currying)
myfunc.parametric = function(a,b,c){
	function(x) {myfunc(x,a,b,c)}
}

#using currying and the parametric function
p = ggplot(data.frame(x = c(-10, 10)), aes(x))
p + stat_function(fun=function(x) { myfunc.parametric(1, 0, 0)(x) })

#using currying and the parametric function and implicit currying over x
p = ggplot(data.frame(x = c(-10, 10)), aes(x))
p + stat_function(fun=myfunc.parametric(1, 0, 0) )


# parametric plotting

# define a parametric stat_function for plotting
function.plot.parametric = function(a, b, c) {stat_function(fun=myfunc.parametric(a, b, c))}

# one parameter a=seq(1,4)
function.plot.family=sapply(seq(1,4), function(a){a=a; function.plot.parametric(a, 0, 0)})

p = ggplot(data.frame(x = c(-10, 10)), aes(x))
for(i in function.plot.family) { p = p + i}
p

# two parameters a=seq(1,4) b=seq(-2,2)
a = seq(1,4)
b = seq(-2,2)
parameters = expand.grid(a=a,b=b)

#single apply goes over all parameter rows
function.plot.family=apply(parameters, 1, function(tuple){a=tuple[1]; b=tuple[2]; function.plot.parametric(a, b, 0)})

p = ggplot(data.frame(x = c(-10, 10)), aes(x))
for(i in function.plot.family) { p = p + i}
p
