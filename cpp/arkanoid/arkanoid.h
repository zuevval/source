#ifndef H_ARKANOID_GAME
#define H_ARKANOID_GAME
#include"arkanoid-core.h"

class gamePane :public pane {
	int platformID;
public:
	gamePane();
	void onleftkeyup() { stop(platformID); };
	void onleftkeydown() { makeMoving(platformID, -0.25, 0); };
	void onrightkeyup() { stop(platformID); };
	void onrightkeydown() { makeMoving(platformID, 0.25, 0); };
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

#endif