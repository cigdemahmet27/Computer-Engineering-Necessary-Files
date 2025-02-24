#include <stdio.h>
#include <stdlib.h>
#include "execution_functions.h"
#include "process_manager.h"
#include "insertion_queue.h"

void printProccesQueue(PROCESS_QUEUE *pq)
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
}

void PrintProcessManager(PROCESS_MANAGER *pm)
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
}

void PrintInsertionQueue(INSERTION_QUEUE *iq)
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
}

void printFailureStack(FAILURE_STACK *fs)
{
  printf("^\n|\n");
  if(!isEmpty(fs))
  {
    for(int i = fs->top; i >= 0; i--)
    {
      printProccesQueue(&fs->stack[i]);
    }
  }
  printf("|\n^\n");
}


// Important Functions Start Here


void read_process_file(const char *filename, PROCESS_MANAGER *pm)
{
  FILE *file = fopen(filename, "r");
  if(file == NULL)
  {
    printf("File Opening Error");
    return;
  }

  char header[100];
  fgets(header, sizeof(header), file);

  int pd, prt, ih;
  PROCESS_QUEUE temp;
  initialize_process_queue(&temp);

  PROCESS tempProcess;

  // FIRST LETS MAKE THE PROCCESS QUEUE
  while(fscanf(file, "%d, %d, %d", &pd, &prt, &ih) == 3)
  {
    
    initialize_process(&tempProcess, pd, prt);
    enqueue(&temp, tempProcess);

    if(ih == 1)
    {
      if(prt == 1)
      {
        temp.priority = prt;
        insert_front(pm, temp);
        initialize_process_queue(&temp);
      } else
      {
        temp.priority = prt;
        insert_rear(pm, temp);
        initialize_process_queue(&temp);
      }
    }
  }
  fclose(file);
}


void read_insertion_file(const char *filename, INSERTION_QUEUE *eq)
{
  FILE *file = fopen(filename, "r");
  if(file == NULL)
  {
    printf("File Opening Error");
    return;
  }


  char header[100];
  fgets(header, sizeof(header), file);
  
  int itr, pd, prt, ih;
  PROCESS_QUEUE temp;
  initialize_process_queue(&temp);

  PROCESS tempProcess;

  // FIRST LETS MAKE THE PROCCESS QUEUE
  while(fscanf(file, "%d, %d, %d, %d", &itr, &pd, &prt, &ih) == 4)
  {
    
    initialize_process(&tempProcess, pd, prt);
    enqueue(&temp, tempProcess);

    if(ih == 1)
    {
      temp.priority = prt;
      temp.iteration = itr;
      enqueue(eq, temp);
      initialize_process_queue(&temp);
    }
  }
  fclose(file);
}



void execution_loop(PROCESS_MANAGER *pm, INSERTION_QUEUE *eq, FAILURE_STACK *fs)
{
  int iter = 0;
  PROCESS_QUEUE tmpProcessQueue;
  PROCESS tmpProcess;

  FILE *file = fopen("execution_run.txt", "w");

  if(file == NULL)
  {
    printf("File Opening Error");
    return;
  }

  while(pm->size != 0)
  {
    
    tmpProcessQueue = delete_front(pm);
    
    while(tmpProcessQueue.size != 0)
    {
      printf("Inter %d: ", iter);
      tmpProcess = peek(&tmpProcessQueue);
      printf("%d executed", tmpProcess.pid);

      if(tmpProcess.pid % 8 == 0)
      {
        printf(", failed");
        fprintf(file, "%d f\n", tmpProcess.pid);

        push(fs, tmpProcessQueue);
        initialize_process_queue(&tmpProcessQueue);

      } else {
        dequeue(&tmpProcessQueue);
        fprintf(file, "%d s\n", tmpProcess.pid);
      }

      //check if insertion has come
      if(eq->queue[eq->front].iteration == iter)
      {
        printf(", ");
        printProccesQueue(&eq->queue[eq->front]);
        printf("arrived");

        if(eq->queue[eq->front].priority == 1)
        {
          insert_front(pm, eq->queue[eq->front]);
          dequeue(eq);
        } else 
        {
          insert_rear(pm, eq->queue[eq->front]);
          dequeue(eq);
        }
      }
      printf("\n");

      printf("Process Manager:\n");
      PrintProcessManager(pm);

      printf("To be executed: ");
      printProccesQueue(&tmpProcessQueue);

      if(tmpProcess.pid % 8 == 0)
      {
        tmpProcessQueue = delete_front(pm);
      }
      
      printf("Insertion Queue:\n");
      PrintInsertionQueue(eq);
      
      printf("Failuer Stack:\n");
      printFailureStack(fs);
      
      for(int j = 0; j < 60; j++)
      {
        printf("-");
      }
      printf("\n");
      
      iter++;
    }
  }

  fclose(file);
  return;
}

