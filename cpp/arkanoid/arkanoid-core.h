#ifndef H_CORE_ARCANOID
#define H_CORE_ARKANOID
#include<vector>
#include<string>
#include<iostream>
#include<conio.h>
#include <windows.h>
#pragma comment(lib, "Winmm.lib")
//#include <chrono>
#include <time.h>
#include<map>
#include<set>
#include<memory>
#include<cassert>
using namespace std;

typedef bool gameoverFlag;

void gotoxy(int x, int y);

enum onBump {
	stay,
	crush,
	jump,
};

class figure {
	double x, y, vx, vy;
	vector<string> image;
protected:
	onBump actionOnBump = jump;
	int height = 2;
	int width = 2;
	string imageFilename = "icons/figure.txt";
	virtual void draw();
	void jumpTo(double X, double Y);
	void spawn(double X, double Y);
public:
	void move();
	virtual int erase();
	virtual void refresh() { if (vx != 0 || vy != 0) move(); };
	void setSpeed(double Vx, double Vy) { vx = Vx; vy = Vy; };
	void jumpBack(shared_ptr<figure> & f);
	double getVx() { return vx; };
	double getVy() { return vy; };
	int getXint() { return (int)x; };
	int getYint() { return (int)y; };
	int getHeight() { return height; };
	int getWidth() { return width; };
	figure() {};
	figure(double X, double Y) { spawn(X, Y); };
	onBump getOnBump() { return actionOnBump; };
};

constexpr int windowHeight = 24;
constexpr int windowWidth = 80;

class pane {
	const int width = windowWidth, height = windowHeight;
	vector<vector<set<int>>> figuresMap;
	bool findFigure(int figureID);
	int destroy(int figureID);
	void eraseOnMap(int figureID);
	void placeOnMap(int figureID);
	void refreshFigure(int figID);
	set<int> intersects(int figID);
	int bump(pair<int, int> figuresIDs);
protected:
	int score = 0;
	int figuresNum = 0;
	map <int, shared_ptr<figure>> figures;
	bool mapFreeAt(int x, int y, int w, int h);
public:
	void makeMoving(int figureID, double vx, double vy);
	void stop(int figureID);
	virtual gameoverFlag refresh();
	int add(shared_ptr<figure> & f);
	pane();
};

#endif