#include "types.h"
#include "user.h"
#include "stat.h"
#include "param.h"
#include "x86.h"
#include "kthread.h"

#define PGSIZE (4096)

// lock functions
void init_lock(struct lock_t* lk)
{
  lk->locked = 0; 
}
void lock_acquire(struct lock_t* lk)
{
  while (xchg(&lk->locked, 1) != 0); 
}

void lock_release(struct lock_t* lk) 
{
  xchg(&lk->locked, 0);
}

// thread functions
struct kthread_t thread_create(void(*start_routine)(void*), void *arg)
{
  int stack_addr;
  void* stack = malloc(PGSIZE);
  if((uint)stack % PGSIZE != 0){
    free(stack);
    stack = malloc(2*PGSIZE);
    stack_addr = (uint)stack;
    stack = stack + (PGSIZE - (uint)stack % PGSIZE);
  }
  else {
    stack_addr = (uint)stack;
  }
  int pid = clone(start_routine, arg, stack);
  struct kthread_t ktd;
  ktd.pid = pid;
  ktd.stack = (void*)stack_addr;
  return ktd;
}

int thread_join(struct kthread_t ktd)
{
  int pid = join(ktd.pid);
  free(ktd.stack);
  return pid;
}