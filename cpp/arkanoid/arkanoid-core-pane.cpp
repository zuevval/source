#include"arkanoid-core.h"

int pane::add(shared_ptr<figure> & f) {
	int figID = ++figuresNum;
	figures.insert(make_pair(figID, f));
	int x = f->getXint();
	int y = f->getYint();
	if (x >= height || y >= width || min(x, y) < 0) throw ERROR; //TODO: throw more specific exception & handle it
	int maxX = min(x + f->getWidth(), width);
	int maxY = min(y + f->getHeight(), height);
	for (int i = x; i < maxX; i++) {
		for (int j = y; j < maxY; j++) figuresMap[i][j].insert(figID);
	}
	return figID;
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

void pane::destroy(int figureID) {
	if (!findFigure(figureID)) return;
	figures.at(figureID)->erase();
}

void pane::moveFigure(int figID) {
	//draws figure in a new place
	//if the place is different from old, changes figuresMap
	//checks wheter the figure intersects others, and, if yes, bumps
	int xOld = figures.at(figID)->getXint();
	int yOld = figures.at(figID)->getYint();
	figures.at(figID)->move();
	if (xOld != figures.at(figID)->getXint() || yOld != figures.at(figID)->getYint()) {
		set<int> intersectingIDs = intersects(figID);
		for (int id : intersectingIDs) {
			bump(make_pair(figID, id));
		}
	}
}

void pane::bump(pair<int, int> f) {
	if (figures.find(f.first) == figures.end()) return;
	if (figures.find(f.second) == figures.end()) return;
	onBump actFirst = figures.at(f.first)->getOnBump();
	onBump actSecond = figures.at(f.second)->getOnBump();
	if (actFirst == crush || actSecond == crush) {
		if (actFirst == crush) destroy(f.first);
		if (actSecond == crush) destroy(f.second);
		return;
	}
	if(actFirst == jump)
		figures.at(f.first)->jumpBack(figures.at(f.second));
	if(actSecond == jump)
		figures.at(f.second)->jumpBack(figures.at(f.first));
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

void pane::refresh() {
	for (auto & fStruct : figures) {
		if (fStruct.second->getVx() != 0 || fStruct.second->getVy() != 0) {
			int fID = fStruct.first;
			moveFigure(fID);
		}
		set<int> intersectingFigures = intersects(fStruct.first);
	}
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