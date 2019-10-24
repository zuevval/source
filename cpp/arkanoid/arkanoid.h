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
	double platformVx = consts::platformVelocity;
	int ballID;
	int trampolineID = -1;
	shared_ptr<statBar> StatusBar;
	map<_bonusType, int> bonusTimeCounters;

	void switchPlatform(bool toBig); 
	void switchBall(bool toBig);
protected:
	virtual int damage(int figureID);
	void bump(pair<int, int> figuresIDs);
	void dropBonus(int x, int y);
public:
	gameoverFlag refresh();
	gamePane();
	void onleftkeyup() { stop(platformID); };
	void onleftkeydown() { makeMoving(platformID, -platformVx, 0); };
	void onrightkeyup() { stop(platformID); };
	void onrightkeydown() { makeMoving(platformID, platformVx, 0); };
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
	platform() {};
};

class ball :public figure {
public:
	ball(double X, double Y);
};

class bigBall :public figure {
public:
	bigBall(double X, double Y);
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

class semiSolidBlock :public block {
public:
	semiSolidBlock(double X, double Y);
	void setOnBump(onBump newOnBump);
};

class flyingBlock :public block {
	int innerTimeCounter = 0;
public:
	flyingBlock(double X, double Y);
	void refresh();
};

class bonusBlock :public block {
public:
	bonusBlock(double X, double Y);
};

class bigPlatform:public platform {
public:
	bigPlatform(double X, double Y);
};

class trampoline :public figure {
public:
	trampoline();
	void spawn() { figure::spawn(dim::wallWidth, dim::trampolineYoffset); };
};
#endif