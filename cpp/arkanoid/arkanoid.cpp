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

token::token(double X, double Y) {
	actionOnBump = crush;
	innerPoints = 0;
	innerBonus = bigPlatf;
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

int gamePane::destroy(int figureID) {
	if (figures.at(figureID)->getYint() >= dim::platformYoffset + dim::platformHeight) {
		//if we are lower than the platform...
		pane::destroy(figureID);
		return 0; //no points added
	}
	int x, y;
	switch (figures.at(figureID)->getBonus()) {
	case drops:
		x = figures.at(figureID)->getXint();
		y = figures.at(figureID)->getYint() + figures.at(figureID)->getHeight();
		dropBonus(x, y);
		break;
	case bigPlatf:
		bonusSet = true;
		bonusTimer = 0;
		//TODO: make bonus
		break;
	}
	return pane::destroy(figureID);
}

void gamePane::dropBonus(int x, int y) {
	shared_ptr<figure> t = make_shared<token>(token(x, y));
	makeMoving(add(t), 0, consts::tokenVelocity);
}

void gamePane::refreshBonusState() {
	if (bonusTimer != 0 && bonusTimer < consts::bonusDuration) {
		bonusTimer++;
		return;
	}
	int x = figures.at(platformID)->getXint();
	int y = figures.at(platformID)->getYint();
	double vx = figures.at(platformID)->getVx();
	destroy(platformID);
	shared_ptr<figure> mainPlatform;
	if (bonusTimer == 0) { //bonus on
		mainPlatform = make_shared<bigPlatform>(bigPlatform(x, y));
	} else { //(bonusTimer > consts::bonusDuration)
		bonusSet = false;
		bonusTimer = 0;
		mainPlatform = make_shared<platform>(platform(x, y));
	}
	platformID = add(mainPlatform);
	makeMoving(platformID, vx, 0);
	bonusTimer++;
}

gameoverFlag gamePane::refresh() {
	pane::refresh();
	if (bonusSet) {
		refreshBonusState();
	}
	timeCounter++;
	if (timeCounter % consts::blockSpawnInterval == 0) {
		int x, y;
		x = rand() % (dim::gameAreaWidth - dim::blockWidth) + dim::wallWidth;
		y = dim::thirdLayerY;
		if (mapFreeAt(x, y, dim::blockWidth, dim::blockHeight)) {
			shared_ptr<figure> newBlock = make_shared<bonusBlock>(bonusBlock(x, y));
			add(newBlock);
		}
	};
	StatusBar->setScore(score, lives);
	if (figures.find(ballID) == figures.end()) {
		lives--;
		if (lives == 0) return true;
		shared_ptr<figure> mainBall = make_shared<ball>(ball(20, 15));
		ballID = add(mainBall);
		makeMoving(ballID, consts::ballVxInit, consts::ballVyInit);
	}
	return false;
}



gamePane::gamePane() {
	timeCounter = 0;
	
	shared_ptr<statBar> sb = make_shared<statBar>(statBar(dim::statBarXoffset, 0));
	shared_ptr<figure> leftWall = make_shared<wall>(wall(0, 0));
	shared_ptr<figure> rightWall = make_shared<wall>(wall(windowWidth - dim::wallWidth, 0));
	shared_ptr<figure> TopCeiling = make_shared<ceiling>(ceiling(dim::wallWidth, 0));
	shared_ptr<figure> mainPlatform = make_shared<platform>(platform(dim::gameAreaWidth / 2, dim::platformYoffset));
	
	for (int x = dim::wallWidth; x < dim::gameAreaWidth + dim::wallWidth; x += dim::blockWidth) {
		shared_ptr<figure> InitBlock = make_shared<block>(block(x, dim::blockUpperLayerY));
		add(InitBlock);
	}
	for(int i=0; i<dim::solidBlocksLeft; i++){
		int x = dim::wallWidth + i * dim::blockWidth;
		shared_ptr<figure> sblock = make_shared<solidBlock>(solidBlock(x, dim::blockLowerLayerY));
		add(sblock);
	}
	int startUsualBlocks = dim::solidBlocksLeft*dim::blockWidth + dim::wallWidth;
	int endUsualBlocks = dim::wallWidth + dim::gameAreaWidth - dim::solidBlocksRight*dim::blockWidth;
	for (int x = startUsualBlocks; x < endUsualBlocks; x+= dim::blockWidth) {
		shared_ptr<figure> InitBlock = make_shared<block>(block(x, dim::blockLowerLayerY));
		add(InitBlock);
	}
	for (int i = 0; i < dim::solidBlocksRight; i++) {
		int x = dim::wallWidth + dim::gameAreaWidth - (i + 1) * dim::blockWidth;
		shared_ptr<figure> sblock = make_shared<solidBlock>(solidBlock(x, dim::blockLowerLayerY));
		add(sblock);
	}
	
	add(leftWall);
	add(rightWall);
	add(TopCeiling);
	shared_ptr<figure> sbToFigure = (shared_ptr<figure>)sb;
	add(sbToFigure);
	shared_ptr<figure> mainBall = make_shared<ball>(ball(20, 15));
	ballID = add(mainBall);
	makeMoving(ballID, consts::ballVxInit, consts::ballVyInit);
	platformID = add(mainPlatform);
	StatusBar = sb;
}

