#include"classes.h"
void teacher::printStat(std::ostream & out) {
	std::map<std::string, student>::iterator it = studs.begin();
	while (it != studs.end()) {
		std::string studName = it->first;
		int correct = it->second.solved;
		int wrong = it->second.failed;
		out << "student: " << studName << std::endl;
		out << "correct: " << correct << std::endl;
		out << "incorrect: " << wrong << std::endl;
		it++;
	}
}


void teacher::putMany(std::istream & in) {
	for (std::string name; std::getline(in, name);) {
		std::string buf;
		if (!std::getline(in, buf)) { std::cerr << "no data"; return;  }
		std::istringstream iss(buf);
		letter l;
		l.name = name;
		if (!(iss >> l.eq.a)) { std::cerr << "no a"; return; }
		if (!(iss >> l.eq.b)) { std::cerr << "no b"; return; }
		if (!(iss >> l.eq.c)) { std::cerr << "no c"; return; }
		if (!(iss >> l.ans.rootsQty)) { std::cerr << "no rootsQty"; return; }
		if (l.ans.rootsQty) {
			if (!(iss >> l.ans.x1)) { std::cerr << "no x1"; return; }
		}
		if (l.ans.rootsQty > 1) {
			if (!(iss >> l.ans.x2)) { std::cerr << "no x1"; return; }
		}
		if (l.ans.rootsQty > 2) std::cerr << "oops, equation sent by " << name << "is not square!";
		put(l);
	}
}


void teacher::checkAll() {
	ansInfo ans = checkNext();
	while (ans.name != ""){ //while inbox is not empty
		try {
			studs.at(ans.name);
		}
		catch (const std::out_of_range& oor) {
			student st;
			st.solved = 0;
			st.failed = 0;
			studs.insert(std::pair<std::string, student>(ans.name, st));
		}
		studs.at(ans.name).solved += (int)ans.isCorrect;
		studs.at(ans.name).failed += (int)(!ans.isCorrect);
		ans = checkNext();
	}
}

void inbox::put(letter l) {
	newMail.push(l);
}

ansInfo inbox::checkNext() {
	ansInfo ans;
	ans.name = "";
	if (newMail.empty())
		return ans;
	letter l = newMail.front();
	newMail.pop();
	ans.name = l.name;
	sqEquation eq(l.eq);
	if (l.ans.rootsQty != eq.printRoots().rootsQty) {
		ans.isCorrect = false;
		return ans;
	}
	double trueX1 = eq.printRoots().x1;
	double trueX2 = eq.printRoots().x2;
	switch (l.ans.rootsQty) {
	case 0:
		ans.isCorrect = true;
		break;
	case 1:
		ans.isCorrect = (eq.printRoots().x1 == l.ans.x1);
		break;
	case 2:
		ans.isCorrect = (trueX1 == l.ans.x1);
		ans.isCorrect |= (trueX1 == l.ans.x2);
		ans.isCorrect &= ((trueX2 == l.ans.x1) || (trueX2 == l.ans.x2));
		break;
	default:
		ans.isCorrect = true;
	}
	return ans;
}

sqEquation::sqEquation(eqCoefs abc) {
	this->abc = abc;
	solve();
}
eqRoots sqEquation::printRoots() {
	return this->roots;
}
void lin_eq(const double k, const double b, eqRoots * eq_rts) { //kx+b=0
	if (k == 0) {
		eq_rts->rootsQty = 0;
		return;
	}
	eq_rts->rootsQty = 1;
	eq_rts->x1 = -b / k;
	eq_rts->x2 = eq_rts->x1;
}
void sqEquation::solve() {
	double a = this->abc.a;
	double b = this->abc.b;
	double c = this->abc.c;
	if (a == 0) {
		lin_eq(b, c, &(this->roots));
		return;
	}
	double d = b * b - 4 * a*c;
	if (d < 0) {
		this->roots.rootsQty = 0;
		return;
	}
	this->roots.x1 = 0.5*(-b + sqrt(d))/a;
	this->roots.x2 = 0.5*(-b - sqrt(d))/a;
	if (this->roots.x1 == this->roots.x2)
		this->roots.rootsQty = 1;
	else
		this->roots.rootsQty = 2;
}