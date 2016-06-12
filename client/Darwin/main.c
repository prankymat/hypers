//
//  main.c
//  hypers_client
//
//  Created by yuuji on 6/10/16.
//  Copyright © 2016 yuuji. All rights reserved.
//

#include <stdio.h>
#include <spartanX/spartanX.h>

void decryp(void * data, size_t len) {
}

int main(int argc, const char * argv[]) {
    chroot(argv[0]);
    sx_server_setup setup = {AF_INET, 5555, 50, 8192, 5, false};
    SXServerRef server = SXCreateServer(setup, NULL, ^size_t(sx_runtime_object_t *object, void *data, size_t length) {
        decryp(data, length);

        int pfds[2];
        pipe(pfds);
        
        pid_t pid;

        
        if (!(pid = fork())) {
            

            object->owner = NULL;

            size_t bytes = ((size_t *)data)[0];

            char* pos[((size_t *)data)[1]];

            
            for (size_t i = 0, j = 0; i < bytes; ++i) {
                if (*((char *)data + 2 * sizeof(size_t) + i) == 0x20) {
                    pos[j] = ((char *)data + 2 * sizeof(size_t) + i + 1);
                    *((char *)data + 2 * sizeof(size_t) + i) = 0x00;
                    ++j;
                }
            }
            
            close(1);
            dup(object->sock->sockfd);
            close(pfds[0]);

            execlp(pos[0], &pos[1]);
            
        } else if (pid == -1) {
            perror("fork");
        } else {
            waitpid(pid, NULL, 0);
            printf("exit\n");
            return length;
        }
    
        return length;
    });
    
    SXServerStart2(server, GCD_DEFAULT);
    
    while (1) {
//        sleep(100000);
    }
    return 0;
}
