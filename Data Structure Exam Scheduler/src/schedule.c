#include "schedule.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// Create a new schedule with 7 days
struct Schedule* CreateSchedule() {
  struct Schedule* sc = (struct Schedule*)malloc(sizeof(struct Schedule));
  
  struct Day* Monday = (struct Day*)malloc(sizeof(struct Day));
  struct Day* Tuesday = (struct Day*)malloc(sizeof(struct Day));
  struct Day* Wednesday = (struct Day*)malloc(sizeof(struct Day));
  struct Day* Thursday = (struct Day*)malloc(sizeof(struct Day));
  struct Day* Friday = (struct Day*)malloc(sizeof(struct Day));
  struct Day* Saturday = (struct Day*)malloc(sizeof(struct Day));
  struct Day* Sunday = (struct Day*)malloc(sizeof(struct Day));
  
  strcpy(Monday->dayName, "Monday");
  Monday->examList = NULL;
  Monday->nextDay = Tuesday;

  strcpy(Tuesday->dayName, "Tuesday");
  Tuesday->examList = NULL;
  Tuesday->nextDay = Wednesday;

  strcpy(Wednesday->dayName, "Wednesday");
  Wednesday->examList = NULL;
  Wednesday->nextDay = Thursday;

  strcpy(Thursday->dayName, "Thursday");
  Thursday->examList = NULL;
  Thursday->nextDay = Friday;

  strcpy(Friday->dayName, "Friday");
  Friday->examList = NULL;
  Friday->nextDay = Saturday;

  strcpy(Saturday->dayName, "Saturday");
  Saturday->examList = NULL;
  Saturday->nextDay = Sunday;

  strcpy(Sunday->dayName, "Sunday");
  Sunday->examList = NULL;
  Sunday->nextDay = Monday;

  sc->head = Monday;

  printf("Schedule creation complete.\n");

  return sc;
}

// Add an exam to a day in the schedule
int AddExamToSchedule(struct Schedule* schedule, const char* day, int startTime, int endTime, const char* courseCode) {
  
  if(endTime - startTime > 3 || startTime < 8 || startTime > 17 || endTime < 9 || endTime > 20)
  {
    return 3;
  }

  struct Day* examDay = schedule->head;
  while(strcmp(examDay->dayName, day))
    examDay = examDay->nextDay;


  switch(AddExamToADay(schedule, examDay, startTime, endTime, courseCode))
  {
    case 0: printf(" %s exam added to %s at time %d to %d without conflict .\n", courseCode, day, startTime, endTime);
      return 0;
    case 1: struct Exam* exam = SearchCourse(schedule, day, courseCode);
      printf(" %s exam added to %s at time %d to %d due to conflict .\n", courseCode, day, exam->startTime, exam->endTime);
      return 1;
  }

  struct Day* NextDay = schedule->head;

  while(strcmp(NextDay->dayName, day))
    NextDay = NextDay->nextDay;
  
  NextDay = NextDay->nextDay;

  char* nextDayName = NextDay->dayName;
  
  do
  {
    switch(AddExamToADay(schedule, NextDay, 8, 8 + endTime - startTime, courseCode))
    {
      case 0:
      case 1:
      {
        struct Exam* exam = SearchCourse(schedule, NextDay->dayName, courseCode);
        printf(" %s exam added to %s at time %d to %d due to conflict .\n", courseCode, NextDay->dayName, exam->startTime, exam->endTime);
        return 1;
        break;
      }
      case 3: 
      {
        NextDay = NextDay->nextDay;
        break;
      }
    }

  } while(strcmp(NextDay->dayName, nextDayName));

  printf(" Schedule full . Exam cannot be added .\n");
  return 2;
}

