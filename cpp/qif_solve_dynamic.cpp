#include <iostream>
#include <fstream>
using namespace std;

#include <cmath>
using std::pow;
using std::tan;
#include <cstdlib> // rand()
#include <ctime>   // time()

int main (int, char **) {
	// Time
	double t_final = 2.0, t_init = 0.0;
	double h = 0.01;
	int steps = int((t_final - t_init)/h);

	// Parameters
	int neurons = pow(10, 4);
	double v0 = -2.0, vp = 100.0;
	double I0 = 3.0;

	// Initialize eta vector
	double eta[neurons];

	srand((unsigned)time(0));
	for ( int n = 0; n < neurons; n++ ) {
		eta[n] = tan(M_PI*(((double) rand() / (RAND_MAX))- 1/2 )) - 5;
	}
	// double I[steps + 1] = {3.0};
	double I[steps+1];
	std::fill_n(I, steps+1, I0);

	// Voltage matrix
	// double v[2][neurons];
	// for (int n = 0; n < neurons; n++) {
	// 	v[0][n] = v0;
	// }

	double **v = new double*[steps + 1];
	for (size_t n = 0; n < neurons; n++) {
		v[n] = new double[neurons];
	}


	// double v_avg2[steps + 1] = {v0}; // Gives some random warning
	double v_avg[steps + 1];
	v_avg[0] = v0;

	// Loop
	for (int i = 1; i < steps + 1; i++) {
		for (int n = 0; n < neurons; n++) {
			if(v[i-1][n] >= vp) {
				v[i][n] = -vp;
			}
			else {
				v[i][n] = v[i-1][n] + h * ( pow(v[i-1][n], 2) + I[i] + eta[n] );
			}
			// Remove unnecessary vectors
			v_avg[i] += v[i][n];
		}
		v_avg[i] = v_avg[i]/neurons;
	}

	// Save values in text file
	ofstream myfile ("v_avg_dyn.dat");
	if (myfile.is_open()){
		for ( int i = 0; i < steps+1; i++ ) {
			myfile << v_avg[i] << ", " ;
		}
		myfile.close();
	}
	else cout << "Unable to open file";

	return 0;
}


