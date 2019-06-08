#include"classes.h"

void pane::add(figure & f) {
	int figID = ++figuresNum;
	figures.insert(make_pair(figID, f));
	int x = f.getXint();
	int y = f.getYint();
	if (x >= height || y >= width || min(x, y) < 0) throw ERROR; //TODO: throw more specific exception & handle it
	int maxX = min(x + f.getWidth(), width);
	int maxY = min(y + f.getHeight(), height);
	for (int i = x; i < maxX; i++) {
		for (int j = y; j < maxY; j++) figuresMap[i][j].insert(figID);
	}
}

void pane::makeMoving(int figureID, velocity v) {
	movingFigures[figureID] = v;
}
void pane::stop(int figureID) {
	auto findFig = movingFigures.find(figureID);
	if (findFig != movingFigures.end()) movingFigures.erase(findFig);
}

void pane::moveFigure(int figID, velocity v) {
	//draws figure in a new place
	//if the place is different from old, changes figuresMap
	//checks wheter the figure intersects something, and, if yes, bumps it into that ones
}

vector<int> pane::intersects(int figID) {
	/**@return IDs of figures intersecting with figID*/
	vector<int> res;
	auto findFig = figures.find(figID);
	if (findFig == figures.end()) return res;
	figure f = figures.at(figID);
	int x = f.getXint();
	int y = f.getYint();
	int maxX = min(x + f.getWidth(), width);
	int maxY = min(y + f.getHeight(), height);
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
	for (auto & mvf : movingFigures) {
		int mvfID = mvf.first;
		velocity v = mvf.second;
		moveFigure(mvfID, v);
	}
	gotoxy(0, height/2);
	for (auto & fStruct : figures) {
		vector<int> intersectingFigures = intersects(fStruct.first);
		cout << "figID: "<< fStruct.first << endl;
		for (int figID : intersectingFigures) cout << figID << endl;
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