// Remove an exam from a specific day in the schedule
int RemoveExamFromSchedule(struct Schedule* schedule, const char* day, int startTime) {
  printf("Remove schedule Activate %s %d\n", day, startTime);
  
  struct Day* examDay = schedule->head;

  while(strcmp(examDay->dayName, day))
  {
    examDay = examDay->nextDay;
  }

  struct Exam* exam = FindExamWithStart(schedule, day, startTime);

  if(exam == NULL)
  {
    printf(" Exam could not be found .\n");
    return 1;
  }

  struct Exam* prev = examDay->examList;

  if(exam == prev)
  {
    examDay->examList = exam->next;
    free(exam);
    printf(" Exam removed successfully .\n");
    return 0;
  }
  
  while(prev->next != exam )
    prev = prev->next;

  prev->next = exam->next;
  free(exam);
  printf(" Exam removed successfully .\n");
  return 0;

}

// Update an exam in the schedule
int UpdateExam(struct Schedule* schedule, const char* oldDay, int oldStartTime, const char* newDay, int newStartTime, int newEndTime) {
  printf("Update Exam %s %d with %s %d\n", oldDay, oldStartTime, newDay, newStartTime);

  if(newEndTime - newStartTime > 3 || newStartTime < 8 || newStartTime > 17 || newEndTime < 9 || newEndTime > 20)
  {
    printf(" Invalid exam .\n");
    
    PrintSchedule(schedule);
    return 3;
  }

  struct Exam* oldExam = FindExamWithStart(schedule, oldDay, oldStartTime);
  
  
  if(oldExam == NULL)
  {
    printf(" Exam could not be found .\n");
    
    PrintSchedule(schedule);  
    return 2;
  }

  char Name[25];
  strcpy(Name, oldExam->courseCode);

  struct Exam* conflict = CheckConflict(schedule, newDay, newStartTime, newEndTime);

  if(conflict == NULL)
  {
    RemoveExamFromSchedule(schedule, oldDay, oldStartTime);
    AddExamToSchedule(schedule, newDay, newStartTime, newEndTime, Name);
    printf(" Update successful .\n");
    
    PrintSchedule(schedule);  
    return 0;
  }

  if(conflict != oldExam)
  {
    printf(" Update unsuccessful .\n");
    
    PrintSchedule(schedule);
    return 1;
  } else if(conflict == oldExam){

    struct Exam* Temp = (struct Exam*)malloc(sizeof(struct Exam));
    Temp->startTime = oldExam->startTime;
    Temp->endTime = oldExam->endTime;
    strcpy(Temp->courseCode, oldExam->courseCode);

    RemoveExamFromSchedule(schedule, oldDay, oldStartTime);

    conflict = CheckConflict(schedule, newDay, newStartTime, newEndTime);

    if(conflict != NULL)
    {
      AddExamToSchedule(schedule, oldDay, oldStartTime, Temp->endTime, Temp->courseCode);
      printf(" Update unsuccessful .\n");
      free(Temp);
      
      PrintSchedule(schedule);
      return 1;
    } else if(conflict == NULL){
      AddExamToSchedule(schedule, newDay, newStartTime, newEndTime, Temp->courseCode);
      printf(" Update successful .\n");
      free(Temp);

      PrintSchedule(schedule);
      return 0;      
    }
  } 
  return 1;
}

// Clear all exams from a specific day and relocate them to other days
int ClearDay(struct Schedule* schedule, const char* day) {
  printf("Clear day %s\n", day);
  
  struct Day* CanceledDay = schedule->head;

  while(strcmp(CanceledDay->dayName, day))
    CanceledDay = CanceledDay->nextDay;

  struct Exam* exams = CanceledDay->examList;

  if(exams == NULL)
  {
    printf(" %s is already clear .\n", day);

    PrintSchedule(schedule);
    return 1;
  }

  char test[25];
  strcpy(test, "TestExam");

  struct Day* NEXTDAY = CanceledDay->nextDay;
  
  //Check if there is enough space for the day

  int check;
  while(exams)
  {
    NEXTDAY = CanceledDay->nextDay;
    do
    {
      check = 1;
      switch(AddExamToADay(schedule, NEXTDAY, 8, 8 + exams->endTime - exams->startTime, test))
      {
        case 0:
        case 1:
        {
          printf(" %s exam added to %s.\n", test, NEXTDAY->dayName);
          check = 0;
          exams = exams->next;
          break;
        }
        case 3: 
        {
          NEXTDAY = NEXTDAY->nextDay;
          if(strcmp(NEXTDAY->dayName, CanceledDay->dayName) == 0)
          {
            ClearTests(schedule);
            printf("Schedule full . Exams from %s could not be relocated .\n", day);
            return 2;
          }
          break;
        }
      }
    } while(check);
    
  }


  // There is enough space lets realocate them;
  ClearTests(schedule);
  exams = CanceledDay->examList;
  while(exams)
  {
    AddExamToSchedule(schedule, CanceledDay->nextDay->dayName, exams->startTime, exams->endTime, exams->courseCode);
    RemoveExamFromSchedule(schedule, CanceledDay->dayName, exams->startTime);
    exams = CanceledDay->examList;
  }

  printf("%s is cleared , exams relocated .\n", day);

  PrintSchedule(schedule);
  return 0;
}

