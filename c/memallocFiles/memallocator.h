//v3.1
#include<stdlib.h>
#ifndef __MEMALLOCATOR_H__E71A34CB
#define __MEMALLOCATOR_H__E71A34CB
#ifdef __cplusplus
extern "C" {
#endif
#ifndef MY_ABS1
#define MY_ABS1
#define Myabs(a) ((a)>=0 ? (a) : (-(a)))
#endif
#ifndef MY_MACRO_CONSTANTS1
#define MY_MACRO_CONSTANTS1

#define HEAD_LEN (1)
	/*quantity of 4-bytes memory cells in the left part
	 *of every block given to user to store
	 *block length (used in concatenation of free blocks)
	 *(half of all user-taboo blocks)*/
#define TAIL_LEN (1)
#define BUFFRS_LEN (2)
	 /*quantity of 4-bytes memory blocks that mark the limits of
	  * the whole memory block initialized in meminit*/
#define BUFFR_LEN (1)
#define END_MARK (-1)
#define NOT_FOUND (-1)
#define ERR_FLAG (-1)
#define SUCCESS_FLAG (0)
	  //this numbers marks the end of the available memory array
#endif
	int *s = NULL;
	int memgetblocksize() {
		/*returns a size of memory per block that is not for user*/
		return sizeof(int)*(TAIL_LEN + HEAD_LEN) + sizeof(int *); //TODO: no magic numbers //DONE
		//16 on my machine
	}
	int fullblocksize() {
		return memgetblocksize();
		//16 on my machine
	}
	int memgetminimumsize() {
		return fullblocksize() + BUFFRS_LEN * sizeof(int);
		//24 on my machine
	}
	int meminit(void *pMemory, int size) {
		extern int *s;
		int * size_start;
		int * size_end;
		int ** next;
		if (size < memgetminimumsize())
			return ERR_FLAG;
		size_start = (int*)pMemory + BUFFR_LEN;
		size_start[-BUFFR_LEN] = END_MARK;
		size_start[0] = size - BUFFRS_LEN * sizeof(int); //marked as free
		size_end = (int *)((char*)pMemory + size - BUFFRS_LEN * sizeof(int));
		size_end[0] = size - BUFFRS_LEN * sizeof(int); //marked as free
		size_end[BUFFR_LEN] = END_MARK;
		next = (int **)(size_start + HEAD_LEN);
		next[0] = NULL;
		s = size_start;
		return SUCCESS_FLAG;
	}
	int *findbestfree(int minsize) {
		/*loops through the free memory list
		 *returns a block with the least size among those
		 *which length is >"size"
		 *or first which length is ="size"
		 *if no such blocks, returns NULL*/
		extern int *s;
		int *q = s;
		int qsize;
		int **qnext;
		int *best = NULL;
		int bestsize = NOT_FOUND;
		while (q != NULL) {
			qnext = (int**)(q + HEAD_LEN);
			qsize = q[0];
			if (qsize > minsize) {
				if (bestsize == NOT_FOUND || bestsize < qsize) {
					bestsize = qsize;
					bestsize = qsize;
					best = q;
				}
			}
			if (qsize == minsize) {
				best = q;
				break;
			}
			if (qnext[0] == NULL)
				break;
			q = qnext[0];
		}
		return best;
	}
	void split(int *p, int size) {
		/*reduces p to the "size"
		 *makes a new block in the remainder
		 *inserts q into free memory:
		 *p_prev->p->p_next => p_prev->p->q->p_next*/
		int psize = p[0];
		int qsize = psize - size;
		int **pnext = (int **)(p + HEAD_LEN);
		int *q = (int *)((char *)p + size);
		int **qnext = (int **)(q + HEAD_LEN);
		char *qend = ((char *)p + psize);
		if (qsize < fullblocksize()) {
			return;
		}
		qnext[0] = pnext[0];
		pnext[0] = q;
		p[0] = size;
		q[-TAIL_LEN] = size;
		q[0] = qsize;
		((int*)(qend - sizeof(int)))[0] = qsize;
	}
	void popblock(int *q) {
		/*marks block as occupied
		 *and throws from the free memory list
		 *also sets s to q->next if q is the first block*/
		extern int *s;
		int qsize = q[0];
		int ** qnext = (int **)(q + HEAD_LEN);
		char *qend = (char*)q + qsize;
		int *qprev = s;
		int ** qprevnext;
		if (s == NULL) {
			return;
		}
		if (qsize < fullblocksize()) {
			return;
		}
		qprevnext = (int **)(s + HEAD_LEN);
		if (q != s) {
			while (qprevnext[0] != q) {
				qprev = qprevnext[0];
				qprevnext = (int **)(qprev + HEAD_LEN);
			}
			qprevnext[0] = qnext[0];
		}
		else
			s = qnext[0];
		q[0] = -qsize; //marked as occupied
		((int*)(qend - sizeof(int)))[0] = -qsize; //marked as occupied
	}
	void *memalloc(int size) {
		extern int * s;
		int * p;
		int psize;
		p = findbestfree(size + memgetblocksize());
		if (p == NULL) {
			return NULL;
		}
		psize = p[0];
		if (psize - (size + memgetblocksize()) >= fullblocksize())
			split(p, size + memgetblocksize());
		popblock(p);
		return (void *)(p + HEAD_LEN);
	}
	void pushblock(int *q) {
		/*changes sign of size in front&rear to "+"
		 *sets s=q, inserts q into list*/
		extern int *s;
		int size = Myabs(q[0]);
		int **next = (int **)(q + HEAD_LEN);
		char *qend = (char *)q + size - TAIL_LEN * sizeof(int);
		if (q[0] > 0) {
			return;
		}
		q[0] = size;
		next[0] = s;
		((int *)qend)[0] = size;
		s = q;
	}
	void extend_right(int *q) {
		/*finds block to the right of q (r)
		 *pops q, r; pushes r, then q
		 *sets q->size to q->size+r->size
		 *sets q->next to r->next*/
		int qsize = q[0];
		int **qnext = (int **)(q + HEAD_LEN);
		char *afterq = (char *)q + qsize;
		int *r = (int *)afterq;
		int rsize = r[0];
		int **rnext = (int **)(r + HEAD_LEN);
		int size = qsize + rsize;
		char *rend = (char *)r + rsize - TAIL_LEN * sizeof(int);
		popblock(q);
		popblock(r);
		pushblock(r);
		pushblock(q);
		qnext[0] = rnext[0];
		q[0] = size;
		((int *)rend)[0] = size;
	}
	int *extend_left(int *q) {
		int qsize = q[0];
		int rsize = q[-TAIL_LEN];
		int *r = (int *)((char *)q - rsize);
		popblock(r);
		popblock(q);
		r[0] = -(rsize + qsize);
		((int *)((char *)q + qsize - sizeof(int)))[0] = -(rsize + qsize);
		pushblock(r);
		return r;
	}
	void memfree(void *p) {
		extern int *s;
		int *q = (int *)p - HEAD_LEN;
		int size, prevsize;
		int nextsize;
		pushblock(q);
		size = q[0];
		nextsize = ((int *)((char *)q + size))[0];
		while (nextsize > 0) {
			extend_right(q);
			size = q[0];
			nextsize = ((int *)((char *)q + size))[0];
		}
		prevsize = q[-TAIL_LEN];
		while (prevsize > 0) {
			q = extend_left(q);
			prevsize = q[-TAIL_LEN];
		}
	}
	void memdone() {
		int errorflag = 0;
		extern int *s;
		int *p = s;
		int ** pnext;
		int psize;
		int sum = 0; //sum of sizes of all blocks
		if (p != NULL)
			pnext = (int **)(p + HEAD_LEN);
		while (p != NULL) {
			psize = p[0];
			sum += psize;
			pnext = (int **)(p + HEAD_LEN);
			if (pnext[0] != NULL)
				errorflag = ERR_FLAG;
			if (((int *)((char*)p + psize - TAIL_LEN * sizeof(int)))[0] != psize) {
				errorflag = 1;
				break;
			}
			p = pnext[0];
		}
		//printf("memdone control sum = %d\n",sum); //useful in debugging
	}
#ifdef __cplusplus
}
#endif
#endif
