//#include"arkanoid-core.h"
#include"arkanoid.h"

int main(void) {
	gamePane gp;
	bool rightKeyState = false;
	bool leftKeyState = false;
	while (!GetAsyncKeyState(VK_ESCAPE)) {
		if (GetAsyncKeyState(VK_RIGHT) && !rightKeyState) {
			rightKeyState = true;
			gp.onrightkeydown();
		}
		if (GetAsyncKeyState(VK_LEFT) && !leftKeyState) {
			leftKeyState = true;
			gp.onleftkeydown();
		} 
		if (!GetAsyncKeyState(VK_RIGHT) && rightKeyState) {
			rightKeyState = false;
			gp.onrightkeyup();
		}
		if (!GetAsyncKeyState(VK_LEFT) && leftKeyState) {
			leftKeyState = false;
			gp.onleftkeyup();
		}
		gp.refresh();
		Sleep(5);
	}
	return 0;
}