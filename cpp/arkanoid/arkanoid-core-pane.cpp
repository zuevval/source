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
	figures.at(figID)->move();
	//TODO:
	//draws figure in a new place
	//if the place is different from old, changes figuresMap
	//checks wheter the figure intersects something, and, if yes, bumps it into that ones
}

vector<int> pane::intersects(int figID) {
	/**@return IDs of figures intersecting with figID*/
	vector<int> res;
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
				if (otherFigID != figID) res.push_back(otherFigID);
			}
		}
	}
	return res;
}

void pane::refresh() {
	//gotoxy(0, height/2);
	for (auto & fStruct : figures) {
		if (fStruct.second->getVx() != 0 || fStruct.second->getVy() != 0) {
			int fID = fStruct.first;
			moveFigure(fID);
		}
		vector<int> intersectingFigures = intersects(fStruct.first);
		//cout << "figID: "<< fStruct.first << endl;
		//for (int figID : intersectingFigures) cout << figID << endl;
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