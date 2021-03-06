#include"arkanoid-core.h"

bool pane::mapFreeAt(int x, int y, int w, int h) {
	if (x + w >= windowWidth || y + h >= windowHeight || min(x, y) < 0) return false;
	bool res = true;
	for (int i = x; i < x+w; i++) {
		for (int j = y; j < y+h; j++) res &= (figuresMap[i][j].size() == 0);
	}
	return res;
};

int pane::add(shared_ptr<figure> & f) {
	int figID = ++figuresNum;
	figures.insert(make_pair(figID, f));
	placeOnMap(figID);
	return figID;
}

//TODO: unite two functions below (templates? pointers to functions?)
void pane::placeOnMap(int figID) {
	if (figures.find(figID) == figures.end()) return;
	int x = figures.at(figID)->getXint();
	int y = figures.at(figID)->getYint();
	if (x >= width || y >= height || min(x, y) < 0) throw ERROR; //TODO: throw more specific exception & handle it
	int maxX = min(x + figures.at(figID)->getWidth(), width);
	int maxY = min(y + figures.at(figID)->getHeight(), height);
	for (int i = x; i < maxX; i++) {
		for (int j = y; j < maxY; j++) figuresMap[i][j].insert(figID);
	}
}

void pane::eraseOnMap(int figID) {
	if (figures.find(figID) == figures.end()) return;
	int x = figures.at(figID)->getXint();
	int y = figures.at(figID)->getYint();
	if (x >= width || y >= height || min(x, y) < 0) throw ERROR; //TODO: throw more specific exception & handle it
	int maxX = min(x + figures.at(figID)->getWidth(), width);
	int maxY = min(y + figures.at(figID)->getHeight(), height);
	for (int i = x; i < maxX; i++) {
		for (int j = y; j < maxY; j++) figuresMap[i][j].erase(figID);
	}
}

bool pane::findFigure(int figureID) {
	auto findFig = figures.find(figureID);
	return (findFig != figures.end());
}

void pane::makeMoving(int figureID, double vx, double vy) {
	if (!findFigure(figureID)) return;
	figures.at(figureID)->setSpeed(vx, vy);
}
void pane::stop(int figureID) {
	if (!findFigure(figureID)) return;
	figures.at(figureID)->setSpeed(0,0);
}

int pane::damage(int figureID) {
	if (!findFigure(figureID)) return 0;
	if (figures.at(figureID)->getOnBump() == loseFirmness) {
		figures.at(figureID)->setOnBump(crushButReflect);
		return 0; //no points from this hit
	}
	eraseOnMap(figureID);
	int points = figures.at(figureID)->erase();
	figures.erase(figureID);
	return points;
}

void pane::refreshFigure(int figID) {
	//draws figure in a new place
	//if the place is different from old, changes figuresMap
	//checks wheter the figure intersects others, and, if yes, bumps
	if (figures.at(figID)->getVx() == 0 && figures.at(figID)->getVy() == 0) return;
	int xOld = figures.at(figID)->getXint();
	int yOld = figures.at(figID)->getYint();
	eraseOnMap(figID);
	figures.at(figID)->refresh();
	int maxHeight = dim::maxY;
	int figProjecting = figures.at(figID)->getYint() + figures.at(figID)->getHeight();
	if (figProjecting <= maxHeight) {
		placeOnMap(figID);
		int xNew = figures.at(figID)->getXint();
		int yNew = figures.at(figID)->getYint();
		if (xOld != xNew || yOld != yNew) {
			set<int> intersectingIDs = intersects(figID);
			for (int id : intersectingIDs) bump(make_pair(figID, id));
		}
	}
	else figuresToDamage.insert(figID);
}

void pane::bump(pair<int, int> f) {
	if (figures.find(f.first) == figures.end()) return;
	if (figures.find(f.second) == figures.end()) return;
	onBump actFirst = figures.at(f.first)->getOnBump();
	onBump actSecond = figures.at(f.second)->getOnBump();
	if (actFirst == jump && actSecond != crush) {
		eraseOnMap(f.first);
		figures.at(f.first)->jumpBack(figures.at(f.second));
		placeOnMap(f.first);
	}
	if (actSecond == jump && actFirst != crush) {
		eraseOnMap(f.second);
		figures.at(f.second)->jumpBack(figures.at(f.first));
		placeOnMap(f.second);
	}
	if (actFirst == crush || actSecond == crush
		||actFirst == crushButReflect || actSecond == crushButReflect) {
		if (actFirst == crush || actFirst == crushButReflect) figuresToDamage.insert(f.first);
		if (actSecond == crush || actSecond == crushButReflect) figuresToDamage.insert(f.second);
	}
	if (actFirst == loseFirmness) damage(f.first);
	if (actSecond == loseFirmness) damage(f.second);
};

set<int> pane::intersects(int figID) {
	/**@return IDs of figures intersecting with figID*/
	set<int> res;
	auto findFig = figures.find(figID);
	if (findFig == figures.end()) return res;
	shared_ptr<figure> f = figures.at(figID);
	int x = f->getXint();
	int y = f->getYint();
	int maxX = min(x + f->getWidth(), width);
	int maxY = min(y + f->getHeight(), height);
	for (int i = x; i < maxX; i++) {
		for (int j = y; j < maxY; j++) {
			for (int otherFigID : figuresMap[i][j]) {
				res.emplace(otherFigID);
			}
		}
	}
	res.erase(figID);
	return res;
}

gameoverFlag pane::refresh() {
	for (auto & fStruct : figures) refreshFigure(fStruct.first);
	for (int fID : figuresToDamage) {
		score += damage(fID);
	}
	figuresToDamage.clear();
	return false;
}

pane::pane() { 
	/*  ---> x (first index)
	*   |
	*   |
	*   y
	*/
	figuresMap.resize(width);
	for (auto & col : figuresMap) col.resize(height);
}