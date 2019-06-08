#ifndef H_ARKANOID_GAME
#define H_ARKANOID_GAME
#include"arkanoid-core.h"

class gamePane :public pane {
	int platformID;
public:
	gamePane() {
		shared_ptr<figure> block1 = make_shared<figure>(figure(0, 0));
		shared_ptr<figure> block2 = make_shared<figure>(figure(30, 0));
		shared_ptr<figure> block3 = make_shared<figure>(figure(15, 10));
		shared_ptr<figure> platform = make_shared<figure>(figure(20, 20));
		add(block1);
		add(block2);
		add(block3);
		platformID = add(platform);
	}
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