#include <iostream>
#include <fstream>
using namespace std;

#include <vector>
#include <cmath>
#include <cstdlib> // rand()
#include <ctime>   // time()

int main () {
	// Physical parameters
	int neurons = 10000;
	double v0 = -2.0, vp = 100.0;
	double I0 = 3.0;
	double J = 15;
	// double J = 0;

	// Time parameters
	double t_final = 5, t_init = 0.0;
	double h = 0.0001;
	int steps = int((t_final - t_init)/h);
	double refract_steps = int(1/(vp * h));
	// double refract_steps = 1; // For testing purposes
	double tau = 0.001; // For the synaptic activation

	// Initialize eta vector
	vector<double> eta(neurons);
	// time_t srand((unsigned) time(0));
	srand(time(0));
	for (int n = 0; n < neurons; n++) {
		eta[n] = tan(M_PI*(((double) rand() / (RAND_MAX))- 0.5 )) - 5;
	}

	// Initialize instensity vector
	vector<double> I(steps+1);
	for (int i = 0; i < steps+1; i++) {
		I[i] = I0; // Square current
		// I[i] = I0 * sin(h * i * M_PI / 20);
	}

	// Initialize mean membrane potential vector
	vector<double> v_avg(steps+1);
	v_avg[0] = v0;

	// Initialize membrane potential matrix
	vector< vector<double> > v;
	v.resize(2 , vector<double>(neurons));
	for (int n = 0; n < neurons; n++) { // Initial membrane potential satate
		v[0][n] = v0;
	}

	// Initialize threshold potential vector
	// vector<double> vt(neurons, 0.0);

	// Initialize spike and synaptic activation vectors
	vector<int> spike_times(neurons, 0);
	vector<int> fire_rate(steps+1, 0);
	vector<double> syn_act(steps+1, 0.0);

	// Open file and write first line
	ofstream v_file; // Open file
	ofstream r_file; // Open file

	// ofstream v_file ("v_avg.dat"); // Open file
	// v_file << v_avg[0] << ", " ; // Write on the file
	// v_file.close(); // Close file

	// ofstream r_file ("r_avg.dat"); // Open file
	// r_file << fire_rate[0] << ", " ; // Write on the file
	// r_file.close(); // Close file

	v_file.open("v_avg.dat" ,ios::out);
	r_file.open("r_avg.dat" ,ios::out);

	v_file << v_avg[0] << ", " ; // Write on the file
	r_file << fire_rate[0] << ", " ; // Write on the file

	// Loop
	for (int i = 1; i < steps + 1; i++) {
		for (int n = 0; n < neurons; n++) {
			if(spike_times[n] == 0 && v[0][n] >= vp) { // Save time and vt value
				// vt[n] = v[0][n];
				spike_times[n] = i;
			} else if (spike_times[n] == 0) { // Normal evolution
				v[1][n] = v[0][n] + h * ( pow(v[0][n], 2) + I[i-1] + eta[n] + J * syn_act[i-1] );
			} else if (i < spike_times[n] + 2 * refract_steps) { // Spikes
				if (i >= spike_times[n] + refract_steps) { // Post spike
					// v[1][n] = -vt[n];
					v[1][n] = -vp;
					fire_rate[i] += 1;
					if (i < spike_times[n] + refract_steps + int(tau/h)) {
						syn_act[i] += 1/(tau * neurons);
					}
				} else {
					// v[1][n] = vt[n]; // Pre spike
					v[1][n] = vp; // Pre spike
				}
			} else if (i > spike_times[n] + 2 * refract_steps) { // Reset refractory time
				spike_times[n] = 0;
				// vt[n] = 0;
			}
			v[0][n] = v[1][n]; // Reset matrix
			v_avg[i] += v[1][n];
		}
		v_file << v_avg[i]/neurons << ", " ; // Write on the file
		r_file << double(fire_rate[i])/100 << ", " ; // Write on the file
	}
	v_file.close(); // Close file
	r_file.close(); // Close file
	// v_file.close(); // Close file

	return 0;
}