// Clear all exams and days from the schedule and deallocate memory
void DeleteSchedule(struct Schedule* schedule) {
  printf("Delet schedule\n");
  struct Day* day = schedule->head;
  do
  {
    DeleteADay(day);
    day = day->nextDay;
  } while(strcmp(day->dayName, "Monday"));
  
  for(int i = 0; i < 7; i++)
  {
    schedule->head = schedule->head->nextDay;
    free(day);
    day = schedule->head;
  }
  day = NULL;
  schedule->head = NULL;
  return;
}

// Read schedule from file
int ReadScheduleFromFile(struct Schedule* schedule, const char* filename) {
  printf("Read Schedule Activate\n");
  
  //FILE *file1 = fopen(filename, "r");
  FILE *file2 = fopen(filename, "r");

  if( file2 == NULL)
  {
    printf("File opening error.\n");
    return 1;
  }

  char day[15];
  char exam[15];
  int start;
  int end;


  while((fscanf(file2, "%s\n", day) == 1))
  {
    printf("%s\n", day);
    while(fscanf(file2, "%d %d %s\n", &start, &end, exam) == 3)
    {
      printf("%d %d %s\n", start, end, exam);
      AddExamToSchedule(schedule, day, start, end, exam);
    }
  }

  PrintSchedule(schedule);

  printf("Read schedule successful!\n");

  fclose(file2);
  return 0;
}

// Write schedule to file
int WriteScheduleToFile(struct Schedule* schedule, const char* filename) {
  printf("Write Schedule Activate\n");

  FILE *file = fopen(filename, "w");

  if(file == NULL)
  {
    printf("File opening error!\n");
    return 1;
  }
  struct Day* day = schedule->head;

  do
  {
    struct Exam* exam = day->examList;
    fprintf(file, "%s\n", day->dayName);

    if(exam == NULL)
    {
      fprintf(file, "\n");
      day = day->nextDay;
      continue;
    }

    while(exam)
    {
      fprintf(file, "%d %d %s\n", exam->startTime, exam->endTime, exam->courseCode);
      exam = exam->next;
    }
    fprintf(file, "\n");
    day = day->nextDay;
  } while (strcmp(day->dayName, "Monday"));

  fclose(file);
  printf("Writing is done succesfuly.\n");
  return 0;
}

