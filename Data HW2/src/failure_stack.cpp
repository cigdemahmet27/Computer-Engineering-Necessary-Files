#include <stdio.h>
#include <stdlib.h>
#include "failure_stack.h"
#include "process_queue.h"


void initialize_failed_stack(FAILURE_STACK *fs)
{
  //fs = (FAILURE_STACK*)malloc(sizeof(FAILURE_STACK));
  fs->top = -1;
}

bool isFull(FAILURE_STACK *fs)
{
  return fs->top == MAX_FAILED - 1;
}

bool isEmpty(FAILURE_STACK *fs)
{
  return fs->top == -1;
}

void push(FAILURE_STACK *fs, PROCESS_QUEUE data)
{
  if(!isFull(fs))
  {
    fs->stack[++fs->top] = data;
    return;
  }
  printf("Stack is full!\n");
}

PROCESS_QUEUE pop(FAILURE_STACK *fs)
{
  if(!isEmpty(fs))
  {
    PROCESS_QUEUE temp = fs->stack[fs->top];
    fs->top--;
    return temp;
  }
  printf("Stack is empty!\n");
}

/*void printFailureStack(FAILURE_STACK *fs)
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
}*/