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
	const int flyingBlockLayerY = 2;
	const int blockUpperLayerY = 5;
	const int blockLowerLayerY = blockUpperLayerY + blockHeight;
	const int thirdLayerY = blockUpperLayerY + 2*blockHeight;
	const int solidBlocksLeft = 4;
	const int solidBlocksRight = 4;
	const int ballWidth = 1;
	const int ballHeight = ballWidth;
	const int bigBallWidth = 2;
	const int bigBallHeight = bigBallWidth;
	const int tokenWidth = 1;
	const int tokenHeight = tokenWidth;
	const int platformHeight = 2;
	const int platformWidth = 6;
	const int bigPlatformWidth = 10;
	const int platformYoffset = wallHeight - platformHeight - 1;
	const int trampolineYoffset = platformYoffset + platformHeight;
	const int trampolineWidth = 78;
	const int trampolineHeight = 1;
	const int maxY = trampolineYoffset + 2;
	const int bigToSmallPlatfXshift = 1;

	const int gameAreaWidth = windowWidth - 2 * wallWidth;
	const int gameAreaHeight = platformYoffset - ceilingHeight;

}

namespace consts {
	const int blockColors[] = { 7,  9, 10, 11, 12, 14, 15 };
	const int defaultColormap = 7;
	const int defaultLives = 3;
	const int standardReward = 10;
	const int flyingBlockRewardMultiple = 5;
	const int blockSpawnInterval = 100;
	const int bonusDuration = 300;
	const double platformVelocity = 0.25;
	const double boostPlatfMultiple = 1.7;
	const double ballVxInit = 0.1;
	const double ballVyInit = -0.1;
	const double boostBallMultiple = 1.7;
	const double tokenVelocity = 0.15;
	const int flyingBlockRevertPeriod = 400;
	const double flyingBlockVx = 0.05;
}

#endif
