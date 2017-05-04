#include <iostream>
#include <fstream>
using namespace std;

#include <vector>

#include <cmath>
using std::pow;
using std::tan;
#include <cstdlib> // rand()
#include <ctime>   // time()

int main () {
	// Physical parameters
	int neurons = 10000;
	double v0 = -2.0, vp = 100.0;
	double I0 = 3.0;

	// Time parameters
	double t_final = 10.0, t_init = 0.0;
	double h = 0.0001;
	int steps = int((t_final - t_init)/h);
	// double refract_steps = int( 1/(vp * h) );
	double refract_steps = 5; // For testing purposes

	// Initialize eta vector
	vector<double> eta(neurons);
	srand((unsigned)time(0));
	for ( int n = 0; n < neurons; n++ ) {
		eta[n] = tan(M_PI*(((double) rand() / (RAND_MAX))- 0.5 )) - 5;
	}

	// Initialize instensity vector
	vector<double> I(steps+1);
	for (int i = 0; i < steps+1; i++) {
		I[i] = I0;
	}

	// Initialize mean membrane potential vector
	vector<double> v_avg(steps+1);
	for (int i = 0; i < steps+1; i++) {
		v_avg[i] = v0;
	}

	// Initialize membrane potential matrix
	vector< vector<double> > v;
	v.resize( 2 , vector<double>( neurons ) );
	for (int n = 0; n < neurons; n++) { // Initial membrane potential satate
		v[0][n] = v0;
	}

	// Initialize spike_times vector
	vector<double> spike_times(neurons);
		for (int n = 0; n < neurons; n++) {
		spike_times[n] = 0;
	}

	// Open file and write first line
	ofstream myfile ("v_avg.dat"); // Open file
	myfile << v_avg[0] << ", " ; // Write on the file

	// Loop
	for (int i = 1; i < steps + 1; i++) {
		for (int n = 0; n < neurons; n++) {
			if(v[0][n] >= vp ) {
				v[1][n] = -vp;
				spike_times[n] = i; // Needed to calculate refractory times
			}
			else if ( spike_times[n] == 0 ){ // Normal evolution
				v[1][n] = v[0][n] + h * ( pow(v[0][n], 2) + I[i] + eta[n] );
			}
			else if (spike_times[n] + refract_steps < i) { // Reset refractory time
				spike_times[n] = 0;
			}
			v[0][n] = v[1][n]; // Reset matrix
			v_avg[i] += v[1][n];
		}
		myfile << v_avg[i]/neurons << ", " ; // Write on the file
	}
	myfile.close(); // Close file

	return 0;
}


