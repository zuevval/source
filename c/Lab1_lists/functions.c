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
/*
void addToList(struct List *L1, struct List *buf, char *date, char *surname , int num){
	struct List * q = L1->next;
	struct List * t = (struct List*)malloc(sizeof(struct List));
	t->surname = (char*)malloc(sizeof(char)*(strlen(surname)+1));
	t->date = (char*)malloc(sizeof(char)*(strlen(date)+1));
	strcpy(t->surname, surname);
	strcpy(t->date, date);
	t->n=num;
	strcpy(buf->surname, surname);
	//strcmp(s1,s2)==0 <=> s1==s2
	//strcmp(s1,s2)>0 <=> s1>s2
	while(strcmp(q->surname,surname)<0)
		q=q->next;
	if(q==buf){
		//should be even easier with one-dimensional lists
		t->next=buf;
		t->prev = buf->prev;
		buf->prev->next=t;
		buf->prev = t;
	} else {
		t->next=q;
		t->prev = q->prev;
		q->prev->next=t;
		q->prev = t;
	}
}
void ReadList(struct List *L1, struct List *buf){
	char *date = (char*)malloc(sizeof(char)*DATE_LEN);
	char *surname = (char*)malloc(sizeof(char)*SURNAME_LEN);
	int num;
	FILE * f = fopen("data.txt","r");
	setlocale(LC_ALL, "Rus");
	L1->next=buf;
	buf->prev = L1;
	L1->surname = (char*)malloc(sizeof(char)*SURNAME_LEN);
	buf->surname = (char*)malloc(sizeof(char)*SURNAME_LEN);
    if(!f)
        printf("Error reading data.txt\n");
    else {
        while(!feof(f)){
			fscanf(f, "%s", date);
			//printf("%s\n",date);
			fscanf(f, "%s", surname);
			//printf("%s\n",surname);
			fscanf(f, "%d", &num);
			//printf("%d\n", num);
			addToList(L1, buf, date, surname, num);
        }
        fclose(f);
	}
}
int findSurn(char*surname, char*surn){
	int len1 = strlen(surn);
	char * surn1 = (char*)malloc(sizeof(char)*(len1+1));
	strcpy(surn1,"");
	strncat(surn1,surname,len1);
	if(!strcmp(surn1,surn)){
		return 1;
	}
	return 0;
}*/