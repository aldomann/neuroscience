#include <Rcpp.h>
using namespace Rcpp;

#include <cmath>
using std::pow;
using std::tan;
#include <cstdlib> // rand()
#include <ctime>   // time()

// Time
double t_final = 1.0, t_init = 0.0;
double h = 0.0001;
int steps = int((t_final - t_init)/h);

// Parameters
int neurons = pow(10, 4);
double v0 = -2.0, vp = 100.0;

// [[Rcpp::export]]
NumericVector get_v_avg () {
	// Initialize eta vector
	NumericVector eta(neurons);
	srand((unsigned)time(0));
	for ( int n = 0; n < neurons; n++ ) {
		eta(n) = tan(M_PI*(((double) rand() / (RAND_MAX))- 1/2 )) - 5;
	}

	NumericVector I(steps + 1, 3.0);

	// Voltage matrix
	NumericMatrix v(steps + 1, neurons);
	// Initialise
	for (int n = 0; n < neurons; n++) {
		v(n,0) = v0;
	}
	// Loop
	for (int i = 1; i < steps + 1; i++) {
		for (int n = 0; n < neurons; n++) {
			if(v(n,i-1) >= vp) {
				v(n,i) = -vp;
			}
			else {
				v(n,i) = v(n,i-1) + h * ( pow(v(n,i-1), 2) + I(i) + eta(n) );
			}
		}
	}
	gc();

	// NumericVector v_avg(steps + 1);
	// for ( int i = 0; i < steps + 1; i++ ) {
	// 	for (int n = 0; n < neurons; n++) {
	// 		v_avg(i) += v(n,i);
	// 	}
	// 	v_avg(i) = v_avg(i)/neurons;
	// 	// v_avg(i) = eta(i)/neurons;
	// }

	return eta;
}

