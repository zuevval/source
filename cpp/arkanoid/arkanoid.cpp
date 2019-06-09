#include"arkanoid.h"

gamePane::gamePane() {
	shared_ptr<figure> block1 = make_shared<figure>(figure(5, 5));
	shared_ptr<figure> block2 = make_shared<figure>(figure(30, 5));
	shared_ptr<figure> block3 = make_shared<figure>(figure(15, 15));
	shared_ptr<figure> block4 = make_shared<figure>(figure(15, 19));
	shared_ptr<figure> platform1 = make_shared<figure>(figure(20, 20));
	add(block1);
	add(block2);
	add(block3);
	add(block4);
	platformID = add(platform1);
}

