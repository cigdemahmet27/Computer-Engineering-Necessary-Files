#include <stdio.h>
#include <stdlib.h>
#include "insertion_queue.h"

void initialize_execution_queue(INSERTION_QUEUE *iq)
{
  //iq = (INSERTION_QUEUE*)malloc(sizeof(INSERTION_QUEUE));
  iq->front = 0;
  iq->rear = -1;
  iq->size = 0;
}

bool isFull(INSERTION_QUEUE *iq)
{
  return iq->size == MAX_OPERATION;
}

bool isEmpty(INSERTION_QUEUE *iq)
{
  return iq->size == 0;
}

PROCESS_QUEUE peek(INSERTION_QUEUE *iq)
{
  if(!isEmpty(iq))
  {
    return iq->queue[iq->front];
  }
}

void enqueue(INSERTION_QUEUE *iq, PROCESS_QUEUE data)
{
  if(!isFull(iq))
  {
    iq->rear = ++iq->rear % MAX_OPERATION;
    iq->queue[iq->rear] = data;
    iq->size++;
    return;
  }
  printf("Insertion Queue is full!\n");
}

PROCESS_QUEUE dequeue(INSERTION_QUEUE *iq)
{
  if(!isEmpty(iq))
  {
    PROCESS_QUEUE temp = iq->queue[iq->front];
    iq->front = ++iq->front % MAX_OPERATION;
    iq->size--;
    return temp;
  }
  printf("Insertion Queue is empty!\n");
}

/*void PrintInsertionQueue(INSERTION_QUEUE *iq)
{
  printf("^\n|\n");  
  if(!isEmpty(iq))
  {
    int i = iq->front;
    int sz = iq->size;
    printProccesQueue(&iq->queue[iq->front]);
    sz--;
    while(sz != 0)
    {
      i = ++i % MAX_OPERATION;
      printProccesQueue(&iq->queue[i]);
      sz--;
    }
  }
  printf("|\n^\n");
}*/