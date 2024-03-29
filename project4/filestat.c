#include "param.h"
#include "types.h"
#include "stat.h"
#include "user.h"
#include "fs.h"
#include "fcntl.h"
#include "syscall.h"
#include "traps.h"
#include "memlayout.h"
#include "pstat.h"

int main(int argc, char *argv[]){
  
  if(argc != 2){
    printf(1, "input error, usage: filestat FILE_PATH");
    return 0; 
  }
  struct stat mystat;
  struct stat * ptr = &mystat;
  stat(argv[1], ptr);
  printf(1, "file type is: %d\nfile size is: %d\nfile checksum is: %d\n", ptr->type, ptr->size, (uchar)ptr->checksum);
  exit();
  return 0; 
}