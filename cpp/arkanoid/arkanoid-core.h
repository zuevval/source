#ifndef H_CORE_ARCANOID
#define H_CORE_ARKANOID
#include<vector>
#include<string>
#include<iostream>
#include<conio.h>
#include <windows.h>
//#include <chrono>
#include <time.h>
#include<map>
#include<set>
#include<memory>
using namespace std;

void gotoxy(int x, int y);

enum onBump {
	stay,
	crush,
	jump,
};

class figure {
	double x, y, vx, vy;
	const int height = 2;
	const int width = 2;
	const string imageFilename = "icons/figure.txt";
	vector<string> image;
	onBump actionOnBump = jump;
protected:
	void draw();
	void jumpTo(double X, double Y);
public:
	void move();
	void erase();
	void setSpeed(double Vx, double Vy) { 
		vx = Vx;
		vy = Vy; 
	};
	double getVx() { return vx; };
	double getVy() { return vy; };
	int getXint() { return (int)x; };
	int getYint() { return (int)y; };
	int getHeight() { return height; };
	int getWidth() { return width; };
	figure(double X, double Y);
	onBump getOnBump() { return actionOnBump; };
};

constexpr int windowHeight = 40;
constexpr int windowWidth = 40;

class pane {
	const int width = windowWidth, height = windowHeight;
	int figuresNum = 0;

	map <int, shared_ptr<figure>> figures;
	vector<vector<set<int>>> figuresMap;
	bool findFigure(int figureID);
	void destroy(int figureID);
	void moveFigure(int figID);
	vector<int> intersects(int figID);
	//TODO:  implement moveFigure with re-drawing & changing position in figuresMap
	void bump(pair<int, int> figuresIDs) {}; //TODO: implement
public:
	void makeMoving(int figureID, double vx, double vy);
	void stop(int figureID);
	void refresh();
	int add(shared_ptr<figure> & f);
	pane();
};

#endif