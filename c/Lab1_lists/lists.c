//lab 1 number 7
#include<stdio.h>
#include<conio.h>
#include<stdlib.h>
#include<locale.h>
#include<string.h>
//#include"functions.h"
#ifndef MY_MACRO
#define MY_MACRO
#define DATE_LEN 10
#define SURNAME_LEN 100
#endif
//how to define structs in aux files?
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

int main(void){
	int sum=0;
	char flag='Y';
	char *s = malloc(sizeof(char)*SURNAME_LEN);
	struct List * L1 = (struct List*)malloc(sizeof(struct List));
	//L1 is always empty
	struct List * buf = (struct List*)malloc(sizeof(struct List));
	struct List * q;
	ReadList(L1, buf);
	q=L1->next;
	printf("   Сотрудник   Суммарно часов\n");
	while(q!=buf){
		strcpy(buf->surname,q->surname);
		while(!strcmp(q->surname,buf->surname) && q!=buf){
			sum+=q->n;
			q=q->next;
		}
		q=q->prev;
		printf("%10s %10d\n",q->surname,sum);
		sum=0;
		q=q->next;
	}
	while(flag=='Y'){
		q=L1->next;
		printf("Введите первые буквы фамилии:\n");
		scanf("%s", s);
		while(q!=buf && !findSurn(q->surname, s))
			q=q->next;
		if(findSurn(q->surname, s))
			printf("Найдено соответствие: %s\n",q->surname);
		else
			printf("Такого сотрудника нет\n");
		printf("Продолжать будете? Y/N\n");
		scanf("\n%c",&flag);
	}

	printf("\nСписок сотрудников:\n");
	q=L1->next;
	sum=0;
	while(q!=buf){
		strcpy(buf->surname,q->surname);
		while(!strcmp(q->surname,buf->surname) && q!=buf){
			sum+=q->n;
			q=q->next;
		}
		q=q->prev;
		printf("%10s\n",q->surname);
		q=q->next;
	}
	printf("Всего наработали: %d часов\n", sum);
	free(L1);
	free(buf);
	free(s);
	return 0;

}

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
}