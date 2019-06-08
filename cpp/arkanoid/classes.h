#ifndef H_CLASSES_MY
#define H_CLASSES_MY
#include<vector>
#include<string>
#include<iostream>
#include<conio.h>
#include <windows.h>
//#include <chrono>
#include <time.h>
#include<set>
#include<map>
using namespace std;

void gotoxy(int x, int y);

enum onBump {
	stay,
	crush,
	jump
};

class figure {
	double x, y;
	const int height = 2;
	const int width = 2;
	const string imageFilename = "icons/figure.txt";
	vector<string> image;
	onBump actionOnBump = jump;
protected:
	void draw();
	void erase();
public:
	void moveTo(double X, double Y);
	double getX() { return x; };
	double getY() { return y; };
	int getXint() { return (int)x; };
	int getYint() { return (int)y; };
	int getHeight() { return height; };
	int getWidth() { return width; };
	figure(double X, double Y);
	bool intersects(figure & f) { return false; }; //TODO: implement
	onBump getOnBump() { return actionOnBump; };
};

class ball :public figure {

};

class statBar {
	int score;
	int x, y, width;
public:
	int getScore() { return score; };
	void addScore(int points) { score += points; /*draw(); */ };
};

constexpr int windowHeight = 40;
constexpr int windowWidth = 40;
typedef pair<int, int> velocity;

class pane {
	statBar sb;
	const int width = windowWidth, height = windowHeight;
	vector<vector<set<int>>> figuresMap;
	int figuresNum = 0;
	map <int, figure> figures;
	map <int, velocity> movingFigures;

	void makeMoving(int figureID, velocity v);
	void stop(int figureID);
	void moveFigure(int figID, velocity v);
	vector<int> intersects(int figID);
	//TODO:  implement moveFigure with re-drawing & changing position in figuresMap
	//TODO: implement makeMoving, stop(figID), destroy(figID)
	void bump(pair<int, int> figuresIDs) {}; //TODO: implement
public:
	void refresh();
	void add(figure & f);
	pane();
	/* //TODO: implement
	void onleftkeydown();
	void onleftkeyup();
	void onrightkeydown();
	void onrightkeyup();
	*/
};

#endif