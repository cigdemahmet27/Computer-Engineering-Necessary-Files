#include <stdio.h>
#include <stdlib.h>
#include "process_manager.h"


void initialize_process_manager(PROCESS_MANAGER *pm)
{
  //pm = (PROCESS_MANAGER*)malloc(sizeof(PROCESS_MANAGER));
  pm->rear = -1;
  pm->front = 0;
  pm->size = 0;
}

bool isFull(PROCESS_MANAGER *pm)
{
  return pm->size == MAX_PROCESS;
}

bool isEmpty(PROCESS_MANAGER *pm)
{
  return pm->size == 0;
}

void insert_front(PROCESS_MANAGER *pm, PROCESS_QUEUE pq)
{
  if(!isFull(pm))
  {
    
    pm->front =  (pm->front - 1 + MAX_PROCESS) % MAX_PROCESS;

    pm->deque[pm->front] = pq;
    pm->size++;
    return;
  }
  printf("Proccess manager is full!\n");
}

void insert_rear(PROCESS_MANAGER *pm, PROCESS_QUEUE pq)
{
  if(!isFull(pm))
  {
    pm->rear = ++pm->rear % MAX_PROCESS;
    pm->deque[pm->rear] = pq;
    pm->size++;
    return;
  }
  printf("Proccess Manager is full!\n");
}

PROCESS_QUEUE delete_front(PROCESS_MANAGER *pm)
{
  if(!isEmpty(pm))
  {
    PROCESS_QUEUE temp = pm->deque[pm->front];
    pm->front = ++pm->front % MAX_PROCESS;
    pm->size--;
    return temp;
  }
  printf("Proccess Manager is empty!\n");
}

PROCESS_QUEUE delete_rear(PROCESS_MANAGER *pm)
{
  if(!isEmpty(pm))
  {
    PROCESS_QUEUE temp = pm->deque[pm->rear];
    pm->size--;
    if(pm->size == 0 && pm->rear == 0)
    {
      pm->rear = -1;
      return temp;
    }
    --pm->rear;
    if (pm->rear == -1) {
      pm->rear = MAX_PROCESS - 1; 
  }
    return temp;
  }
  printf("Proccess Manager is empty!\n");
}

/*void PrintProcessManager(PROCESS_MANAGER *pm)
{
  printf("^\n|\n");  
  if(!isEmpty(pm))
  {
    int i = pm->front;
    int sz = pm->size;
    printProccesQueue(&pm->deque[pm->front]);
    sz--;
    while(sz != 0)
    {
      i = ++i % MAX_PROCESS;
      printProccesQueue(&pm->deque[i]);
      sz--;
    }
  }
  printf("|\n^\n");
}*/