#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <dlfcn.h>

typedef int (*fptr)(int,int);

int main()
{
    char operator[10];
    int a,b;

    while ( scanf("%s %d %d",operator,&a,&b) != EOF )
    {
        char path[200];
        sprintf(path,"./lib%s.so",operator); 

        void *handle = dlopen(path,RTLD_LAZY);

        if (handle != NULL)
        {
            fptr f = (fptr) dlsym(handle,operator);

            if (f != NULL)
            {
                printf("%d\n",f(a,b));
            }

            dlclose(handle);
        }
    }

    return 0;
}