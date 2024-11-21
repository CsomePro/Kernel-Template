#define _GNU_SOURCE
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <stdbool.h>
#include <string.h>
#include <pthread.h>
#include <fcntl.h>
#include <errno.h>
#include <poll.h>
#include <stdint.h>
#include <sys/ioctl.h>
#include <sys/mman.h>
#include <sys/syscall.h>
#include <sys/resource.h>
#include <sys/mount.h>

#include <stdatomic.h>
#include <sys/wait.h>


#define WRITE_ONCE(x, val)						\
do {									\
	*(volatile typeof(x) *)&(x) = (val);				\
} while (0)

#define READ_ONCE(x)	(*(const volatile __unqual_scalar_typeof(x) *)&(x))

#define outfile (stderr)

#define LOGGING

#ifdef LOGGING
#define _do_log(prefix, fmt, ...) do { fprintf(outfile, prefix  " %s: " fmt "\n", __func__, ##__VA_ARGS__);} while(0)
#define log_info(fmt, ...) _do_log("[+] ", fmt,  ##__VA_ARGS__)
#define log_fail(fmt, ...) _do_log("[-] ", fmt,  ##__VA_ARGS__)
#define log_error(fmt, ...) log_fail("%s (%d) - " fmt, strerror(errno), errno, ##__VA_ARGS__)
#define log_debug log_info
#else
#define _do_log(prefix, fmt, ...) //do { fprintf(outfile, prefix  " %s: " fmt "\n", __func__, ##__VA_ARGS__);} while(0)
#define log_info(fmt, ...) //_do_log("[+] ", fmt,  ##__VA_ARGS__)
#define log_fail(fmt, ...) //_do_log("[-] ", fmt,  ##__VA_ARGS__)
#define log_error(fmt, ...) //log_fail("%s (%d) - " fmt, strerror(errno), errno, ##__VA_ARGS__)
#define log_debug log_info
#endif

#define log_info_ts(fmt, ...) \
({ \
    struct timespec __now; \
    clock_gettime(CLOCK_MONOTONIC, &__now); \
    log_info("(@ %ld.%.9ld) " fmt, __now.tv_sec, __now.tv_nsec, ##__VA_ARGS__); \
})


void hexdump(const void* data, size_t size)
{
    char ascii[17];
    size_t i, j;
    ascii[16] = '\0';
    for (i = 0; i < size; ++i) {
        printf("%02X ", ((unsigned char*)data)[i]);
        if (((unsigned char*)data)[i] >= ' ' && ((unsigned char*)data)[i] <= '~') {
            ascii[i % 16] = ((unsigned char*)data)[i];
        } else {
            ascii[i % 16] = '.';
        }
        if ((i+1) % 8 == 0 || i+1 == size) {
            printf(" ");
            if ((i+1) % 16 == 0) {
                printf("|  %s \n", ascii);
            } else if (i+1 == size) {
                ascii[(i+1) % 16] = '\0';
                if ((i+1) % 16 <= 8) {
                    printf(" ");
                }
                
                for (j = (i+1) % 16; j < 16; ++j) {
                    printf("   ");
                }
                printf("|  %s \n", ascii);
            }
        }
    }
}

int pin_cpu_for(pid_t tid, int cpu)
{
    cpu_set_t cpuset;
    CPU_ZERO(&cpuset);
    CPU_SET(cpu, &cpuset);
    if (sched_setaffinity(tid, sizeof(cpuset), &cpuset) < 0) {
        log_error("sched_setaffinity() (cpu=%d)", cpu);
        return -1;
    }
    return 0;
}

int pin_cpu(int cpu)
{
    return pin_cpu_for(0, cpu);
}


int main(int argc, char** argv)
{

    return 0;

}