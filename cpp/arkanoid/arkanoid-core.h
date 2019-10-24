#ifndef H_CORE_ARCANOID
#define H_CORE_ARKANOID
#include<vector>
#include<string>
#include<iostream>
#include<conio.h>
#include <windows.h>
#pragma comment(lib, "Winmm.lib")
#include <time.h>
#include<map>
#include<set>
#include<memory>
#include<cassert>
#include"constant-dimensions.h"
using namespace std;

typedef bool gameoverFlag;

void gotoxy(int x, int y);

enum onBump {
	stay,
	crush,
	jump,
	crushButReflect,
	loseFirmness,
	asTrampoline,
};

enum _bonusType {
	none,
	drops,
	bigPlatf,
	giantBall,
	boostPlatf,
	boostBall,
	trampolineOn,
	secondBall,
	oneLife,
};

class figure {
	double x, y, vx, vy;
	vector<string> image;
protected:
	int innerPoints = 0;
	_bonusType innerBonus = none;
	onBump actionOnBump = jump;
	int height = dim::blockHeight;
	int width = dim::blockWidth;
	string imageFilename = "icons/figure.txt";
	virtual void draw();
	void jumpTo(double X, double Y);
	void spawn(double X, double Y);
public:
	_bonusType getBonus() { return innerBonus; }
	void move();
	virtual int erase();
	virtual void refresh() { if (vx != 0 || vy != 0) move(); else draw(); };
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
	virtual void setOnBump(onBump newOnBump) { actionOnBump = newOnBump; };
};

const int windowHeight = dim::windowHeight;
const int windowWidth = dim::windowWidth;

class pane {
	const int width = windowWidth, height = windowHeight;
	vector<vector<set<int>>> figuresMap;
	bool findFigure(int figureID);
	void eraseOnMap(int figureID);
	void placeOnMap(int figureID);
	void refreshFigure(int figID);
	set<int> intersects(int figID);
protected:
	set<int> figuresToDamage;
	virtual void bump(pair<int, int> figuresIDs);
	virtual int damage(int figureID);
	int lives = consts::defaultLives;
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