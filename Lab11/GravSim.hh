#pragma once

#include <iostream>
#include <cmath>
#include <cstring>
#include <vector>
using namespace std;

constexpr double PI = 3.14159265358979;
constexpr double G = 6.67408e-11;

class Vec3d {
public:
	double x, y, z;
	Vec3d(double x = 0, double y = 0, double z = 0) : x(x), y(y), z(z) {}
	friend Vec3d operator +(const Vec3d& a, const Vec3d& b) {
		return Vec3d(a.x + b.x, a.y + b.y, a.z + b.z);
	}
	friend Vec3d operator -(const Vec3d& a, const Vec3d& b) {
		return Vec3d(a.x - b.x, a.y - b.y, a.z - b.z);
	}
	friend Vec3d operator -(const Vec3d& a) {
		return Vec3d(-a.x, -a.y, -a.z);
	}
	Vec3d& operator +=(const Vec3d& b) {
		x += b.x; y += b.y; z += b.z;
		return *this;
	}
	Vec3d& operator *=(double s) {
		x *= s; y *= s; z *= s;
		return *this;
	}
	void times(double s)
	{
		x*=s;
		y*=s;
		z*=s;
	}
	Vec3d& operator -=(const Vec3d& b) {
		x -= b.x; y-= b.y; z-= b.z;
		return *this;
	}
	void minus(const Vec3d& b)
	{
		x-=b.x;
		y-=b.y;
		z-=b.z;
	}

	// compute scalar * vector and return the vector
	friend Vec3d operator *(double s, Vec3d v) {
		return Vec3d(s * v.x, s * v.y, s * v.z);
	}

	// compute vector * scalar and return the vector
	friend Vec3d operator *(Vec3d v, double s) {
		return Vec3d(v.x * s, v.y * s, v.z * s);
	}
	
	friend double dot(const Vec3d& a, const Vec3d& b) {
		return a.x*b.x + a.y*b.y + a.z*b.z;
	}
	
	void set(double x, double y, double z)
	{
		this->x=x;
		this->y=y;
		this->z=z;
	}

	void set(Vec3d v)
	{
		this->x=v.x;
		this->y=v.y;
		this->z=v.z;
	} 	

	// r0 points to the object d0 should return the answer
	double mag() const {
		return sqrt(x*x + y*y + z*z);
	}
	//hint: if you could write magsq() you would not have to square the magnitude

	double mag2() const {
		return (x*x + y*y + z*z);
	}	
	
	friend std::ostream& operator <<(std::ostream& s, const Vec3d& v) {
		return s << v.x << ',' << v.y << ',' << v.z;
	}
};

class Body {
private:
	char name[16];
	double m; // mass of the body
	/*
		Hint: G is constant, m is not. the compiler can't precompute Gm because
		Gm is different for every body. But you could just precompute it when 
		Body is created.
	*/
	double Gm;
	Vec3d pos;
	Vec3d v;
	Vec3d a;
	friend class GravSim;
public:
	//Hint: This is the constructor for Body. instead of just initializing m
	// precompute Gm
	Body(const char name[16],
			 const char orbits[16],
			 double m,
			 double x, double y, double z,
			 double vx, double vy, double vz) : m(m), Gm(G*m), pos(x,y,z), v(vx, vy, vz), a() {
		strncpy(this->name, name, 16);
	}
	friend std::ostream& operator <<(std::ostream& s, const Body& b) {
		return s << b.name << '\t' << b.pos << '\t' << b.v << '\t' << b.a;
	}
	void gravAccel(Vec3d* accel, Body& b) {
		accel->set(pos);
		accel->minus(b.pos);
											//accel is now dpos
		double r2 = accel->mag2();
		double r = sqrt(r2);
		double amagOverR = b.Gm/(r2*r);
		accel->times(amagOverR);			//accel is now accel
		//cout << "\t\t\t\t\t\t\t\t" <<  *accel << endl;
	}
};

class GravSim {
public:
private:
	double t;
	std::vector<Body> bodies;
public:
	GravSim(const char filename[]);
	void timestep(double dt);
	void forward(uint32_t n, double dt);
	friend std::ostream& operator <<(std::ostream& s, const GravSim& sim);
};
