#include"classes.h"

/*
int main(void) {
	int Height = 40;
	int Width = 80;
	_COORD coord;
	coord.Y = Height;
	coord.X = Width;
	figure f(20, 20);
	figure rect1(0, 0);
	figure rect2(10, 0);
	figure rect3(5, 5);
	while (f.getX() < Width && f.getX() > 0) {
		if (GetAsyncKeyState(VK_RIGHT)) {
			f.moveTo(f.getX() + 1, f.getY());
		}
		if (GetAsyncKeyState(VK_LEFT)) {
			f.moveTo(f.getX() - 1, f.getY());
		}
		Sleep(5);
	}
}
*/

int main(void) {
	pane p;
	figure rect(0, 0);
	figure rect2(0, 2);
	figure platf(20, 20);
	figure platf2(20, 21);
	p.add(rect);
	p.add(rect2);
	p.add(platf);
	p.add(platf2);
	p.refresh();
	return 0;
}