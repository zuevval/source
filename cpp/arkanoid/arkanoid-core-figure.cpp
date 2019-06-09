#include"arkanoid-core.h"
#include<fstream>

void gotoxy(int x, int y)
{
	COORD coord;
	coord.X = x;
	coord.Y = y;
	SetConsoleCursorPosition(GetStdHandle(STD_OUTPUT_HANDLE), coord);
}

constexpr int maxBufSize = 100;
constexpr int barrierSize = 1;
void figure::spawn(double X, double Y) {
	x = X;
	y = Y;
	vx = 0;
	vy = 0;
	image.resize(height);
	ifstream in(imageFilename);
	char * buf = new char[maxBufSize + barrierSize];
	in.getline(buf, maxBufSize);
	image[0] = string(buf);
	if(width != image[0].size()) width = image[0].size();
	for (int i = 1; i < height; i++) {
		 in.getline(buf, maxBufSize);
		 image[i] = string(buf);
		 if (image[i].size() != width) {
			 in.close();
			 delete buf;
			 return;
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
	for (int i = 0; i < width; i++) empty += ' ';
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
	if (x < 0 || x + width > windowWidth || y < 0 || y + height >= windowHeight) setSpeed(0, 0);
}

void figure::jumpBack(shared_ptr<figure> & f) {
	assert(actionOnBump == jump);
	int targetX = f->getXint();
	int targetY = f->getYint();
	int targetWidth = f->getWidth();
	int targetHeight = f->getHeight();
	bool cameHorisontally = false;
	bool cameVertically = false;
	cameHorisontally |= x - vx <= targetX;
	cameHorisontally |= x - vx >= targetX + targetWidth;
	cameVertically |= y - vy <= targetY;
	cameVertically |= y - vy >= targetY + targetHeight;
	if (cameHorisontally) vx *= -1;
	if (cameVertically) vy *= -1;
	move();
	f->draw();
}