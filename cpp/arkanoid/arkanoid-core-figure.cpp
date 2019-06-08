#include"arkanoid-core.h"
#include<fstream>

void gotoxy(int x, int y)
{
	COORD coord;
	coord.X = x;
	coord.Y = y;
	SetConsoleCursorPosition(GetStdHandle(STD_OUTPUT_HANDLE), coord);
}
constexpr int maxBufSize = 10;
constexpr int barrierSize = 1;
figure::figure(double X, double Y) :x(X), y(Y), vx(0), vy(0) { 
	image.resize(height);
	ifstream in(imageFilename);
	char * buf = new char[maxBufSize + barrierSize];
	for (int i = 0; i < height; i++) {
		 in.getline(buf, maxBufSize);
		 image[i] = string(buf);
		 if (image[i].size() != width) {
			 delete[] buf;
			 in.close();
			 throw ERROR;
		 }
	}
	delete[] buf;
	in.close();
	draw(); 
};

void figure::draw() {
	int xInt = getXint();
	int yInt = getYint();
	gotoxy(xInt, yInt);
	for (int i = 0; i < height; i++) {
		gotoxy(xInt, yInt + i);
		cout << image[i];
	}
}

void figure::erase() {
	int xInt = getXint();
	int yInt = getYint();
	string empty;
	for (int i = 0; i < height; i++) empty += ' ';
	for (int i = 0; i < height; i++) {
		gotoxy(xInt, yInt + i);
		cout << empty;
	}
}

void figure::jumpTo(double X, double Y) {
	erase();
	x = X;
	y = Y;
	draw();
}

void figure::move() {
	jumpTo(x + vx, y + vy);
}