#include <stdio.h>    
#include <stddef.h>
#include "../include/min_heap.h"
#include <stdbool.h>
#include <stdlib.h>

// Creates a new heap with initial capacity
// Element_size specifies the size of stored elements in bytes
// Compare function must return negative if first argument is smaller
MinHeap* heap_create(size_t capacity, size_t element_size, 
                    int (*compare)(const void*, const void*))
{
  MinHeap* min = (MinHeap*)malloc(sizeof(MinHeap));
  min->capacity = capacity;
  min->element_size = element_size;
  min->size = 0;
  min->compare = compare;
  min->data = (void*)malloc(element_size * capacity);

  return min;
}

// Deallocates all memory used by the heap
void heap_destroy(MinHeap* heap)
{
  if(heap)
  {
    free(heap->data);
    free(heap);  
  }
  
}

// Adds new element to heap
// Element is added at the end and bubbled up to maintain heap property
// If heap is full, capacity is doubled automatically
// Returns 1 if successful, 0 if memory allocation fails
int heap_insert(MinHeap* heap, const void* element)
{
  if(heap->capacity == heap->size)
    heap_expand(heap);
  if(heap->data == NULL)
    return 0;
  if(heap->size == 0)
  {
    memcpy(heap->data, element, heap->element_size);
    heap->size++;
    return 1;
  }
  
  memcpy((char*)(heap->data) + (heap->element_size * heap->size), element, heap->element_size);
  size_t tmpIndex = heap->size;
  void* tmp = (void*)malloc(heap->element_size);

  if(tmp == NULL)
    return 0;

  void* parent = (char*)(heap->data) + (heap->element_size * ((tmpIndex - 1) / 2));// parent address
  void* child = (char*)(heap->data) + heap->element_size * tmpIndex;


  while(heap->compare(child, parent) < 0)
  {
    memcpy(tmp, parent, heap->element_size); // hold greater element
    //printf("Temp: %d\n", *(int*)tmp);
    //printf("Pasted: %d to %d\n", *(int*)child, *(int*)parent);
    memcpy(parent, child, heap->element_size); // paste the smaller element to greater element place
    memcpy(child, tmp, heap->element_size); // paste the greater element to preveious place of smaller element

    tmpIndex = (tmpIndex - 1) / 2;
    if(tmpIndex == 0)
      break;

    parent = (char*)(heap->data) + heap->element_size * ((tmpIndex - 1)/2);
    child = (char*)(heap->data) + heap->element_size * tmpIndex;
  }

  heap->size++;
  free(tmp);
  return 1;
}

// Removes and returns the minimum element (root)
// Last element is moved to root and bubbled down
// Returns 1 if successful, 0 if heap is empty
int heap_extract_min(MinHeap* heap, void* result)
{
  if(heap->size == 0 || heap == NULL)
    return 0;
  memcpy(result, heap->data, heap->element_size);

  memcpy(heap->data, (char*)(heap->data) + heap->element_size * (heap->size - 1), heap->element_size); // copy last element to the root
  heap->size--;
  // Buble down the root right there
  if(heap->size == 0)
    return 1;

  int index = 0;

  
  if(2 * index + 1 > heap->size - 1)
    return 1;

  bool isBothChild = true;
  if(2 * index + 1 == heap->size - 1)
  {
    isBothChild = false;
  }
  

  void* parent = (char*)(heap->data) + heap->element_size * index;
  void* child1 = (char*)(heap->data) + heap->element_size * (2 * index + 1);
  void* child2 = (char*)(heap->data) + heap->element_size * (isBothChild ? 2 * index + 2 : 2 * index + 1);
  
  
  void* tmp = (void*)malloc(heap->element_size);

  while(heap->compare(child1, parent) < 0 || heap->compare(child2, parent) < 0)
  {
    isBothChild = true;
    if(heap->compare(child1, child2) < 0)
    {
      //parent = (char*)(heap->data) + heap->element_size * index;
      //child1 = (char*)(heap->data) + heap->element_size * (2*index + 1);

      memcpy(tmp, parent, heap->element_size);
      memcpy(parent, child1, heap->element_size);
      memcpy(child1, tmp, heap->element_size);
      index = 2 * index + 1;
      

    } else {
      //parent = (char*)(heap->data) + heap->element_size * index;
      //child2 = (char*)(heap->data) + heap->element_size * (2 * index + 2);

      memcpy(tmp, parent, heap->element_size);
      memcpy(parent, child2, heap->element_size);
      memcpy(child2, tmp, heap->element_size);
      index = 2 * index + 2;
    }
    
    if(2 * index + 1 > heap->size - 1) {
      free(tmp);
      return 1;
    }
    if(2 * index + 1 == heap->size - 1)
    {
      isBothChild = false;
    }

    parent = (char*)(heap->data) + heap->element_size * index;
    child1 = (char*)(heap->data) + heap->element_size * (2 * index + 1);
    child2 = (char*)(heap->data) + heap->element_size * (isBothChild ? 2 * index + 2 : 2 * index + 1);
  }
  free(tmp);

  return 1;
}

// Returns the minimum element without removing it
// Returns 1 if successful, 0 if heap is empty
int heap_peek(const MinHeap* heap, void* result)
{
  if(heap == NULL || heap->size == 0)
    return 0;
  memcpy(result, heap->data, heap->element_size);
  return 1;
}

// Returns current number of elements in heap
size_t heap_size(const MinHeap* heap)
{
  if(heap)
    return (size_t)heap->size;
  return -1;
}

// Merges heap2 into heap1
// Grows capacity of heap1 if needed
// Returns 1 if successful, 0 if memory allocation fails or heaps are incompatible
int heap_merge(MinHeap* heap1, const MinHeap* heap2)
{
  if(!heap2 || heap2->size == 0 || heap1->element_size != heap2->element_size)
    return 0;
  
  char* element = (char*)(heap2->data);
  
  while(element != (char*)(heap2->data) + heap2->element_size * heap2->size)
  {
    if(heap_insert(heap1, element) == 0)
      return 0;
    element += heap2->element_size; 
  }
  return 1;
}

void heap_expand(MinHeap* heap)
{
  void* temp = (void*)realloc(heap->data, heap->element_size * heap->capacity * 2);
  if(!temp)
    return;
  heap->capacity = heap->capacity * 2;
  heap->data = temp;
}   