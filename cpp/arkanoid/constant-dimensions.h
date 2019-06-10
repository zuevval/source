#ifndef H_DIMEISIONS_CONSTANTS
#define H_DIMEISIONS_CONSTANTS
namespace dim {
	//----------frame----------
	const int windowHeight = 24;
	const int windowWidth = 80;
	const int wallHeight = windowHeight - 1;
	const int wallWidth = 2;
	const int statBarHeight = 1;
	const int statBarWidth= 19;
	const int ceilingHeight = 1;
	const int ceilingWidth = windowWidth - 2*wallWidth - statBarWidth;
	const int statBarXoffset = ceilingWidth + wallWidth;


	//----game area content-----
	const int blockWidth = 2;
	const int blockHeight = 2;
	const int blockUpperLayerY = 5;
	const int blockLowerLayerY = blockUpperLayerY + blockHeight;
	const int thirdLayerY = blockUpperLayerY + 2*blockHeight;
	const int solidBlocksLeft = 4;
	const int solidBlocksRight = 4;
	const int ballWidth = 1;
	const int ballHeight = ballWidth;
	const int tokenWidth = 1;
	const int tokenHeight = tokenWidth;
	const int platformHeight = 2;
	const int platformWidth = 6;
	const int bigPlatformWidth = 10;
	const int platformYoffset = wallHeight - platformHeight;

	const int gameAreaWidth = windowWidth - 2 * wallWidth;
	const int gameAreaHeight = platformYoffset - ceilingHeight;

}

namespace consts {
	const int blockColors[] = { 7,  9, 10, 11, 12, 14, 15 };
	const int defaultColormap = 7;
	const int defaultLives = 3;
	const int standardReward = 10;
	const int blockSpawnInterval = 100;
	const int bonusDuration = 300;
	const double platformVelocity = 0.25;
	const double ballVxInit = 0.1;
	const double ballVyInit = -0.1;
	const double tokenVelocity = 0.15;
}

#endif
