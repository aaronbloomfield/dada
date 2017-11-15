#include <stdio.h>

void do_something_with(char *buffer) {
  printf ("%s", buffer);
}

void vulnerable() {
    char buffer[100];
	
    /* read string from stdin */
    scanf("%s", buffer);
	
    do_something_with(buffer);
}

int main() {
  vulnerable();
  return 0;
}
