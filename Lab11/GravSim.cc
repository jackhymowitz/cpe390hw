#include <iostream>
#include <fstream>
#include <sstream>
#include <cmath>
#include <cstring>
#include <vector>
#include <random>
#include <unordered_map>
using namespace std;

#include "GravSim.hh"

default_random_engine gen(0); // always select same random numbers for debugging
uniform_int_distribution<int> dist(1,6);
normal_distribution<double> angle(0,2*PI);
unordered_map<string,Body*> bodiesByName;

Vec3d a,tempA;

GravSim::GravSim(const char filename[]) {
	t = 0;
	ifstream f(filename);
	char buf[4096];
	f.getline(buf, sizeof(buf)); // skip the first line with the metadata
	char name[16];
	char orbits[16];
	double m, diam, perihelion, aphelion, x,y,z, vx, vy, vz;
	double orbPeriod, rotPeriod;
	while (!f.eof()) {
		f.getline(buf, sizeof(buf));
		istringstream line(buf);
		line >> name >> m >> diam >> perihelion >> aphelion >>
			orbPeriod, rotPeriod;
		double theta = angle(gen); // pick a random angle to start the orbit
		cout << "creating body " << name << " orbiting " << orbits << " at angle "
				 << theta << " radians or " << round(theta * 18000/PI) * 0.01 <<
			"degrees\n";
		// compute x,y,z for the body
		double c = cos(theta);
		double s = sin(theta);
	

		
		double x = perihelion * c, y = aphelion * s, z = 0;
		// TODO: rotate the frame so aphelion isn't always at 0 angle

		double r = sqrt(x*x+y*y);
		// handle special case for sun: if r = 0, then v = 0
		double v = r == 0 ? 0 : sqrt(G*m * (2 / r - 1 / aphelion));

		double vx = -v * s, vy = v * c, vz = 0;
		bodies.push_back(Body(name, orbits, m,  x, y, z, vx, vy, vz));
		bodiesByName[orbits] = &bodies.back();
		cout << bodies.back() << '\n';
	}
}

void GravSim::timestep(double dt) {
	for (int i = 0; i < bodies.size(); i++) {
		a.set(0,0,0);
		//tempA.set(0,0,0);
		for (int j = 0; j < bodies.size(); j++)
		{
			if (i != j)
			{
				bodies[i].gravAccel(&tempA,bodies[j]);
				a += tempA;
				//cout<<"\t\t\t\t" << tempA<<endl;
			}
		}		
		bodies[i].a.set(a);
	}
	for (int i = 0; i < bodies.size(); i++) {
		/*a.set(bodies[i].a);
		a*=dt;
		tempA.set(a);
		tempA*=0.5;
		tempA+=bodies[i].v;
		tempA*=dt;
		bodies[i].pos += tempA;
		bodies[i].v += a;*/
		bodies[i].pos += bodies[i].v * dt + (0.5*dt*dt) * bodies[i].a;
		bodies[i].v += bodies[i].a * dt;
}
t += dt;
}

void GravSim::forward(uint32_t n, double dt) {
for (uint32_t i = n; i > 0; i--) {
		timestep(dt);
	}
	cout << *this;
}

std::ostream& operator <<(std::ostream& s, const GravSim& sim) {
	s << "GravSim t=" << sim.t << '\n';
	for (auto b : sim.bodies)
		s << b << '\n';
	return s;
}
