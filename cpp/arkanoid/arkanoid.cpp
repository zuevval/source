#include"arkanoid.h"

wall::wall(double X, double Y) {
	actionOnBump = stay;
	height = 22;
	width = 2;
	imageFilename = "icons/wall.txt";
	spawn(X, Y);
}

ceiling::ceiling(double X, double Y) {
	actionOnBump = stay;
	height = 1;
	width = windowWidth - 4; //4 is 2*wallWidth
	imageFilename = "icons/ceiling.txt";
	spawn(X, Y);
}

platform::platform(double X, double Y) {
	height = 2;
	width = 6;
	imageFilename = "icons/platform.txt";
	spawn(X, Y);
}

ball::ball(double X, double Y) {
	height = 1;
	width = 1;
	imageFilename = "icons/ball.txt";
	spawn(X, Y);
}

block::block(double X, double Y) {
	actionOnBump = crush;
	spawn(X, Y);
}

int block::erase() {
	figure::erase();
	return innerPoints;
}

void statBar::draw() {
	gotoxy(getXint(), getYint());
	cout << "Score: " << score;
}

statBar::statBar(double X, double Y) {
	height = 1;
	width = 10;
	score = 0;
	setSpeed(0, 0);
	jumpTo(X, Y);
	draw();
}

gameoverFlag gamePane::refresh() {
	pane::refresh();
	timeCounter++;
	if (timeCounter % 100 == 0) {
		int x, y;
		srand(time(NULL));
		x = rand() % (windowWidth - 10);
		y = rand() % (windowHeight - 10);
		if (mapFreeAt(x, y, 2, 2)) { //2,2 - block dimensions
			shared_ptr<figure> newBlock = make_shared<block>(block(x, y));
			add(newBlock);
		}
	};
	StatusBar->setScore(score);
	auto ball = figures.at(ballID);
	return ball->getVx() == 0 && ball->getVy() == 0; //if ball stopped, gameover
}



gamePane::gamePane() {
	timeCounter = 0;
	shared_ptr<statBar> sb = make_shared<statBar>(statBar(windowWidth - 12, 0));
	shared_ptr<figure> block1 = make_shared<block>(block(5, 5));
	shared_ptr<figure> block2 = make_shared<block>(block(30, 5));
	shared_ptr<figure> block3 = make_shared<block>(block(15, 15));
	shared_ptr<figure> block4 = make_shared<block>(block(15, 19));
	shared_ptr<figure> leftWall = make_shared<wall>(wall(0, 0));
	shared_ptr<figure> rightWall = make_shared<wall>(wall(windowWidth - 2, 0));
	shared_ptr<figure> TopCeiling = make_shared<ceiling>(ceiling(2, 0));
	shared_ptr<figure> mainPlatform = make_shared<platform>(platform(19, 21));
	shared_ptr<figure> mainBall = make_shared<ball>(ball(20, 15));
	add(block1);
	add(block2);
	add(block3);
	add(block4);
	add(leftWall);
	add(rightWall);
	add(TopCeiling);
	shared_ptr<figure> sbToFigure = (shared_ptr<figure>)sb;
	add(sbToFigure);
	ballID = add(mainBall);
	makeMoving(ballID, 0.1, -0.1);
	platformID = add(mainPlatform);
	StatusBar = sb;
}

