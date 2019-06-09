#include"arkanoid.h"

int main(void) {
	gotoxy(10, 10);
	try {
		mciSendString("open \"space-final-signal.mp3\" type mpegvideo alias mp3", NULL, 0, NULL);
		mciSendString("play mp3 repeat", NULL, 0, NULL);
	}
	catch (...) {
		cerr << "error trying to play music";
	}
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
			HANDLE console = GetStdHandle(STD_OUTPUT_HANDLE);
			SetConsoleTextAttribute(console, 201);
			cout << "GAME OVER";
			gotoxy(windowWidth / 2 - 10, windowHeight / 2 + 1);
			cout << "press ESC to quit";
			SetConsoleTextAttribute(console, 15);
		}
		Sleep(5);
	}
	gotoxy(0, windowHeight);
	cout << "goodbye" << endl;
	return 0;
}