#ifndef H_ARKANOID_GAME
#define H_ARKANOID_GAME
#include"arkanoid-core.h"
#include"constant-dimensions.h"

class statBar :public figure {
	int lives = consts::defaultLives;
	int score;
	void refresh() { draw(); };
protected:
	void draw();
public:
	void setScore(int points, int lvs) { score = points; lives = lvs; refresh(); };
	statBar(double X, double Y);
};

class gamePane :public pane {
	unsigned int timeCounter;
	int platformID;
	int ballID;
	shared_ptr<statBar> StatusBar;
protected:
	int bonusTimer = 0;
	bool bonusSet = false;
	void refreshBonusState();
	virtual int destroy(int figureID) override;
	void dropBonus(int x, int y);
public:
	gameoverFlag refresh();
	gamePane();
	void onleftkeyup() { stop(platformID); };
	void onleftkeydown() { makeMoving(platformID, -consts::platformVelocity, 0); };
	void onrightkeyup() { stop(platformID); };
	void onrightkeydown() { makeMoving(platformID, consts::platformVelocity, 0); };
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
	void jumpBack();
	platform(double X, double Y);
	platform() {};
};

class ball :public figure {
public:
	ball(double X, double Y);
};

class token :public figure {
public:
	token(double X, double Y);
};

class block :public figure {
protected:
	void draw();
public:
	block(double X, double Y);
	block() {};
};

class solidBlock :public block {
public:
	solidBlock(double X, double Y);
};

class bonusBlock :public block {
public:
	bonusBlock(double X, double Y);
};

class bigPlatform:public platform {
public:
	bigPlatform(double X, double Y);
};
#endif