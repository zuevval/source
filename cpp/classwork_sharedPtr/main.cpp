#include<iostream>

class myClass{
  int data;
};

class sharedPointer{
private:
  myClass * mcPtr;
  int * counter;
public:
  sharedPointer(myClass * mc){mcPtr=mc; counter = new int; *counter = 1;};
  sharedPointer(const sharedPointer & spParent);
  sharedPointer operator=(const sharedPointer & spParent);
  void printNumInstances(std::ostream & out){out<<"qty:"<<*counter<<std::endl;};
  ~sharedPointer();
};

sharedPointer::sharedPointer(const sharedPointer & spParent){
  mcPtr = spParent.mcPtr;
  counter = spParent.counter;
  (*counter)++;
}

sharedPointer sharedPointer::operator =(const sharedPointer & spParent){
  if(spParent.mcPtr == mcPtr)
    (*counter)++;
  (*counter)--; //we forget one instance of some pointer
  if(*counter == 0) delete mcPtr;
  sharedPointer spChild(spParent);
  return spChild;
}

sharedPointer::~sharedPointer(){
  if(*counter > 0){
    (*counter)--;
  }
  if((*counter) == 0) delete mcPtr;
  std::cout << "~sp, instanses left:"<< (*counter) <<std::endl;
}

int main(int argc, char * argv[]){
  myClass * mc1 = new myClass;
  myClass * mc2 = new myClass;
  sharedPointer * sp = new sharedPointer(mc1);
  sp->printNumInstances(std::cout);
  sharedPointer sp2=*sp;
  sp->printNumInstances(std::cout);
  delete sp;

  sharedPointer sp3(sp2);
  sp3.printNumInstances(std::cout);
  return 0;
}