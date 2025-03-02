#include "exam.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// Function to create a new exam and link it properly in the day
struct Exam* CreateExam(int startTime, int endTime, const char* courseCode) {
  struct Exam* e = (struct Exam*)malloc(sizeof(struct Exam));
  e->startTime = startTime;
  e->endTime = endTime;
  strcpy(e->courseCode, courseCode);
  e->next = NULL;

  return e;
}

void PrintExam(struct Exam* exam)
{
  printf("%d %d %s", exam->startTime, exam->endTime, exam->courseCode);
}

