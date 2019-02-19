//lab 1 number 7
#include<stdio.h>
#include<conio.h>
#include<stdlib.h>
#include<locale.h>
#include<string.h>
#ifndef MY_MACRO
#define MY_MACRO
#define DATE_LEN 10
#define SURNAME_LEN 100
#endif
struct List{
	char *surname;
	char *date;
	int n;
	struct List* next;
	struct List* prev;

};
void addToList(struct List *L1, struct List *buf, char *date, char *surname , int num);
void ReadList(struct List *L1, struct List *buf);
int findSurn(char*surname, char*surn);