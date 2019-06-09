#ifndef H_ARKANOID_GAME
#define H_ARKANOID_GAME
#include"arkanoid-core.h"

class statBar :public figure {
	int score;
	void refresh() { draw(); };
protected:
	void draw();
public:
	int getScore() { return score; };
	void setScore(int points) { score = points; refresh(); };
	statBar(double X, double Y);
};

class gamePane :public pane {
	unsigned int timeCounter;
	int platformID;
	int ballID;
	shared_ptr<statBar> StatusBar;
public:
	gameoverFlag refresh();
	gamePane();
	void onleftkeyup() { stop(platformID); };
	void onleftkeydown() { makeMoving(platformID, -0.25, 0); };
	void onrightkeyup() { stop(platformID); };
	void onrightkeydown() { makeMoving(platformID, 0.25, 0); };
};

class wall :public figure {
public:
	wall(double X, double Y);
};

class ceiling :public figure {
public:
	ceiling(double X, double Y);
};

class platform :public figure {
public:
	platform(double X, double Y);
};

class ball :public figure {
public:
	ball(double X, double Y);
};

class block :public figure {
	int innerPoints = 10;
public:
	block(double X, double Y);
	int erase();
};
#endif