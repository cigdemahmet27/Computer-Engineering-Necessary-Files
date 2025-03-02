#include <stdio.h>
#include <stdlib.h>
#include "process_queue.h"


void initialize_process_queue(PROCESS_QUEUE *pq)
{
  //pq = (PROCESS_QUEUE*)malloc(sizeof(PROCESS_QUEUE));
  pq->front = 0;
  pq->rear = -1;
  pq->size = 0;
  pq->priority = 0;
  pq->iteration = 0;
}

bool isFull(PROCESS_QUEUE *pq)
{
  return pq->size == QUEUE_SIZE;
}

bool isEmpty(PROCESS_QUEUE *pq)
{
  return pq->size == 0;
}

PROCESS peek(PROCESS_QUEUE *pq)
{
  if(!isEmpty(pq))
  {
    return pq->queue[pq->front];
  }
  printf("Process Queue is empty!\n");
  return pq->queue[pq->front];
}

void enqueue(PROCESS_QUEUE *pq, PROCESS data)
{
  if(!isFull(pq))
  {
    pq->rear = ++pq->rear % QUEUE_SIZE;
    pq->queue[pq->rear] = data;
    pq->size++;
    return;
  }
  printf("Process queue is full!\n");
}

PROCESS dequeue(PROCESS_QUEUE *pq)
{
  if(!isEmpty(pq))
  {
    PROCESS temp = pq->queue[pq->front];
    pq->front = ++pq->front % QUEUE_SIZE;
    pq->size--;
    return temp;
  }
  printf("Process queue is empty!\n");
}

/*void printProccesQueue(PROCESS_QUEUE *pq)
{
  printf("-");
  
  if(!isEmpty(pq))
  {
    int i = pq->front;
    int sz = pq->size;
    printf(" %d -", pq->queue[pq->front].pid);
    sz--;
    while(sz != 0)
    {
      i = ++i % QUEUE_SIZE;
      printf(" %d -", pq->queue[i].pid);
      sz--;
    }
  }
  printf("\n");
}*/