#include"arkanoid.h"

wall::wall(double X, double Y) {
	actionOnBump = stay;
	height = dim::wallHeight;
	width = dim::wallWidth;
	imageFilename = "icons/wall.txt";
	spawn(X, Y);
}

ceiling::ceiling(double X, double Y) {
	actionOnBump = stay;
	height = dim::ceilingHeight;
	width = dim::ceilingWidth;
	imageFilename = "icons/ceiling.txt";
	spawn(X, Y);
}

platform::platform(double X, double Y) {
	height = dim::platformHeight;
	width = dim::platformWidth;
	imageFilename = "icons/platform.txt";
	spawn(X, Y);
}

ball::ball(double X, double Y) {
	height = dim::ballHeight;
	width = dim::ballWidth;
	imageFilename = "icons/ball.txt";
	spawn(X, Y);
}

bigBall::bigBall(double X, double Y) {
	height = dim::bigBallHeight;
	width = dim::bigBallWidth;
	imageFilename = "icons/bigBall.txt";
	spawn(X, Y);
}

token::token(double X, double Y) {
	actionOnBump = crush;
	innerPoints = 0;
	int bonusNo = rand() % 6;
	switch (bonusNo) {
	case 0: innerBonus = bigPlatf; break;
	case 1: innerBonus = giantBall; break;
	case 2: innerBonus = boostPlatf; break;
	case 3: innerBonus = trampolineOn; break;
	case 4: innerBonus = oneLife; break;
	case 5: innerBonus = boostBall; break;
	}
	height = dim::tokenHeight;
	width = dim::tokenWidth;
	imageFilename = "icons/token.txt";
	spawn(X, Y);
}

block::block(double X, double Y) {
	innerPoints = consts::standardReward;
	actionOnBump = crushButReflect;
	spawn(X, Y);
}

void block::draw() {
	HANDLE console = GetStdHandle(STD_OUTPUT_HANDLE);
	int color = consts::blockColors[rand() % size(consts::blockColors)];
	SetConsoleTextAttribute(console, color);
	figure::draw();
	SetConsoleTextAttribute(console, consts::defaultColormap);
}

solidBlock::solidBlock(double X, double Y) {
	imageFilename = "icons/solidBlock.txt";
	actionOnBump = stay;
	spawn(X, Y);
}

semiSolidBlock::semiSolidBlock(double X, double Y) {
	imageFilename = "icons/semiSolid1.txt";
	actionOnBump = loseFirmness;
	innerPoints = 2 * consts::standardReward;
	spawn(X, Y);
}
void semiSolidBlock::setOnBump(onBump newOnBump) {
	figure::setOnBump(newOnBump);
	imageFilename = "icons/semiSolidAfterHit.txt";
	spawn(getXint(), getYint());

}

flyingBlock::flyingBlock(double X, double Y) {
	imageFilename = "icons/flyingBlock.txt";
	innerTimeCounter = 0;
	innerPoints = consts::flyingBlockRewardMultiple*consts::standardReward;
	actionOnBump = crushButReflect;
	spawn(X, Y);
	setSpeed(consts::flyingBlockVx, 0);
}
void flyingBlock::refresh() {
	innerTimeCounter++;
	if (innerTimeCounter > consts::flyingBlockRevertPeriod) {
		innerTimeCounter = 0;
		setSpeed(-getVx(), -getVy());
	}
	figure::refresh();
}

bonusBlock::bonusBlock(double X, double Y) {
	innerBonus = drops;
	imageFilename = "icons/bonusBlock.txt";
	actionOnBump = crushButReflect;
	spawn(X, Y);
}

void statBar::draw() {
	gotoxy(getXint(), getYint());
	cout << "lives: " << lives;
	cout << "Score: " << score;
}

statBar::statBar(double X, double Y) {
	height = dim::statBarHeight;
	width = dim::statBarWidth;
	score = 0;
	setSpeed(0, 0);
	jumpTo(X, Y);
	draw();
}

bigPlatform::bigPlatform(double X, double Y) {
	height = dim::platformHeight;
	width = dim::bigPlatformWidth;
	imageFilename = "icons/bigPlatform.txt";
	spawn(X, Y);
}

trampoline::trampoline() {
	height = dim::trampolineHeight;
	width = dim::trampolineWidth;
	imageFilename = "icons/trampoline.txt";
	setOnBump(asTrampoline);
	spawn();
}
