#ifndef H_ARKANOID_GAME
#define H_ARKANOID_GAME
#include"arkanoid-core.h"
typedef bool gameoverFlag;
class gamePane :public pane {
	int platformID;
	int ballID;
public:
	gameoverFlag refresh() {
		pane::refresh();
		auto ball = figures.at(ballID);
		return ball->getVx() == 0 && ball->getVy() == 0; //if ball stopped, gameover
	}
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

class statBar {
	int score;
	int x, y, width;
public:
	int getScore() { return score; };
	void addScore(int points) { score += points; /*draw(); */ };
};

#endif