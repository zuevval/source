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
		gameoverFlag gflag = gp.refresh();
		if (gflag == true) {
			gotoxy(windowWidth / 2 - 5, windowHeight / 2);
			cout << "GAME OVER";
		}
		Sleep(5);
	}
	return 0;
}