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
	// Time
	double t_final = 1.0, t_init = 0.0;
	double h = 0.0001;
	int steps = int((t_final - t_init)/h);

	// Parameters
	int neurons = pow(10, 4);
	// int neurons = 5;
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

	// Membrane potential matrix using st::vector
	vector< vector<double> > v;

	// First time step (initial state)
	vector<double> row; // Create an empty row
	for (int n = 0; n < neurons; n++) { // Initialise first row
		row.push_back(1 * n); // Add a column to the row
	}
	v.push_back(row); // Add the row to the main vector

	for (int n = 0; n < neurons; n++) { // Assign values to the first row
		v[0][n] = v0;
	}

	double v_avg[steps + 1] = {v0};

	// Loop
	for (int i = 1; i < steps + 1; i++) {
		vector<double> row; // Create an empty row
		for (int n = 0; n < neurons; n++) { // Initialise first row
			row.push_back(i * n); // Add a column to the row
		}
		v.push_back(row); // Add the row to the main vector
		for (int n = 0; n < neurons; n++) {
			// Calculations
			if(v[i-1][n] >= vp) {
				v[i][n] = -vp;
			}
			else {
				v[i][n] = v[i-1][n] + h * ( pow(v[i-1][n], 2) + I[i] + eta[n] );
			}
			v_avg[i] += v[i][n]; // Mean membrane potential
		}
		cout << "step " << i << "/" << steps << " done\n";
		v[i-1].clear(); // Clear row v[i-1]
		v_avg[i] = v_avg[i]/neurons;
	}
	v[steps+1].clear(); // Clear last row

	// Save values in text file
	ofstream myfile ("v_avg_mat.dat");
	if (myfile.is_open()){
		for ( int i = 0; i < steps+1; i++ ) {
			myfile << v_avg[i] << ", " ;
		}
		myfile.close();
	}
	else cout << "Unable to open file";

	return 0;
}


