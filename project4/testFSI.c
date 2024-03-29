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



void readfile(char* name){
   int fd;
   int size = 512;
   int n = 1;
   int i;
   char buf[size];
   int r;

   fd = open(name, O_RDONLY);

   printf(1, "Reading FILE %d\n", fd);
   for (i = 0; i < n; i++) {
      r = read(fd, buf, size);
      printf(1, "r = %d", r);
   }

}
void writefile(char* name){
   int fd;
   int size = 512;
   int n = 1;
   int i;
   char buf[size];
   int r;

   printf(1, "FILE size = %d\n", n * size);
   printf(1, "buffer size = %d\n", size);

  
   fd = open(name, O_CREATE | O_CHECKED | O_RDWR);
   

   memset(buf, 0, size);

   printf(1, "writing FILE: %d\n", fd);
   for (i = 0; i < n; i++) {
      buf[0] = (char)('A' + i);
      r = write(fd, buf, size);
      printf(1, "r = %d, size = %d\n", r, size);
      
   }
   r = close(fd);
}
void createfile(char * name)
{
   writefile(name);
   readfile(name);
}
int main(int argc, char *argv[]){
  
  if(argc != 2){
    printf(1, "input error, usage: testFSI FILE_PATH");
    return 0; 
  }
  createfile(argv[1]);
  struct stat mystat;
  struct stat * ptr = &mystat;
  stat(argv[1], ptr);
  printf(1, "file type %d, file size %d, file checksum %d\n", ptr->type, ptr->size, (uchar)ptr->checksum);
  exit();
  return 0; 
}