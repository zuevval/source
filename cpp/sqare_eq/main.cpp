#include"classes.h"
using namespace std;

int main(int argc, char* argv[]) {
    ifstream in("inputInbox.txt");
    if(!in){
        cerr << "oops, file not found";
        return 0;
    }
	teacher t;
	t.putMany(in); //filling inbox with letters
	t.checkAll();
	t.printStat(cout);
    return 0;
}