// Add an exam to a day
int AddExamToADay(struct Schedule* schedule, struct Day* day, int startTime, int endTime, const char* courseCode)
{
  if(endTime - startTime > 3 || startTime < 8 || startTime > 17 || endTime < 9 || endTime > 20)
  {
    return 3;
  }
  
  struct Exam* conflict = CheckConflict(schedule, day->dayName, startTime, endTime);

  if(conflict != NULL)
  {
    switch(AddExamToADay(schedule, day, conflict->endTime, conflict->endTime + endTime - startTime, courseCode))
    {
      case 0: return 1;
        break;
      case 1: return 1;
        break;
      case 3: return 3;
        break;
    }
  }
  
  struct Exam* examList = day->examList;
  struct Exam* exam = (struct Exam*)malloc(sizeof(struct Exam));
  exam->startTime = startTime;
  exam->endTime = endTime;
  strcpy(exam->courseCode, courseCode);

  //Try to put it head
  if(examList == NULL || endTime <= examList->startTime)
  {
    exam->next = examList;
    day->examList = exam;
    return 0;
  }

  //Try to put it Tail
  struct Exam* examTail = examList;
  while(examTail->next)
  {
    examTail = examTail->next;
  }

  if(startTime >= examTail->endTime)
  {
    examTail->next = exam;
    exam->next = NULL;
    return 0;
  }

  //Try Between

  struct Exam* examPre = examList;
  struct Exam* examNext = examList->next;

  while(examNext)
  {
    if(examPre->endTime <= startTime && examNext->startTime >= endTime)
    {
      exam->next = examNext;
      examPre->next = exam;
      return 0;
    }
    examNext = examNext->next;
    examPre = examPre->next;
  }
  return 2;
}

void PrintSchedule(struct Schedule* schedule)
{
  struct Day* day = schedule->head;
  struct Exam* examlist;

  printf("\n");
  do
  {
    examlist = day->examList;
    printf("Day: %s\n", day->dayName);
    while(examlist)
    {
      printf("  %s %d %d\n", examlist->courseCode, examlist->startTime, examlist->endTime);
      examlist = examlist->next;
    }
    day = day->nextDay;

  } while(strcmp(day->dayName, "Monday"));
  return;

}

struct Exam* FindExamWithStart(struct Schedule* schedule, const char* day, int startTime)
{
  struct Day* examDay = schedule->head;
  

  while(strcmp(day, examDay->dayName))
    examDay = examDay->nextDay;

  struct Exam* exam = examDay->examList;

  while(exam)
  {
    if(exam->startTime == startTime)
      return exam;
    exam = exam->next;
  }

  return exam;

}

struct Exam* CheckConflict(struct Schedule* schedule, const char* day, int startTime, int endTime)
{
  struct Day* examDay = schedule->head;

  while(strcmp(examDay->dayName, day))
    examDay = examDay->nextDay;

  struct Exam* temp = examDay->examList;

  while(temp)
  {
    if(startTime < temp->endTime && endTime > temp->startTime)
      return temp;
    temp = temp->next;
  }
  return NULL;
}

struct Exam* SearchCourse(struct Schedule* schedule, const char* dayName, const char* courseCode)
{
  struct Day* day = schedule->head;
  struct Exam* exam;

  while(strcmp(day->dayName, dayName))
    day = day->nextDay;

  exam = day->examList;
  while(exam)
  {
    if(strcmp(exam->courseCode, courseCode) == 0)
      return exam;
    exam = exam->next;
  }
  return NULL;
}

void DeleteADay(struct Day* day)
{
  struct Exam* exam = day->examList;
  while(exam)
  {
    day->examList = day->examList->next;
    free(exam);
    exam = day->examList;
  }
  return;
}

void ClearTests(struct Schedule* schedule)
{
  struct Day* day = schedule->head;
  struct Exam* exams;

  do
  {
    exams = day->examList;
    
    while(exams)
    {
      exams = SearchCourse(schedule, day->dayName, "TestExam");
      if(exams == NULL) break;
      RemoveExamFromSchedule(schedule, day->dayName, exams->startTime);
      printf("Test exam cleared.\n");
    }
    day = day->nextDay;
  } while (strcmp(day->dayName, "Monday"));
}

struct Exam* Search(struct Schedule* schedule, const char* d, const char* courseCode)
{
  struct Day* day = schedule->head;
  struct Exam* exam;

  while(strcmp(day->dayName, d))
    day = day->nextDay;

  do
  {
    exam = day->examList;
    while(exam)
    {
      if(strcmp(exam->courseCode, courseCode) == 0)
        return exam;
      exam = exam->next;
    }
    day = day->nextDay;
  } while(strcmp(day->dayName, d));

  return NULL;
}