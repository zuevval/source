#include"arkanoid.h"

int gamePane::damage(int figureID) {
	int x, y;
	auto bonus = figures.at(figureID)->getBonus();
	switch (bonus) {
	case drops:
		x = figures.at(figureID)->getXint();
		y = figures.at(figureID)->getYint() + figures.at(figureID)->getHeight();
		dropBonus(x, y);
		break;
	case bigPlatf:
		switchPlatform(true); //switch to big
		break;
	case giantBall:
		switchBall(true);
		break;
	case boostPlatf:
		if(bonusTimeCounters.find(boostPlatf) == bonusTimeCounters.end()) //if bonus is not on already
			platformVx *= consts::boostPlatfMultiple; //boost platform
		break;
	case trampolineOn:
		if (trampolineID == -1) {
			shared_ptr<figure> tr = make_shared<trampoline>(trampoline());
			trampolineID = add(tr);
		}
		break;
	case oneLife:
		lives++;
		StatusBar->setScore(score, lives);
		break;
	case boostBall:
		if (bonusTimeCounters.find(boostBall) == bonusTimeCounters.end()) {//if bonus is not on already
			double vx = figures.at(ballID)->getVx();
			double vy = figures.at(ballID)->getVy();
			vx *= consts::boostBallMultiple;
			vy *= consts::boostBallMultiple;
			figures.at(ballID)->setSpeed(vx, vy); //boost ball
		}
		break;
	}
	if (bonus != drops && bonus != none) {
		if (bonusTimeCounters.find(bonus) == bonusTimeCounters.end())
			bonusTimeCounters.insert(make_pair(bonus, 0));
		else
			bonusTimeCounters.at(bonus) = 0; //reset bonus time
	}
	return pane::damage(figureID);
}

void gamePane::bump(pair<int, int> f) {
	if (figures.find(f.first) == figures.end()) return;
	if (figures.find(f.second) == figures.end()) return;
	onBump actFirst = figures.at(f.first)->getOnBump();
	onBump actSecond = figures.at(f.second)->getOnBump();
	if (actFirst == asTrampoline || actSecond == asTrampoline) {
		bool trampolineFirst = (actFirst == asTrampoline);
		if (f.first != ballID && f.second != ballID) {
			//redrawing trampoline possibly affected by figure
			if (trampolineFirst) figures.at(f.first)->refresh();
			else figures.at(f.second)->refresh();
			return;
		}
		else {
			if (trampolineFirst) figures.at(f.first)->setOnBump(stay);
			else figures.at(f.second)->setOnBump(stay);
			pane::bump(f);
			if (trampolineFirst) figuresToDamage.insert(f.first);
			else figuresToDamage.insert(f.second);
			trampolineID = -1;
		}
	}
	else pane::bump(f);
}

void gamePane::dropBonus(int x, int y) {
	shared_ptr<figure> t = make_shared<token>(token(x, y));
	makeMoving(add(t), 0, consts::tokenVelocity);
}

void gamePane::switchPlatform(bool toBig) {
	int x = figures.at(platformID)->getXint();
	int y = figures.at(platformID)->getYint();
	double vx = figures.at(platformID)->getVx();
	damage(platformID); //destroy
	shared_ptr<figure> mainPlatform;
	if (toBig) //bonus on
		mainPlatform = make_shared<bigPlatform>(bigPlatform(x - dim::bigToSmallPlatfXshift, y));
	else
		mainPlatform = make_shared<platform>(platform(x + dim::bigToSmallPlatfXshift, y));
	platformID = add(mainPlatform);
	makeMoving(platformID, vx, 0);

}

void gamePane::switchBall(bool toBig) {
	if (figures.find(ballID) == figures.end()) return;
	int x = figures.at(ballID)->getXint();
	int y = figures.at(ballID)->getYint();
	double vx = figures.at(ballID)->getVx();
	double vy = figures.at(ballID)->getVy();
	damage(ballID); //destroy
	shared_ptr<figure> mainBall;
	if (toBig) //bonus on
		mainBall = make_shared<bigBall>(bigBall(x, y));
	else
		mainBall = make_shared<ball>(ball(x, y));
	ballID = add(mainBall);
	makeMoving(ballID, vx, vy);
}

gameoverFlag gamePane::refresh() {
	pane::refresh();
	StatusBar->setScore(score, lives);

	//refreshing bonuses
	vector<_bonusType> bonusesToFinish;
	for (pair<_bonusType, int> bonus : bonusTimeCounters) {
		bonusTimeCounters.at(bonus.first)++;
		if (bonus.second > consts::bonusDuration) 
			bonusesToFinish.push_back(bonus.first);
	}
	for (_bonusType b : bonusesToFinish) {
		bonusTimeCounters.erase(b);
		switch (b) {
		case bigPlatf:
			switchPlatform(false); //switch to small
			break;
		case giantBall:
			switchBall(false);
			break;
		case boostPlatf:
			platformVx /= consts::boostPlatfMultiple; //slow down platform
			break;
		case boostBall:
				double vx = figures.at(ballID)->getVx();
				double vy = figures.at(ballID)->getVy();
				vx /= consts::boostBallMultiple;
				vy /= consts::boostBallMultiple;
				figures.at(ballID)->setSpeed(vx, vy); //slow down ball
			break;
		}
	}

	//new bonus blocks spawning
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

	//checking whether main ball is present and active
	bool ballActive = figures.find(ballID) != figures.end();
	if (ballActive) ballActive &= (figures.at(ballID)->getVx() != 0 || figures.at(ballID)->getVy() != 0);
	if (!ballActive) {
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
		shared_ptr<figure> InitBlock = make_shared<semiSolidBlock>(semiSolidBlock(x, dim::blockLowerLayerY));
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

	shared_ptr<figure> fblock = make_shared<flyingBlock>(flyingBlock(dim::gameAreaWidth/3, dim::flyingBlockLayerY));
	shared_ptr<figure> fblock2 = make_shared<flyingBlock>(flyingBlock(2*dim::gameAreaWidth/3, dim::flyingBlockLayerY));
	add(fblock);
	add(fblock2);
	//-----------------------------------
	/*for (int i = 1; i < 6; i++) {
		shared_ptr<figure> ball2 = make_shared<ball>(ball(20 + i, 15 + i));
		int ball2ID = add(ball2);
		makeMoving(ball2ID, consts::ballVxInit, consts::ballVyInit);
	}*/
	//-----------------------------------
}

