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
	double h = 0.0001;
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
	double v[2][neurons];
	for (int n = 0; n < neurons; n++) {
		v[0][n] = v0;
	}

	double v_avg[steps + 1] = {v0};

	// Loop
	for (int i = 1; i < steps + 1; i++) {
		for (int n = 0; n < neurons; n++) {
			if(v[0][n] >= vp) {
				v[1][n] = -vp;
			}
			else {
				v[1][n] = v[0][n] + h * ( pow(v[0][n], 2) + I[i] + eta[n] );
			}
			v[0][n] = v[1][n]; // Reset matrix
			v_avg[i] += v[1][n];
		}
		v_avg[i] = v_avg[i]/neurons;
	}

	// double v_avg[steps + 1] = {};
	// for ( int i = 0; i < steps + 1; i++ ) {
	// 	for (int n = 0; n < neurons; n++) {
	// 		v_avg[i] += v[i][n];
	// 	}
	// 	v_avg[i] = v_avg[i]/neurons;
	// }

	// Save values in text file
	ofstream myfile ("v_avg.dat");
	if (myfile.is_open()){
		for ( int i = 0; i < steps+1; i++ ) {
			myfile << v_avg[i] << ", " ;
		}
		myfile.close();
	}
	else cout << "Unable to open file";

	return 0;
}


