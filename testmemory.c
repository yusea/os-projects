#include "types.h"
#include "stat.h"
#include "user.h"

int main(int argc, char* argv[])
{

    //int p = 0;
    char* test;
    char value = 'a';
    char *x = &value;
    int pid = -2;

    if((pid = fork()) == 0)
    {
        if(fork() == 0){
            test = (char*)shmem_access(0);
            int count1 = shmem_count(0);
            printf(1, "share memory index 0, %d number process in use\n", count1);
            *test = 'b';
            *x = 'c';
            printf(1, "test sub A: test addr:%x, test value:%c, x addr:%x, x value:%c\n", test, *test, x, *x);
        } else{
            wait();
            //for(int i = 0; i < 100000;i++);
            test = (char*)shmem_access(0);
            int count2 = shmem_count(0);
            printf(1, "share memory index 0, %d number process in use\n", count2);
            *test = 'd';
            //	test = (int*)p;
            printf(1, "test sub B: test addr:%x, test value:%c, x addr:%x, x value:%c\n", test, *test, x, *x);

        }
    }
    else{

        wait();
        //for(int i = 0; i < 100000;i++);
        test = (char*)shmem_access(0);
        int count3 = shmem_count(0);
        printf(1, "share memory index 0, %d number process in use\n", count3);
        // test = (int*)p;
        printf(1, "test origin: test addr:%x, test value:%c, x addr:%x, x value:%c\n", test, *test, x, *x);

    }
    printf(1,"pid:%d\n", pid);
    exit();
}
