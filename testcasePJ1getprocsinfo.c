#include "param.h"
#include "types.h"
#include "stat.h"
#include "user.h"
#include "fs.h"
#include "fcntl.h"
#include "syscall.h"
#include "traps.h"
#include "memlayout.h"
#include "procinfo.h"


void
getprocsinfotest(){
  struct procinfo info[64];
  int procnum = getprocsinfo(info);
  if(procnum < 0)
  {
    printf("getprocsinfo test failed");
	exit();
  }
  else{
	printf("amount of processes:%d\n", procnum);

	struct procinfo *in;
  	for(in = info; in < &info[procnum]; in++)
    {
	  printf("pid:%d, name:%s\n", in->pid, in->pname);
    }
	exit();
  }
}


int
main(int argc, char *argv[])
{
  printf("testgetprocsinfo starting\n");
  getprocsinfotest();
  exit();
}